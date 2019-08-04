clc
clear
close all
restoredefaultpath;matlabrc
addpath(genpath('lib'));
addpath(genpath('exchange_lib'));
% AddBATLAB;ccc;

RunExperiments = 1;

for ExperimentNr = RunExperiments
    %fixed settings
    settings.log_gain_doppler = 0;
    settings.delay_window = 0.001;
    settings.linear_velocity = 6;
    settings.fovea = 90;
    settings.doplot=0;
    settings.attenuation_range = [-30 -6];
    settings.max_slope = 30/180*pi;
    settings.nr_replications = NaN;
    settings.emission_freq = 40000;
    settings.system = 'CF';
    Magnitude = NaN;
    
    %Experiment Settings
    switch ExperimentNr
        
        case 1
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.maxdist =20;
            settings.iteration_steps = 300;
            settings.worldshape = '3D';
            ClusterSize = 250;
            ClustVar = 0.5;
            Nrclusters = 100;
            %             MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            %             RD = [0 0 1 2 0];
            %             EF = [0 1 0 0 0];
            %             OA = [0 0 0 0 0];
            %             RF = [1 1 1 1 1];
            %             CS = [0 0 0 0 1];
            
            MG = Magnitude;
            RD = 0 ;
            EF = 0 ;
            OA = 0 ;
            RF = 0 ;
            CS = 0 ;
            ResultFile = 'Experiment1';
            
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nr_conditions=length(MG);
    distances =    NaN(settings.iteration_steps, 1, nr_conditions, settings.nr_replications);
    velocities =   NaN(settings.iteration_steps, 1, nr_conditions, settings.nr_replications);
    handles =      NaN(settings.iteration_steps, 1, nr_conditions, settings.nr_replications);
    densities =    NaN(settings.iteration_steps, 1, nr_conditions, settings.nr_replications);
    batpositions = NaN(settings.iteration_steps, 3, nr_conditions, settings.nr_replications);
    reflectors_nr =NaN(settings.iteration_steps, 4, nr_conditions, settings.nr_replications);
    steermats =    NaN(settings.iteration_steps, 4, nr_conditions, settings.nr_replications);
    
    for replication = 1:settings.nr_replications
        %% 2d vertical wires
        %         [x,y,z] = ndgrid(-10:0.15:10, 0, -10:0.15:10);
        %         R = [x(:),y(:),z(:)];
        
        %% 2d corridor
        %          [x,y,z] = ndgrid(-0.5:1:0.5, 0, -10:0.01:10);
        %          R = [x(:),y(:),z(:)];
        %          a = 0;
        %          b = 0;
        %          c = -5;
        %          target = [a, b, c];
%         settings.worldshape = 'H';
        
        %% 2d Circular corridor
        %         r1 = 4;
        %         r2 = 5.4;
        %         range = (0:0.001:2*pi)';
        %         x1 = 5 + r1 * cos(range);
        %         z1 = r1 * sin(range);
        %         y1 = zeros(length(range),1);
        %         x2 = 5 + r2 * cos(range);
        %         z2 = r2 * sin(range);
        %         y2 = zeros(length(range),1);
        %
        %         R1 = [x1(:), y1(:), z1(:)];
        %         R2 = [x2(:), y2(:), z2(:)];
        %         R = [R1;R2];
        %
        %         R1 = [y1(:), x1(:), z1(:)];
        %         R2 = [y2(:), x2(:), z2(:)];
        %         R = [R1;R2];
        %         settings.worldshape = 'H';
        
        %% 3d wires
                [x,y,z] = ndgrid(-6:1:6, -8:0.1:8, -1.2:1:14);
                R = [x(:),y(:),z(:)];
        
                a = 2; % X
                b = 0;  % Y height
                c = 10; % Z
                target = [a,b,c];
        
        %% 3d clusters
        %         cluster_nr = 200;
        %         min = -10;
        %         max = 50;
        %         xcenter = randrange(min,max,cluster_nr);
        %         ycenter = randrange(-10,10,cluster_nr);
        %         zcenter = randrange(min,max,cluster_nr);
        %
        %         cluster_range = 1;
        %         ref_nr_per_cluster = 300;
        %         x = [];
        %         y = [];
        %         z = [];
        %
        %         for i = 1:1:cluster_nr
        %             xf = randn(ref_nr_per_cluster, cluster_range) + xcenter(i);
        %             yf = randn(ref_nr_per_cluster, cluster_range) + ycenter(i);
        %             zf = randn(ref_nr_per_cluster, cluster_range) + zcenter(i);
        %             x = [x;xf];
        %             y = [y;yf];
        %             z = [z;zf];
        %         end
        %
        %         R = [x(:), y(:), z(:)];
        
        %         a = 30; % X
        %         b = 5;  % Y height
        %         c = 30; % Z
        %         target = [a,b,c];
        
        
        %% 3D torus / circular corridor
%         Rring = 5;                              % radius of ring
%         x0 = 5; y0 = 0; z0 = 0;                 % center of ring
%         Rtorus = 2;                             % radius of torus
%         R = torus(Rring,Rtorus,x0,y0,z0);
%         
%         a = 10; % X
%         b = 0;  % Y height
%         c = 3; % Z
%         target = [a,b,c];
        
        %%
        %         if strcmp(settings.worldshape,'T');  R = MyTorus(10,2,45);end
        %         if strcmp(settings.worldshape,'MH'); R = MakeMogdansWorld(settings.maxdist,'H',0.15);end
        %         if strcmp(settings.worldshape,'MV'); R = MakeMogdansWorld(settings.maxdist,'V',0.15);end
        %         if strcmp(settings.worldshape,'R1'); R = MakeRealWorld(1);end
        %         if strcmp(settings.worldshape,'R2')®; R = MakeRealWorld(2);end
        %         if isempty(R); R = MakeWorld6(settings.maxdist,settings.worldshape,Nrclusters,ClusterSize,ClustVar);end
        %         worlds{replication}=R;
        %         parfor condition = 1:nr_conditions
        %for condition = 1:nr_conditions
        
        condition = 1;
        currentsettings = settings;
        currentsettings.reflectors = R;
        currentsettings.max_magnitude = MG(condition);
        currentsettings.gorandom = RD(condition);
        currentsettings.earsfixed = EF(condition);
        currentsettings.earsfixed_off_axis = OA(condition);
        currentsettings.rand_phase = RF(condition);
        currentsettings.constrained = CS(condition);
        currentsettings.target = target;
        
        output = batflight25(currentsettings);
        
        distances(:,:,condition,replication)   =output.objdistlog;
        velocities(:,:,condition,replication)  =output.velocities;
        handles(:,:,condition,replication)     =output.handlelog;
        batpositions(:,:,condition,replication)=output.batposlog;
        steermats(:,:,condition,replication)   =output.steermatlog;
        reflectors_nr(:,:,condition,replication)  =output.reflectors_nr;
        
        reflectors_pos_last = output.reflectors_pos_last;
        %         end
    end
    
    save(['experiments\\' ResultFile]);
    %subject = ['Experiment ' num2str(ExperimentNr) ' finished'];
    %SendMailToUA(subject,'Simulation finished!')
    
    
    % plot bat_position and reflectors
    figure (1)
    set(1,'position',[500 300 900 700])
    plot3(batpositions(:,1), batpositions(:,2), batpositions(:,3), '.r')
%     plot3(batpositions(:,1), batpositions(:,3), batpositions(:,2), '.r')
    hold on
    plot3(R(:,1),R(:,2),R(:,3),'.b')
%     plot3(R(:,1),R(:,3),R(:,2),'.b')
    axis equal
    %     axis auto
    %     xlim([-100 100])
    %     ylim([-100 100])
    %     zlim([-10 10])
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
%     ylabel('Z')
%     zlabel('Y')
    text(a,b,c,'Target')
%     text(a,c,b,'Target')
    text(0,0,0,'Start')
    grid on
end