clc
clear
close all

RunExperiments = 6;
plot_R = 0;

for ExperimentNr = RunExperiments
    
    settings.emission_freq = 40000;
    settings.nr_replications = 1;
    settings.targetsearch = 1;
    settings.iteration_steps = 1000;
    
    %% bat variables
    settings.innerzone = 0.2;
    settings.outerzone = 0.5;
    zone_thickness = settings.outerzone - settings.innerzone;
    settings.delay_window = 0.001;
    settings.call_freq = 0.1;
    settings.linear_vel_max = 6;
    settings.linear_vel_min = 0.3;
    settings.angular_vel_max = 666;
    settings.angular_vel_min = 10;
    
    %% environment factors
    settings.rand_phase      = 0;
    settings.reflector_str   = 0;
    settings.attenuation_range = [-10 -6];
    
    %% environment set up
    switch ExperimentNr
        
        % 3D tunnel / ring
        case 6
            settings.worldshape = '3D'; 
            ResultFile = '3Dtunnel';
            
            settings.Rring = 5;                                 % radius of ring
            settings.x0 = 5; settings.y0 = 0; settings.z0 = 0;  % center of ring
            settings.Rtorus = 2;                                % radius of torus
            settings.R = torus(settings.Rring,settings.Rtorus,settings.x0,settings.y0,settings.z0);
            %             [x,y,z] = ndgrid(4.5:0.1:5.5, -0.5:0.1:0.5, 3:0.1:3.5);
            %             R2 = [x(:),y(:),z(:)];
            %             R = [R1;R2];
%             settings.R = R1;
            
            settings.target = [10,0,0.5];
            linear_distance = norm(settings.target);
            
        % 3D wires
        case 4
            settings.worldshape = '3D';
            ResultFile = '3Dwires';
            
            [x,y,z] = ndgrid(-0.3:1:20, -8:0.1:8, -0.8:1:20);
            settings.R = [x(:),y(:),z(:)];
            
            settings.target = [16,0,18];
            linear_distance = norm(settings.target);
            
            % 3d clusters
        case 5
            settings.worldshape = '3D';
            ResultFile = '3Dclusters';
            
            settings.cluster_nr = 50;
            settings.centers_min = 0;
            settings.centers_max = 20;
            xcenter = randrange(settings.centers_min,settings.centers_max,settings.cluster_nr);
            ycenter = randrange(-5,5,settings.cluster_nr);
            zcenter = randrange(settings.centers_min,settings.centers_max,settings.cluster_nr);
            
            settings.cluster_range = 1;
            settings.ref_nr_per_cluster = 1000;
            x = [];
            y = [];
            z = [];
            
            for i = 1:1:settings.cluster_nr
                xf = randn(settings.ref_nr_per_cluster, settings.cluster_range) + xcenter(i);
                yf = randn(settings.ref_nr_per_cluster, settings.cluster_range) + ycenter(i);
                zf = randn(settings.ref_nr_per_cluster, settings.cluster_range) + zcenter(i);
                x = [x;xf];
                y = [y;yf];
                z = [z;zf];
            end
            
            settings.R = [x(:), y(:), z(:)];
            settings.target = [15,0,15];
            linear_distance = norm(settings.target);
            
          
    end
    
    distances           = NaN(settings.iteration_steps, 1,  settings.nr_replications);
    velocities          = NaN(settings.iteration_steps, 1,  settings.nr_replications);
%     densities           = NaN(settings.iteration_steps, 1,  settings.nr_replications);
    batpositions        = NaN(settings.iteration_steps, 3,  settings.nr_replications);
    reflectors_nr       = NaN(settings.iteration_steps, 4,  settings.nr_replications);
%     steermats           = NaN(settings.iteration_steps, 4,  settings.nr_replications);
    iteration_times     = NaN(settings.nr_replications,1);
    collision_times     = NaN(settings.nr_replications,1);
    tortuosity          = NaN(settings.nr_replications,1);
    
    
    %% run simulation
    for replication = 1:settings.nr_replications
        
        currentsettings = settings;
        output = batflight25(currentsettings);
        
        distances(:,:,replication)      = output.objdistlog;
        velocities(:,:,replication)     = output.velocities;
%         handles(:,:,replication)        = output.handlelog;
        batpositions(:,:,replication)   = output.batposlog;
%         steermats(:,:,replication)      = output.steermatlog;
        reflectors_nr(:,:,replication)  = output.reflectors_nr;
        iteration_times(:,1)            = output.iteration_times;
        collision_times(:,1)            = output.collision;
        tortuosity(:,1)                 = output.tortuosity;
    end
    
    %% save data
    save(ResultFile);
    
    
    %% plot bat_position and reflectors
    figure (1)
    set(1,'position',[500 300 900 700])
    plot3(batpositions(:,1), batpositions(:,2), batpositions(:,3), '.r')
    hold on
    if plot_R == 1
        plot3(settings.R(:,1),settings.R(:,2),settings.R(:,3),'.b')
    end
    %     plot3(R2(:,1),R2(:,2),R2(:,3),'.b')
    axis equal
    %     axis auto
    %     xlim([-100 100])
    %     ylim([-100 100])
    %     zlim([-10 10])
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    if settings.targetsearch == 1
        text(settings.target(1),settings.target(2),settings.target(3),'Target')
    end
    text(0,0,0,'Start')
    grid on
end