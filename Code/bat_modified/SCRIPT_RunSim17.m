clc
clear
close all
restoredefaultpath;matlabrc
addpath(genpath('lib'));
addpath(genpath('exchange_lib'));
% AddBATLAB;ccc;


%RunExperiments = [11 12];
%RunExperiments = [99];
%RunExperiments = [1 2 3 4 7 8];
RunExperiments = 1;

for ExperimentNr = RunExperiments
    %fixed settings
    settings.log_gain_doppler = 0;
    settings.delay_window = 0.001;
    settings.linear_velocity = 6;
    settings.fovea = 90;
    settings.doplot=0;
    settings.attenuation_range = [-30 -6];
    settings.max_slope = 60;
    settings.nr_replications = NaN;
    settings.emission_freq = 40000;
    settings.system = 'CF';
    Magnitude = NaN;
    
    %Experiment Settings
    switch ExperimentNr
        case 0
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.maxdist =20;
            settings.iteration_steps = 250;
            settings.worldshape = 'B';
            ClusterSize = 500;
            ClustVar = 1.5;
            Nrclusters = 500;
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0];
            EF = [0 0 0 0 0];
            OA = [0 1 0 0 0];
            RF = [1 1 1 1 1];
            CS = [0 0 0 0 1];
            ResultFile = 'Experiment0';
        case 1
            if isnan(settings.nr_replications);settings.nr_replications=1;end
            settings.maxdist =20;
            settings.iteration_steps = 300;
            settings.worldshape = 'H';
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
            RF = 1 ;
            CS = 0 ;
            ResultFile = 'Experiment1';
        case 2
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.maxdist =20;
            settings.iteration_steps = 250;
            settings.worldshape = 'V';
            ClusterSize = 250;
            ClustVar = 0.5;
            Nrclusters = 100;
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0];
            EF = [0 1 0 0 0];
            OA = [0 0 0 0 0];
            RF = [1 1 1 1 1];
            CS = [0 0 0 0 1];
            ResultFile = 'Experiment2';
        case 3
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.maxdist =20;
            settings.iteration_steps = 250;
            settings.worldshape = 'B';
            ClusterSize = 500;
            ClustVar = 1.5;
            Nrclusters = 500;
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0];
            EF = [0 1 0 0 0];
            OA = [0 0 0 0 0];
            RF = [1 1 1 1 1];
            CS = [0 0 0 0 1];
            ResultFile = 'Experiment3';
        case 4
            if isnan(settings.nr_replications);settings.nr_replications=25;end
            settings.maxdist = 200;
            settings.iteration_steps = 250;
            settings.worldshape = 'T';
            settings.attenuation_range = [-46 -34];
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0];
            EF = [0 1 0 0 0];
            OA = [0 0 0 0 0];
            RF = [1 1 1 1 1];
            CS = [0 0 0 0 1];
            ResultFile = 'Experiment4';
        case 7
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.maxdist = 2000;
            settings.iteration_steps = 250;
            settings.worldshape = 'R1';
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0];
            EF = [0 1 0 0 0];
            OA = [0 0 0 0 0];
            RF = [1 1 1 1 1];
            CS = [0 0 0 0 1];
            ResultFile = 'Experiment7';
        case 8
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.maxdist = 2000;
            settings.iteration_steps = 250;
            settings.worldshape = 'R2';
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0];
            EF = [0 1 0 0 0];
            RF = [1 1 1 1 1];
            CS = [0 0 0 0 1];
            ResultFile = 'Experiment8';
        case 9
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.attenuation_range = [-66 -63];
            settings.maxdist = 5;
            settings.iteration_steps = 250;
            settings.worldshape = 'MH';
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0 0];
            EF = [0 1 0 0 0 0];
            OA = [0 0 0 0 0 1];
            RF = [0 0 0 0 0 0];
            CS = [0 0 0 0 1 0];
            ResultFile = 'Experiment9';
        case 10
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.attenuation_range = [-66 -63];
            settings.maxdist = 5;
            settings.iteration_steps = 250;
            settings.worldshape = 'MV';
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 0 1 2 0 0];
            EF = [0 1 0 0 0 0];
            OA = [0 0 0 0 0 1];
            RF = [0 0 0 0 0 0];
            CS = [0 0 0 0 1 0];
            ResultFile = 'Experiment10';
        case 11
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.maxdist =20;
            settings.iteration_steps = 250;
            settings.worldshape = 'H';
            settings.system = 'FM';
            settings.emission_freq = 60000;
            ClusterSize = 250;
            ClustVar = 0.5;
            Nrclusters = 100;
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 1 2 0 0];
            EF = [1 1 1 0 0];
            OA = [0 0 0 1 1];
            RF = [1 1 1 1 1];
            CS = [0 0 0 1 0];
            ResultFile = 'Experiment11';
        case 12
            if isnan(settings.nr_replications);settings.nr_replications=100;end
            settings.maxdist =20;
            settings.iteration_steps = 250;
            settings.worldshape = 'V';
            settings.system = 'FM';
            settings.emission_freq = 60000;
            ClusterSize = 250;
            ClustVar = 0.5;
            Nrclusters = 100;
            MG = [Magnitude Magnitude Magnitude Magnitude Magnitude];
            RD = [0 1 2 0 0];
            EF = [1 1 1 0 0];
            OA = [0 0 0 1 1];
            RF = [1 1 1 1 1];
            CS = [0 0 0 1 0];
            ResultFile = 'Experiment12';
        case 99
            settings.log_gain_doppler=1;
            settings.nr_replications=1;
            settings.maxdist =20;
            settings.iteration_steps = 250;
            settings.worldshape = 'B';
            ClusterSize = 500;
            ClustVar = 1.5;
            Nrclusters = 500;
            MG = [Magnitude];
            RD = [0];
            EF = [0];
            OA = [0];
            RF = [1];
            CS = [0];
            ResultFile = 'Experiment99';
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
        %% vertical wires 2d
%         [x,y,z] = ndgrid(-10:0.15:10, 0, -10:0.15:10);
%         R = [x(:),y(:),z(:)];
        
        %% corridor 2d
        %          [x,y,z] = ndgrid(-0.5:1:0.5, 0, -10:0.01:10);
        %          R = [x(:),y(:),z(:)];
        %          target = [0,0,-5];
        
        %% Circular corridor 2d
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
        %% 3D torus
        Rring = 4;                              % radius of ring 
        x0 = 4; y0 = 0; z0 = 0;                 % center of ring
        Rtorus = 2;                             % radius of torus
        R = torus(Rring,Rtorus,x0,y0,z0);       
        
        %% Target
        a = 8;
        b = 0;
        c = 0;
        target = [a,b,c];
        
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
    hold on
%     plot3(R(:,1),R(:,2),R(:,3),'.b')
%     axis equal
    %     axis auto
%     xlim([-100 100])
%     ylim([-100 100])
%     zlim([-10 10])
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    text(a,b,c,'Target')
    text(0,0,0,'Start')
    grid on
end