clc
clear
close all

RunExperiments = 6;

for ExperimentNr = RunExperiments
    
    settings.delay_window = 0.001;
    settings.linear_velocity = 6;
    settings.fovea = 90;
    settings.doplot=0;
    settings.attenuation_range = [-10 -6];
    settings.max_slope = 30/180*pi;
    settings.nr_replications = NaN;
    settings.emission_freq = 40000;
    settings.system = 'CF';
    Magnitude = NaN;
    
    targetsearch = true;
    RandomPhase = 1 ;
    
    
    switch ExperimentNr
        
        % 3D tunnel / ring
        case 6
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.iteration_steps = 1000;
            settings.worldshape = '3D';  % 'H' for 2D and '3D' for 3D
            ResultFile = 'Experiment6';
            
            Rring = 5;                              % radius of ring
            x0 = 5; y0 = 0; z0 = 0;                 % center of ring
            Rtorus = 2;                             % radius of torus
            R1 = torus(Rring,Rtorus,x0,y0,z0);
            
            %             [x,y,z] = ndgrid(4.5:0.1:5.5, -0.5:0.1:0.5, 3:0.1:3.5);
            %             R2 = [x(:),y(:),z(:)];
            %
            %             R = [R1;R2];
            
            R = R1;
            
            target = [10,1,-2];
            
            
            % 2d vertical wires
        case 1
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.iteration_steps = 300;
            settings.worldshape = 'H';
            ResultFile = 'Experiment1';
            
            [x,y,z] = ndgrid(-10:0.3:10, 0, -10:0.3:10);
            R = [x(:),y(:),z(:)];
            target = [5 0 5];
            
            
            % 2d corridor
        case 2
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.iteration_steps = 100;
            settings.worldshape = 'H';
            ResultFile = 'Experiment2';
            
            [x,y,z] = ndgrid(-0.5:1:0.5, 0, -10:0.01:10);
            R = [x(:),y(:),z(:)];
            target = [0, 0, -5];
            
            
            % 2d Circular corridor
        case 3
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.iteration_steps = 300;
            settings.worldshape = 'H';
            ResultFile = 'Experiment3';
            
            r1 = 4;
            r2 = 5.4;
            range = (0:0.001:2*pi)';
            x1 = 5 + r1 * cos(range);
            z1 = r1 * sin(range);
            y1 = zeros(length(range),1);
            x2 = 5 + r2 * cos(range);
            z2 = r2 * sin(range);
            y2 = zeros(length(range),1);
            
            R1 = [x1(:), y1(:), z1(:)];
            R2 = [x2(:), y2(:), z2(:)];
            R = [R1;R2];
            
            target = [9.5 0 0];
            
            
            % 3D wires
        case 4
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.iteration_steps = 300;
            settings.worldshape = '3D';
            ResultFile = 'Experiment4';
            
            [x,y,z] = ndgrid(-6.3:1:6, -8:0.1:8, -8.8:1:14);
            R = [x(:),y(:),z(:)];
            
            target = [2,-1,10];
            
            % 3d clusters
        case 5
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.iteration_steps = 200;
            settings.worldshape = '3D';
            ResultFile = 'Experiment5';
            
            cluster_nr = 200;
            min = -20;
            max = 20;
            xcenter = randrange(min,max,cluster_nr);
            ycenter = randrange(-20,20,cluster_nr);
            zcenter = randrange(min,max,cluster_nr);
            
            cluster_range = 1;
            ref_nr_per_cluster = 300;
            x = [];
            y = [];
            z = [];
            
            for i = 1:1:cluster_nr
                xf = randn(ref_nr_per_cluster, cluster_range) + xcenter(i);
                yf = randn(ref_nr_per_cluster, cluster_range) + ycenter(i);
                zf = randn(ref_nr_per_cluster, cluster_range) + zcenter(i);
                x = [x;xf];
                y = [y;yf];
                z = [z;zf];
            end
            
            R = [x(:), y(:), z(:)];
            
            target = [8,0,8];
            
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    distances           = NaN(settings.iteration_steps, 1,  settings.nr_replications);
    velocities          = NaN(settings.iteration_steps, 1,  settings.nr_replications);
    handles             = NaN(settings.iteration_steps, 1,  settings.nr_replications);
    densities           = NaN(settings.iteration_steps, 1,  settings.nr_replications);
    batpositions        = NaN(settings.iteration_steps, 3,  settings.nr_replications);
    reflectors_nr       = NaN(settings.iteration_steps, 4,  settings.nr_replications);
    steermats           = NaN(settings.iteration_steps, 4,  settings.nr_replications);
    iteration_times     = NaN(1,settings.nr_replications);
    
    for replication = 1:settings.nr_replications
        
        currentsettings = settings;
        currentsettings.reflectors = R;
        currentsettings.rand_phase = RandomPhase;
        currentsettings.target = target;
        currentsettings.targetsearch = targetsearch;
        
        output = batflight25(currentsettings);
        
        distances(:,:,replication)      = output.objdistlog;
        velocities(:,:,replication)     = output.velocities;
        handles(:,:,replication)        = output.handlelog;
        batpositions(:,:,replication)   = output.batposlog;
        steermats(:,:,replication)      = output.steermatlog;
        reflectors_nr(:,:,replication)  = output.reflectors_nr;
        iteration_times(:,replication)  = output.iteration_times;
    end
    
    save(['experiments\\' ResultFile]);
    %subject = ['Experiment ' num2str(ExperimentNr) ' finished'];
    %SendMailToUA(subject,'Simulation finished!')
    
    
    % plot bat_position and reflectors
    figure (1)
    set(1,'position',[500 300 900 700])
    plot3(batpositions(:,1), batpositions(:,2), batpositions(:,3), '.r')
    hold on
    %     plot3(R(:,1),R(:,2),R(:,3),'.b')
    %     plot3(R2(:,1),R2(:,2),R2(:,3),'.b')
    axis equal
    %     axis auto
    %     xlim([-100 100])
    %     ylim([-100 100])
    %     zlim([-10 10])
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    if targetsearch == true
        text(target(1),target(2),target(3),'Target')
    end
    text(0,0,0,'Start')
    grid on
end