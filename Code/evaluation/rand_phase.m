clc
close all
clear
% load('rand_phase3.mat')
% load('reflector_atten5.mat')
load('3Dclusters.mat')

% 
% a.time_std = std(iteration_valid * 0.1);
% a.collision_std = std(collision_valid);
% a.tortuosity_std = std(tortuosity_valid);


% left = histogram(output.reflectors_nr(:,1),'Normalization','probability');
% right =  histogram(output.reflectors_nr(:,2),'Normalization','probability');
% top =  histogram(output.reflectors_nr(:,3),'Normalization','probability');
% bottom = histogram(output.reflectors_nr(:,4),'Normalization','probability');

left = histcounts(output.reflectors_nr(:,1))' /output.iteration_times;
right = histcounts(output.reflectors_nr(:,2))' /output.iteration_times;
top = histcounts(output.reflectors_nr(:,3))' /output.iteration_times;
bottom = histcounts(output.reflectors_nr(:,4))' /output.iteration_times;




x = 1:length(left);
left_mean = x*left;
plot(x,left,'LineWidth',2,'Color',[0.976, 0.278, 0.082]);
hold on
x = 1:length(right);
right_mean = x*right;
plot(x,right,'LineWidth',2,'Color',[0.082, 0.701, 0.976]);
hold on
x = 1:length(top);
top_mean = x*top;
plot(x,top,'LineWidth',2,'Color',[0.717, 0.298, 0.980]);
hold on
x = 1:length(bottom);
bottom_mean = x*bottom;
plot(x,bottom,'LineWidth',2,'Color',[0.984, 0.717, 0.094]);

xlabel('Nr of Valid Echoes');
ylabel('Proportion');
legend('Left Ear (4.0)','Right Ear (4.2)', 'Top Ear (4.3)','Bottom Ear (4.1)');