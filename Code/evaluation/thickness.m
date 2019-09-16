clc
close all
clear
time_mean = NaN(9,1);
time_std = NaN(9,1);
collision_mean = NaN(9,1);
collision_std = NaN(9,1);
tortuosity_mean = NaN(9,1);
tortuosity_std = NaN(9,1);
successrate = NaN(9,1);
freq = 0.1;

a = load('thickness/0.2.mat');
time_mean(1) = a.performance.time;
time_std(1) = std(a.iteration_valid * freq);
collision_mean(1) = a.performance.collision_mean;
collision_std(1) = std(a.collision_valid);
tortuosity_mean(1) = a.performance.tortuosity_mean;
tortuosity_std(1) = std(a.tortuosity_valid);
successrate(1) = a.performance.successfulrate*100;

a = load('thickness/0.22.mat');
time_mean(2) = a.performance.time;
time_std(2) = std(a.iteration_valid * freq);
collision_mean(2) = a.performance.collision_mean;
collision_std(2) = std(a.collision_valid);
tortuosity_mean(2) = a.performance.tortuosity_mean;
tortuosity_std(2) = std(a.tortuosity_valid);
successrate(2) = a.performance.successfulrate*100;

a = load('thickness/0.24.mat');
time_mean(3) = a.performance.time;
time_std(3) = std(a.iteration_valid * freq);
collision_mean(3) = a.performance.collision_mean;
collision_std(3) = std(a.collision_valid);
tortuosity_mean(3) = a.performance.tortuosity_mean;
tortuosity_std(3) = std(a.tortuosity_valid);
successrate(3) = a.performance.successfulrate*100;

a = load('thickness/0.26.mat');
time_mean(4) = a.performance.time;
time_std(4) = std(a.iteration_valid * freq);
collision_mean(4) = a.performance.collision_mean;
collision_std(4) = std(a.collision_valid);
tortuosity_mean(4) = a.performance.tortuosity_mean;
tortuosity_std(4) = std(a.tortuosity_valid);
successrate(4) = a.performance.successfulrate*100;

a = load('thickness/0.28.mat');
time_mean(5) = a.performance.time;
time_std(5) = std(a.iteration_valid * freq);
collision_mean(5) = a.performance.collision_mean;
collision_std(5) = std(a.collision_valid);
tortuosity_mean(5) = a.performance.tortuosity_mean;
tortuosity_std(5) = std(a.tortuosity_valid);
successrate(5) = a.performance.successfulrate*100;

a = load('thickness/0.3.mat');
time_mean(6) = a.performance.time;
time_std(6) = std(a.iteration_times * freq);
collision_mean(6) = a.performance.collision_mean;
collision_std(6) = std(a.collision_times);
tortuosity_mean(6) = a.performance.tortuosity_mean;
tortuosity_std(6) = std(a.tortuosity);
successrate(6) = a.performance.successfulrate*100;

a = load('thickness/0.32.mat');
time_mean(7) = a.performance.time;
time_std(7) = std(a.iteration_valid * freq);
collision_mean(7) = a.performance.collision_mean;
collision_std(7) = std(a.collision_valid);
tortuosity_mean(7) = a.performance.tortuosity_mean;
tortuosity_std(7) = std(a.tortuosity_valid);
successrate(7) = a.performance.successfulrate*100;

a = load('thickness/0.34.mat');
time_mean(8) = a.performance.time;
time_std(8) = std(a.iteration_valid * freq);
collision_mean(8) = a.performance.collision_mean;
collision_std(8) = std(a.collision_valid);
tortuosity_mean(8) = a.performance.tortuosity_mean;
tortuosity_std(8) = std(a.tortuosity_valid);
successrate(8) = a.performance.successfulrate*100;

a = load('thickness/0.36.mat');
time_mean(9) = a.performance.time;
time_std(9) = std(a.iteration_valid * freq);
collision_mean(9) = a.performance.collision_mean;
collision_std(9) = std(a.collision_valid);
tortuosity_mean(9) = a.performance.tortuosity_mean;
tortuosity_std(9) = std(a.tortuosity_valid);
successrate(9) = a.performance.successfulrate*100;
%%
figure (1)
set(1,'position',[500 300 800 540])
subplot(2,2,1)
x = 0:0.02:0.16;
e = errorbar(x,time_mean,time_std,'-o');
e.CapSize = 8;
e.MarkerEdgeColor = 'r';
e.MarkerFaceColor = 'r';
e.MarkerSize = 3;
e.LineWidth = 0.5;
e.Color = [0.4 .4 .4];
xlim([-0.01 0.17]);
ylim([0 120]);
xlabel('Mixed Zone Thickness [m]');
ylabel('Time [s]');
title('Time (a)');

subplot(2,2,2)
e = errorbar(x,collision_mean,collision_std,'-o');
e.CapSize = 8;
e.MarkerEdgeColor = 'r';
e.MarkerFaceColor = 'r';
e.MarkerSize = 3;
e.LineWidth = 0.5;
e.Color = [0.4 .4 .4];
xlim([-0.01 0.17]);
ylim([0 140])
xlabel('Mixed Zone Thickness [m]');
ylabel('Nr of Collisions');
title('Nr of Collisions (b)');

subplot(2,2,3)
e = errorbar(x,tortuosity_mean,tortuosity_std,'-o');
e.CapSize = 8;
e.MarkerEdgeColor = 'r';
e.MarkerFaceColor = 'r';
e.MarkerSize = 3;
e.LineWidth = 0.5;
e.Color = [0.4 .4 .4];
xlim([-0.01 0.17]);
ylim([0 70])
xlabel('Mixed Zone Thickness [m]');
ylabel('Tortuosity [m]');
title('Tortuosity (c)');

subplot(2,2,4)
e = plot(x,successrate,'-o');
e.MarkerEdgeColor = 'r';
e.MarkerFaceColor = 'r';
e.MarkerSize = 3;
e.LineWidth = 0.5;
e.Color = [0.4 .4 .4];
xlim([-0.01 0.17]);
ylim([0 150])
xlabel('Mixed Zone Thickness [m]');
ylabel('Successful Rate [%]');
title('Successful Rate (d)');

%%
% figure (2)
% set(2,'position',[500 300 1000 1000])
% a = load('thickness/0.2.mat'); % thickness = 0 m
% 
% cutoff = a.settings.R(:,2)>0;
% R_cut_1 = a.settings.R(:,1) .* cutoff;
% R_cut_2 = a.settings.R(:,2) .* cutoff;
% R_cut_3 = a.settings.R(:,3) .* cutoff;
% scatter1 = scatter3(R_cut_1,R_cut_2,R_cut_3,4,'MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7]); 
% scatter1.MarkerFaceAlpha = .3;
% scatter1.MarkerEdgeAlpha = .3;
% hold on
% 
% plot3(a.batpositions(:,1,1), a.batpositions(:,2,1), a.batpositions(:,3,1), 'r-','LineWidth',2.5)
% hold on
% a = load('thickness/0.36.mat'); % thickness = 0.16 m
% plot3(a.batpositions(:,1,9), a.batpositions(:,2,9), a.batpositions(:,3,9), '-','LineWidth',2.5,'Color',[0.717, 0.298, 0.980])
% hold on
% a = load('thickness/0.28.mat'); % thickness = 0.08 m
% plot3(a.batpositions(:,1,1), a.batpositions(:,2,1), a.batpositions(:,3,1), '-','LineWidth',2.5,'Color',[0.992, 0.627, 0.168])
% hold on
% 
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% % xlim([-5 25])
% text(0,-0.5,0,'Start')
% if a.settings.targetsearch == 1
%     text(a.settings.target(1)+0.5,a.settings.target(2),a.settings.target(3),'Target')
% end
% grid on
% view(-35,20)
% title("(a)")

