clc
close all
clear
number_of_exp = 10;
time_mean = NaN(number_of_exp,1);
time_std = NaN(number_of_exp,1);
collision_mean = NaN(number_of_exp,1);
collision_std = NaN(number_of_exp,1);
tortuosity_mean = NaN(number_of_exp,1);
tortuosity_std = NaN(number_of_exp,1);
successrate = NaN(number_of_exp,1);

a = load('call_interval/0.06.mat');
time_mean(1) = a.performance.time;
time_std(1) = std(a.iteration_valid * 0.06);
collision_mean(1) = a.performance.collision_mean;
collision_std(1) = std(a.collision_valid);
tortuosity_mean(1) = a.performance.tortuosity_mean;
tortuosity_std(1) = std(a.tortuosity_valid);
successrate(1) = a.performance.successfulrate*100;

a = load('call_interval/0.07.mat');
time_mean(2) = a.performance.time;
time_std(2) = std(a.iteration_valid * 0.07);
collision_mean(2) = a.performance.collision_mean;
collision_std(2) = std(a.collision_valid);
tortuosity_mean(2) = a.performance.tortuosity_mean;
tortuosity_std(2) = std(a.tortuosity_valid);
successrate(2) = a.performance.successfulrate*100;

a = load('call_interval/0.08.mat');
time_mean(3) = a.performance.time;
time_std(3) = std(a.iteration_valid * 0.08);
collision_mean(3) = a.performance.collision_mean;
collision_std(3) = std(a.collision_valid);
tortuosity_mean(3) = a.performance.tortuosity_mean;
tortuosity_std(3) = std(a.tortuosity_valid);
successrate(3) = a.performance.successfulrate*100;

a = load('call_interval/0.09.mat');
time_mean(4) = a.performance.time;
time_std(4) = std(a.iteration_valid * 0.09);
collision_mean(4) = a.performance.collision_mean;
collision_std(4) = std(a.collision_valid);
tortuosity_mean(4) = a.performance.tortuosity_mean;
tortuosity_std(4) = std(a.tortuosity_valid);
successrate(4) = a.performance.successfulrate*100;

a = load('call_interval/0.1.mat');
time_mean(5) = a.performance.time;
time_std(5) = std(a.iteration_valid * 0.1);
collision_mean(5) = a.performance.collision_mean;
collision_std(5) = std(a.collision_valid);
tortuosity_mean(5) = a.performance.tortuosity_mean;
tortuosity_std(5) = std(a.tortuosity_valid);
successrate(5) = a.performance.successfulrate*100;

a = load('call_interval/0.11.mat');
time_mean(6) = a.performance.time;
time_std(6) = std(a.iteration_times * 0.11);
collision_mean(6) = a.performance.collision_mean;
collision_std(6) = std(a.collision_valid);
tortuosity_mean(6) = a.performance.tortuosity_mean;
tortuosity_std(6) = std(a.tortuosity_valid);
successrate(6) = a.performance.successfulrate*100;

a = load('call_interval/0.12.mat');
time_mean(7) = a.performance.time;
time_std(7) = std(a.iteration_valid * 0.12);
collision_mean(7) = a.performance.collision_mean;
collision_std(7) = std(a.collision_valid);
tortuosity_mean(7) = a.performance.tortuosity_mean;
tortuosity_std(7) = std(a.tortuosity_valid);
successrate(7) = a.performance.successfulrate*100;

a = load('call_interval/0.13.mat');
time_mean(8) = a.performance.time;
time_std(8) = std(a.iteration_valid * 0.13);
collision_mean(8) = a.performance.collision_mean;
collision_std(8) = std(a.collision_valid);
tortuosity_mean(8) = a.performance.tortuosity_mean;
tortuosity_std(8) = std(a.tortuosity_valid);
successrate(8) = a.performance.successfulrate*100;

a = load('call_interval/0.14.mat');
time_mean(9) = a.performance.time;
time_std(9) = std(a.iteration_valid * 0.14);
collision_mean(9) = a.performance.collision_mean;
collision_std(9) = std(a.collision_valid);
tortuosity_mean(9) = a.performance.tortuosity_mean;
tortuosity_std(9) = std(a.tortuosity_valid);
successrate(9) = a.performance.successfulrate*100;

a = load('call_interval/0.15.mat');
time_mean(10) = a.performance.time;
time_std(10) = std(a.iteration_valid * 0.15);
collision_mean(10) = a.performance.collision_mean;
collision_std(10) = std(a.collision_valid);
tortuosity_mean(10) = a.performance.tortuosity_mean;
tortuosity_std(10) = std(a.tortuosity_valid);
successrate(10) = a.performance.successfulrate*100;
%%
figure (1)
set(1,'position',[500 300 800 540])

subplot(2,2,1)
x = 60:10:150;
e = errorbar(x,time_mean,time_std,'-o');
e.CapSize = 8;
e.MarkerEdgeColor = 'r';
e.MarkerFaceColor = 'r';
e.MarkerSize = 3;
e.LineWidth = 0.5;
e.Color = [0.4 .4 .4];
xlim([55 155]);
ylim([0 120]);
xlabel('Call Interval [ms]');
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
xlim([55 155]);
ylim([0 220]);
xlabel('Call Interval [ms]');
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
xlim([55 155]);
ylim([0 70]);
xlabel('Call Interval [ms]');
ylabel('Tortuosity [m]');
title('Tortuosity (c)');

subplot(2,2,4)
e = plot(x,successrate,'-o');
e.MarkerEdgeColor = 'r';
e.MarkerFaceColor = 'r';
e.MarkerSize = 3;
e.LineWidth = 0.5;
e.Color = [0.4 .4 .4];
xlim([55 155]);
ylim([0 150]);
xlabel('Call Interval [ms]');
ylabel('Successful Rate [%]');
title('Successful Rate (d)');

%%
% figure (2)
% set(2,'position',[500 300 1000 1000])
% a = load('call_interval/0.06.mat'); % call interval = 0.06 ms
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
% plot3(a.batpositions(:,1,2), a.batpositions(:,2,2), a.batpositions(:,3,2), 'r-','LineWidth',2.5)
% hold on
% a = load('call_interval/0.11.mat'); % call_interval = 0.11 ms   purple
% plot3(a.batpositions(:,1,1), a.batpositions(:,2,1), a.batpositions(:,3,1), '-','LineWidth',2.5,'Color',[0.717, 0.298, 0.980])
% hold on
% a = load('call_interval/0.15.mat'); % call_interval = 0.15 ms  orange
% plot3(a.batpositions(:,1,10), a.batpositions(:,2,10), a.batpositions(:,3,10), '-','LineWidth',2.5,'Color',[0.992, 0.627, 0.168])
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

