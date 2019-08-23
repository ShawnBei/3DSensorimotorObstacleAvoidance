clc
clear
close all

RunExperiments = 4;
plot_R = 1;

for ExperimentNr = RunExperiments
    
    settings.nr_replications = 1;
    settings.emission_freq = 40000;
    settings.targetsearch = 1;
    settings.iteration_steps = 1000;
    settings.worldshape = '3D';
    
    %% bat variables
    settings.innerzone = 0.3;
    settings.outerzone = 0.5;
    zone_thickness = settings.outerzone - settings.innerzone;
    settings.delay_window = 0.001;
    settings.call_freq = 0.1;
    settings.linear_vel_max = 6;
    settings.linear_vel_min = 0.3;
    settings.angular_vel_max = 666;
    settings.angular_vel_min = 10;
    
    %% environment factors
    settings.rand_phase      = 1;
    settings.reflector_str   = 1;
    settings.attenuation_range = [-8 -6];
    
    %% environment set up
    switch ExperimentNr
        
        % 3D tunnel / ring
        case 6
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
            ResultFile = '3Dwires';
            
            [x,y,z] = ndgrid(-0.3:1:18, -8:0.1:8, -0.8:1:18);
            settings.R = [x(:),y(:),z(:)];
            
            settings.target = [14,0,15];
            linear_distance = norm(settings.target);
            
            % 3d clusters
        case 5
            ResultFile = '3Dclusters';
            
            settings.cluster_nr = 80;
            settings.centers_min = 1;
            settings.centers_max = 19;
            xcenter = randrange(settings.centers_min,settings.centers_max,settings.cluster_nr);
            ycenter = randrange(-5,5,settings.cluster_nr);
            zcenter = randrange(settings.centers_min,settings.centers_max,settings.cluster_nr);
            
            settings.cluster_range = 1;
            settings.ref_nr_per_cluster = 800;
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
            
        case 7
            ResultFile = '3Dclusters';
            temp = load('clustersGood.mat','settings');
            settings.R = temp.settings.R;
            settings.target = [15,0,15];
            linear_distance = norm(settings.target);
    end
    
    distances           = NaN(settings.iteration_steps,  settings.nr_replications);
    velocities          = NaN(settings.iteration_steps,  settings.nr_replications);
    batpositions        = NaN(settings.iteration_steps, 3,  settings.nr_replications);
    reflectors_nr       = NaN(settings.iteration_steps, 4,  settings.nr_replications);
    iteration_times     = NaN(settings.nr_replications,1);
    collision_times     = NaN(settings.nr_replications,1);
    tortuosity          = NaN(settings.nr_replications,1);
    
    
    %% run simulation
    for replication = 1:settings.nr_replications
        
        currentsettings = settings;
        output = batflight25(currentsettings);
        
        distances(:,replication)      = output.objdistlog;
        velocities(:,replication)     = output.velocities;
        batpositions(:,:,replication)   = output.batposlog;
        reflectors_nr(:,:,replication)  = output.reflectors_nr;
        iteration_times(replication,1)  = output.iteration_times;
        collision_times(replication,1)  = output.collision;
        tortuosity(replication,1)       = output.tortuosity;
    end
    
    performance.iteration_mean = mean(iteration_times);
    performance.collision_mean = mean(collision_times);
    performance.tortuosity_mean = mean(tortuosity);
    
    %% save data
    save(ResultFile);
    
    
    %% plot bat_position and reflectors
    figure (1)
    set(1,'position',[500 300 900 700])
    
%     y yellow
%     m pink
%     c light blue
%     r red
%     g green
%     b blue
%     w white
%     k black
    colorstring = 'rgb';
    
    for j = 1:settings.nr_replications
        plot3(batpositions(:,1,j), batpositions(:,2,j), batpositions(:,3,j), 'Color',colorstring(j),'LineWidth',2)
        hold on
    end
    
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