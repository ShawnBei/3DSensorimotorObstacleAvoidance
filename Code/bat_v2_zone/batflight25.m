function output = batflight25(settings)

delay_window = settings.delay_window;
iteration_steps = settings.iteration_steps;
reflectors = settings.R;
worldshape = settings.worldshape;
max_vel = settings.linear_vel_max;
min_vel = settings.linear_vel_min;
an_max_vel = settings.angular_vel_max;
an_min_vel = settings.angular_vel_min;
% steermatlog = NaN(iteration_steps,4);
batposlog=NaN(iteration_steps,3);
objdistlog = NaN(iteration_steps,1);
% rotation_log_az =NaN(iteration_steps,3);
% rotation_log_el =NaN(iteration_steps,3);
velocities = NaN(iteration_steps,1);
reflectors_nr_Log = NaN(iteration_steps,4);
target = settings.target;
targetsearch = settings.targetsearch;
rand_phase = settings.rand_phase;
reflector_str = settings.reflector_str;
attenuation_range = settings.attenuation_range;
inner_zone = settings.innerzone;
outer_zone = settings.outerzone;
ipi = settings.call_freq;

X=reflectors(:,1);Y=reflectors(:,2);Z=reflectors(:,3);

bat_pos_ini = [0 0 0];
bat_pos = bat_pos_ini;

heading = [0;0;1];
X_axis = [1;0;0];
Y_axis = [0;1;0];

collision = 0;
reaction_time = 50/1000;
tortuosity = 0;

min_phase = -20/180*pi;
max_phase = 20/180*pi;

for iteration = 1:iteration_steps
    
    [az,el,objrange]= mycart2sph(X,Y,Z);
    
    % reflector strength
    if reflector_str == 1
        reflector_strenght =randrange(min(attenuation_range(:)),max(attenuation_range(:)),size(az,1));
    elseif reflector_str == 0
        reflector_strenght = -10;
    end  
    
    
    LEFT    = call(1, az, objrange, delay_window,reflector_strenght);
    RIGHT   = call(2, az, objrange, delay_window,reflector_strenght);
    TOP     = call(3, el, objrange, delay_window,reflector_strenght);
    BOTTOM  = call(4, el, objrange, delay_window,reflector_strenght);
    
    
    %% get closest distance
    objdist_L = LEFT.range;
    objdist_R = RIGHT.range;
    objdist_T = TOP.range;
    objdist_B = BOTTOM.range;
    objdist = [objdist_L(:);objdist_R(:);objdist_T(:);objdist_B(:)];
    if isempty(objdist);objdist=1000;end
    if isnan(objdist);objdist=1000;end
    closest_distance = min(objdist);
    
    
    %% calculate the desired velocity
    linear_velocity = interp1([20000 5 0],[max_vel max_vel min_vel],closest_distance);
    if isnan(linear_velocity);linear_velocity=max_vel;end
    
    %%%% angular velocity related to linear velocity
    %     angular_vel = interp1([0 10],[666 -500],linear_velocity);
    angular_vel = interp1([0 max_vel],[an_max_vel an_min_vel],linear_velocity);
    if angular_vel<0;angular_vel=0;end
    
    %set rotation time and processing time
    processing_time = 2*(closest_distance/343) + reaction_time + delay_window;
    rotation_time = ipi - processing_time;
    if rotation_time < 0;rotation_time = 0;end
    if processing_time > ipi;processing_time=ipi;end
    
    %% bat steering--------
    if rand_phase==1
        leftgains = LEFT.gains_linear.*exp(sqrt(-1)*randrange(min_phase,max_phase,size(LEFT.gains_linear,1)));
        rightgains = RIGHT.gains_linear.*exp(sqrt(-1)*randrange(min_phase,max_phase,size(RIGHT.gains_linear,1)));
        topgains = TOP.gains_linear.*exp(sqrt(-1)*randrange(min_phase,max_phase,size(TOP.gains_linear,1)));
        bottomgains = BOTTOM.gains_linear.*exp(sqrt(-1)*randrange(min_phase,max_phase,size(BOTTOM.gains_linear,1)));
    end
    if rand_phase==0
        leftgains = LEFT.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(LEFT.gains_linear,1)));
        rightgains = RIGHT.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(RIGHT.gains_linear,1)));
        topgains = TOP.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(TOP.gains_linear,1)));
        bottomgains = BOTTOM.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(BOTTOM.gains_linear,1)));
    end
    
    % number of relectors after selection
    nr_reflectors = [sum(LEFT.gains > 0) sum(RIGHT.gains > 0) sum(TOP.gains > 0) sum(BOTTOM.gains > 0)];
    
    
    %% gt
    steermat = [abs(sum(leftgains)), abs(sum(rightgains)), abs(sum(topgains)), abs(sum(bottomgains))];
    steermat = 20*log10(steermat/(2*10.^-5));
    steermat(isinf(steermat))=0;
    [~,minindexLR]=min(steermat(1,1:2));
    [~,minindexTB]=min(steermat(1,3:4));
    options = [1 -1;-1 1];
    current_az_sign = options(1,minindexLR);
    current_el_sign = options(2,minindexTB);
    
    % scale azimuth and elevation rotation with rotation time
    current_az=deg2rad(current_az_sign*angular_vel*rotation_time);
    current_el=deg2rad(current_el_sign*angular_vel*rotation_time);
    
    az_temp = current_az;
    el_temp = current_el;
    
    
    %% Collision times
    if closest_distance <= 0.15
        collision = collision + 1;
    end
    
    
    %% Destination check
    % if reach destination, break from iteration
    target_vector = target - bat_pos;
    target_distance = norm(target_vector);
    
    if target_distance <= 0.5
        break;
    end
    
    %% target search / prefered height
    if targetsearch == 1
        
        % outside the zone
        if closest_distance > outer_zone
            
            % Calculate target vector and the desired turning angle(az and el)
            target_az = atan2(target_vector(3), target_vector(1));  % target position
            bat_az = atan2(heading(3),heading(1));                  % bat position
            target_el = target_vector(2);                           % target height
            bat_el = heading(2);                                    % bat height
            
            % Compare heading and target vector
            delta_az = target_az - bat_az;
%             delta_el = 0.35*(target_el - bat_el);
%             delta_el = ((1/a)^abs(target_el - bat_el)) *(target_el - bat_el);
            delta_el = -0.006*abs(target_el - bat_el)*(target_el - bat_el) +0.3;
            
            % constrain delta_az between -pi to pi
            % no need for delta_el, because delta_el is not angle
            % delta_el is similar to a PID controller
            if delta_az > pi
                delta_az = -2*pi + delta_az;
            elseif delta_az < -pi
                delta_az = 2*pi + delta_az;
            end
            
            % Determine if delta angle can be achieved in this iteration
            % if can't (delta is bigger than max_angle), delta = max_angle
            delta_az_abs = abs(delta_az);
            delta_el_abs = abs(delta_el);
            Max_angle = deg2rad(angular_vel * rotation_time);
            %             Max_angle_el = (1/2.5)^abs(target_el - bat_el);
%             Max_angle_el = -0.03*(target_el - bat_el) + 0.3;
            
            if delta_az_abs < Max_angle
                current_az = delta_az;
            else
                current_az = sign(delta_az) * Max_angle;
            end
            if delta_el_abs < Max_angle
                current_el = delta_el;
            else
                current_el = sign(delta_el) * Max_angle;
            end
         
            
            
        % inside the zone
        elseif closest_distance >= inner_zone && closest_distance <= outer_zone
            
            target_vector = target - bat_pos;
            target_az = atan2(target_vector(3), target_vector(1));  % target position
            bat_az = atan2(heading(3),heading(1));                  % bat position
            target_el = target_vector(2);                           % target height
            bat_el = heading(2);                                    % bat height
            delta_az = target_az - bat_az;
%             delta_el = 0.35*(target_el - bat_el);
%             delta_el = ((1/a)^abs(target_el - bat_el)) *(target_el - bat_el);
%             delta_el = (-0.07*(target_el - bat_el) +0.2) *(target_el - bat_el);
            sign_el = sign(target_el - bat_el);
            delta_el = sign_el*(-0.006*(target_el - bat_el)^2 +0.3);
            
            if delta_az > pi
                delta_az = -2*pi + delta_az;
            elseif delta_az < -pi
                delta_az = 2*pi + delta_az;
            end
            
            delta_az_abs = abs(delta_az);
            delta_el_abs = abs(delta_el);
            Max_angle = deg2rad(angular_vel * rotation_time);
            
            if delta_az_abs < Max_angle
                current_az = delta_az;
            else
                current_az = sign(delta_az) * Max_angle;
            end
            if delta_el_abs < Max_angle
                current_el = delta_el;
            else
                current_el = sign(delta_el) * Max_angle;
            end
            
            m = (closest_distance-inner_zone)/(outer_zone-inner_zone);
            current_az = m * current_az + (1-m) * az_temp;
            current_el = m * current_el + (1-m) * el_temp;
            
        end
    end
    
    
    %% constrain on elevation
    if strcmp(worldshape,'H');current_el=0;end
    
    %% move world--during processing and wait
    movement = linear_velocity * processing_time;
    [X,Y,Z] = worldflow([X,Y,Z], 0, 0, movement);
    bat_pos_temp = bat_pos + heading' * movement;
    tortuosity = tortuosity + norm(bat_pos_temp - bat_pos);
    bat_pos = bat_pos_temp;
    
    %% move world--during rotation time
    movement = linear_velocity * rotation_time;
    [X,Y,Z] = worldflow([X,Y,Z], current_az, current_el, movement);
    [heading,Y_axis,X_axis] = headingRot(heading,Y_axis,X_axis,current_el,current_az);
    bat_pos_temp = bat_pos + heading' * movement;
    tortuosity = tortuosity + norm(bat_pos_temp - bat_pos);
    bat_pos = bat_pos_temp;
    
    %% logging
    reflectors_nr_Log(iteration,:) = nr_reflectors;
%     steermatlog(iteration,:)    = steermat;
    objdistlog(iteration)       = closest_distance;
    batposlog(iteration,:)      = bat_pos;
%     rotation_log_az(iteration)  = current_az;
%     rotation_log_el(iteration)  = current_el;
    displayinfo = [iteration rad2deg(current_az) rad2deg(current_el)];
    str =sprintf('%+03.2f\t',displayinfo);
    disp(str);
    velocities(iteration) = linear_velocity;
    
end

output.reflectors_nr       = reflectors_nr_Log;
output.velocities          = velocities;
output.batposlog           = batposlog;
% output.steermatlog         = steermatlog;
output.objdistlog          = objdistlog;
% output.LEFT                = LEFT;
% output.RIGHT               = RIGHT;
% output.objrange            = objrange;
% output.objdist             = objdist;
% output.ipi_log             = ipi_log;
% output.rotation_log_az     = rotation_log_az;
% output.rotation_log_el     = rotation_log_el;
output.iteration_times     = iteration;
output.collision           = collision;
output.tortuosity          = tortuosity;

end