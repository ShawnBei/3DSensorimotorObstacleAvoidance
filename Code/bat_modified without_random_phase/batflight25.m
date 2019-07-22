function output = batflight25(settings)

log_gain_doppler = settings.log_gain_doppler;

delay_window = settings.delay_window;
iteration_steps = settings.iteration_steps;
doplot = settings.doplot;
reflectors = settings.reflectors;
gorandom = settings.gorandom;
worldshape = settings.worldshape;
maxdist = settings.maxdist;
fov = settings.fovea;
earsfixed = settings.earsfixed;
earsfixed_off_axis = settings.earsfixed_off_axis;
max_vel = settings.linear_velocity;
attenuation_range = settings.attenuation_range;
emission_freq = settings.emission_freq;
rand_phase = settings.rand_phase;
max_slope = settings.max_slope;
constrained = settings.constrained;
system = settings.system;

target = settings.target;

steermatlog = NaN(iteration_steps,4);
batposlog=NaN(iteration_steps,3);
objdistlog = NaN(iteration_steps,1);
handlelog = NaN(iteration_steps,1);
ipi_log = NaN(iteration_steps,1);
rotation_log_az =NaN(iteration_steps,3);
rotation_log_el =NaN(iteration_steps,3);
velocities = NaN(iteration_steps,1);
reflectors_nr_Log = NaN(iteration_steps,4);
% reflector_pos_last = NaN(iteration_steps,2002,3);


X=reflectors(:,1);Y=reflectors(:,2);Z=reflectors(:,3);

[az,el,objrange]= mycart2sph(X,Y,Z);
reflectors_pos_last = [az,el,objrange];

bat_pos_ini = [0 0 0];
bat_pos = bat_pos_ini;

heading = [0;0;1];
X_axis = [1;0;0];
Y_axis = [0;1;0];


if doplot==0;mymovie=NaN;end
last_wandering = Inf;
linear_velocity = max_vel;
reaction_time = 50/1000;

for iteration = 1:iteration_steps
    
    [az,el,objrange]= mycart2sph(X,Y,Z);
    
    %     reflector_strenght = randrange(min(attenuation_range(:)),max(attenuation_range(:)),size(az,1));
    reflector_strenght = -20;
    
    LEFT = call(1,  az,objrange,delay_window,reflector_strenght);
    RIGHT= call(2,  az,objrange,delay_window,reflector_strenght);
    TOP = call(3,   el,objrange,delay_window,reflector_strenght);
    BOTTOM = call(4,el,objrange,delay_window,reflector_strenght);
    
    
    %% get closest distance
    objdist_L = LEFT.range;
    objdist_R = RIGHT.range;
    objdist_T = TOP.range;
    objdist_B = BOTTOM.range;
    objdist = [objdist_L(:);objdist_R(:);objdist_T(:);objdist_B(:)];
    if isempty(objdist);objdist=1000;end
    if isnan(objdist);objdist=1000;end
    closest_distance = min(objdist);
    
    %set new timescale, magnitude and lineair velocity
    ipi = 0.1;
    
    %% calculate the desired velocity
    linear_velocity = interp1([2000 5 0],[max_vel max_vel 0.3],closest_distance);
    if isnan(linear_velocity);linear_velocity=max_vel;end
    
    %%%% angular velocity related to linear velocity
    magnitude = interp1([0 10],[666 -500],linear_velocity);
    if magnitude<0;magnitude=0;end
    
    %set  rotation time and processing time
    processing_time = 2*(closest_distance/343) + reaction_time + delay_window;
    rotation_time = ipi - processing_time;
    if rotation_time < 0;rotation_time = 0;end
    if processing_time > ipi;processing_time=ipi;end
    
    %% bat steering--------
    if rand_phase==1
        leftgains = LEFT.gains_linear.*exp(sqrt(-1)*randrange(-pi,pi,size(LEFT.gains_linear,1)));
        rightgains = RIGHT.gains_linear.*exp(sqrt(-1)*randrange(-pi,pi,size(RIGHT.gains_linear,1)));
        topgains = TOP.gains_linear.*exp(sqrt(-1)*randrange(-pi,pi,size(TOP.gains_linear,1)));
        bottomgains = BOTTOM.gains_linear.*exp(sqrt(-1)*randrange(-pi,pi,size(BOTTOM.gains_linear,1)));
    end
    if rand_phase==0
        leftgains = LEFT.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(LEFT.gains_linear,1)));
        rightgains = RIGHT.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(RIGHT.gains_linear,1)));
        topgains = TOP.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(TOP.gains_linear,1)));
        bottomgains = BOTTOM.gains_linear.*exp(sqrt(-1)*randrange(0,0,size(BOTTOM.gains_linear,1)));
    end
    
    nr_reflectors = [sum(LEFT.gains > 0) sum(RIGHT.gains > 0) sum(TOP.gains > 0) sum(BOTTOM.gains > 0)];
    %%%% number of relectors after selection
    
    %% gt
    steermat = [abs(sum(leftgains)), abs(sum(rightgains)), abs(sum(topgains)), abs(sum(bottomgains))];
    steermat = 20*log10(steermat/(2*10.^-5));
    steermat(isinf(steermat))=0;
    [~,minindexLR]=min(steermat(1,1:2));
    [~,minindexTB]=min(steermat(1,3:4));
    options = [1 -1;-1 1];
    current_az_sign = options(1,minindexLR);
    current_el_sign = options(2,minindexTB);
    
    %     if gorandom>0;current_az_sign = randsample([-1,1],1);current_el_sign = randsample([-1,1],1);end
    %     if gorandom>1;magnitude = randrange(0,magnitude,[1 1]);end
    %     if earsfixed == 1;current_el_sign = randsample([-1,1],1);end
    
    %scale azimuth and elevation rotation with rotation time
    current_az=deg2rad(current_az_sign*magnitude*rotation_time);
    current_el=deg2rad(current_el_sign*magnitude*rotation_time);
    
    %% 1. compare current vector and target vector
    %     target_vector = target - bat_pos;
    %     target_az = atan2(target_vector(3), target_vector(1));
    %     target_el = atan2(target_vector(2), target_vector(3));
    %     %target_vector = target_vector/(sqrt(target_vector(1)^2 + target_vector(2)^2 + target_vector(3)^2));
    %
    %     rads = deg2rad(current_el);Rot1 = [1 0 0;0 cos(rads) -sin(rads);0 sin(rads) cos(rads)];
    %     rads = deg2rad(current_az);Rot2 = [cos(rads) 0 -sin(rads);0 1 0;sin(rads) 0 cos(rads)];
    %     bat_current_rot = bat_rot * Rot1 * Rot2;
    %     bat_current_displacement = bat_current_rot * [0;0;1];
    %     bat_current_displacement = bat_current_displacement';
    %     bat_current_az = atan2(bat_current_displacement(3), bat_current_displacement(1));
    %     bat_current_el = atan2(bat_current_displacement(2), bat_current_displacement(3));
    %
    %     delta_az = bat_current_az - target_az;
    %     delta_el = bat_current_el - target_el;
    %
    %     if delta_az > pi
    %         delta_az = 2*pi - delta_az;
    %     elseif delta_az < -pi
    %         delta_az = 2*pi + delta_az;
    %     end
    %     if delta_el > pi
    %         delta_el = 2*pi - delta_el;
    %     elseif delta_el < -pi
    %         delta_el = 2*pi + delta_el;
    %     end
    %
    %     current_az = current_az - delta_az*0.5;
    %     current_el = current_el - delta_el*0.5;
    
    
    %% 2. Fly towards target except the closest distance is smaller than 0.034m
    %(might move this block before current_az calculation)
    
    % Determine if the distance is bigger than 0.034m
        if closest_distance > 0.3
            % Calculate target vector and the desired turning angle(az and el)
            target_vector = target - bat_pos;
            target_az = atan2(target_vector(3), target_vector(1));
%             target_el = atan2(target_vector(2), target_vector(3));
            target_vector_ini = target - bat_pos_ini;
%             target_el = atan2(target_vector_ini(2), target_vector_ini(3));
            target_el = target_vector_ini(2);
            bat_az = atan2(heading(3),heading(1));
%             bat_el = atan2(heading(2),heading(3));
            bat_el = bat_pos(2);
    
            % Compare bat az and target vector
            delta_az = target_az - bat_az;
            delta_el = target_el - bat_el;
%     delta_el
            if delta_az > pi
                delta_az = -2*pi + delta_az;
            elseif delta_az < -pi
                delta_az = 2*pi + delta_az;
            end
%             if delta_el > pi
%                 delta_el = -2*pi + delta_el;
%             elseif delta_el < -pi
%                 delta_el = 2*pi + delta_el;
%             end
    
            % Determine if delta angle can be achieved in this iteration
            delta_az_abs = abs(delta_az);
            delta_el_abs = abs(delta_el);
            Max_angle = deg2rad(magnitude*rotation_time);
    
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
    
        end
    
    
    %% apply elevation and azimuth constraints
%         if strcmp(worldshape,'H');current_el=0;end
%     if strcmp(worldshape,'H');current_az=0;end
    %     if strcmp(worldshape,'T');current_el=0;end
    %     if strcmp(worldshape,'R1');current_el=0;end
    %     if strcmp(worldshape,'R2');current_el=0;end
    %     if strcmp(worldshape,'MH');current_el=0;end
    %     if strcmp(worldshape,'MV');current_az=0;end
    
    %constrain elevation
    %         if current_el > 0;el_step = -0.0873;end     % -5 degrees
    %         if current_el < 0;el_step =  0.0873;end     % 5 degrees
    
    %     el_step =  0.0349;
    
    %%% set constrains to el
    %         while 1
    %
    %             rads = current_el;Rot1 = [1 0 0;0 cos(rads) -sin(rads);0 sin(rads) cos(rads)];
    %             rads = current_az;Rot2 = [cos(rads) 0 -sin(rads);0 1 0;sin(rads) 0 cos(rads)];
    %             predicted_bat_rot = bat_rot *  Rot1 * Rot2;
    %
    %             pointing_vector = predicted_bat_rot*[0;0;1];
    %
    % %             alpha = [0 1 0] * pointing_vector; %dot product (single number)
    % %             angle_y = rad2deg(acos(alpha)); %angle with y vector
    % %             world_elevation = 90 - angle_y;
    %             %disp([angle_y world_elevation])
    %
    %             alpha = atan2(pointing_vector(2),pointing_vector(3));
    %
    % %             elevation_ok = inrange(alpha,[-max_slope max_slope]);
    % % %             if constrained==0;break;end
    % %             if elevation_ok;break;end
    % %             current_el = current_el + el_step;
    %
    %             if alpha > max_slope
    %                 current_el = current_el - el_step;
    %             elseif alpha < -max_slope
    %                 current_el = current_el + el_step;
    %             else
    %                 break;
    %             end
    %
    %         end
    
    
    % wandering handling
    last_wandering = last_wandering + 1;
    %     is_wandering = 0;
    %     if ~strcmp(worldshape(1),'R') && sqrt(sum(bat_pos.^2))>(maxdist-0.15);is_wandering = 1;end
    %     if strcmp(worldshape(1),'R') && ~point_within(bat_pos,X,Y,Z) == 1;is_wandering = 1;end
    %
    %     if is_wandering == 1
    %         homepos = bat_pos*-bat_rot;
    %         [home_az,home_el,~]=mycart2sph(homepos(1),homepos(2),homepos(3));
    %         current_az = home_az;
    %         current_el = -home_el;
    %         rotation_time = 0.1;
    %         handlelog(iteration-1)=1;
    %         last_wandering = 0;
    %     end
    
    %     if last_wandering>1
    %% move world--during processing and wait
    movement = linear_velocity * processing_time;
    %     [X,Y,Z,world_rot] = worldflow([X,Y,Z], 0, 0, world_rot, movement);
    [X,Y,Z] = worldflow([X,Y,Z], 0, 0, movement);
    %     displacement = heading * [0;0;1];
    bat_pos = bat_pos + heading' * movement;
    
    %% move world--during rotation time
    movement = linear_velocity * rotation_time;
    %     [X,Y,Z,world_rot] = worldflow([X,Y,Z], current_az, current_el,world_rot, movement);
    [X,Y,Z] = worldflow([X,Y,Z], current_az, current_el, movement);
    

    W_x = [0             -X_axis(3)      X_axis(2);
           X_axis(3)     0               -X_axis(1);
           -X_axis(2)    X_axis(1)       0        ];     % el

    rads = -current_el;
    RotX = eye(3) + sin(rads) * W_x + (2*(sin(rads/2)^2)) * (W_x^2);
    
    % elevation rotation 
    Y_axis = RotX * Y_axis;
    heading = RotX * heading;
    
     W_y = [0             -Y_axis(3)      Y_axis(2);
           Y_axis(3)     0               -Y_axis(1);
           -Y_axis(2)    Y_axis(1)       0        ];     % az
       
    rads = -current_az;
    RotY = eye(3) + sin(rads) * W_y + (2*(sin(rads/2)^2)) * (W_y^2);

    % azimuth rotation
    X_axis = RotY * X_axis;
    heading = RotY *  heading;
   
    bat_pos = bat_pos + heading' * movement;
    %     reflectors_pos_last = [az,el,objrange];
    
    %     plot3(X(:),Y(:),Z(:),'.b')
    %     hold off
    
    
    %% logging
    
    reflectors_nr_Log(iteration,:) = nr_reflectors;
    steermatlog(iteration,:)=steermat;
    objdistlog(iteration) = closest_distance;
    batposlog(iteration,:)=bat_pos;
    ipi_log(iteration)=ipi;
    rotation_log_az(iteration) = current_az;
    rotation_log_el(iteration) = current_el;
    %     displayinfo = [iteration current_az current_el target_el bat_el delta_el];
    displayinfo = [iteration current_az current_el ];
    str =sprintf('%+03.2f\t',displayinfo);
    disp(str);

    velocities(iteration) = linear_velocity;
    %% Destination check
    
    
end


output.reflectors_nr = reflectors_nr_Log;
output.velocities = velocities;
output.batposlog = batposlog;
output.steermatlog = steermatlog;
output.objdistlog = objdistlog;
output.mymovie = mymovie;
output.LEFT = LEFT;
output.RIGHT = RIGHT;
output.objrange = objrange;
output.objdist = objdist;
output.handlelog = handlelog;
output.ipi_log = ipi_log;
output.rotation_log_az = rotation_log_az;
output.rotation_log_el = rotation_log_el;

output.reflectors_pos_last = reflectors_pos_last;

if log_gain_doppler==1;save('log.mat','gain_log','doppler_log');end




end