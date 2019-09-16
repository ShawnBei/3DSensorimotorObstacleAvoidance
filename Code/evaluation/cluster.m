clc
close all
clear



figure (1)
set(1,'position',[500 300 800 300])
% 
% 
% subplot(2,2,[1,3])
% plot3(batpositions(:,1,4), batpositions(:,2,4), batpositions(:,3,4), 'r-','LineWidth',2)
% hold on
% 
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% 
% if settings.targetsearch == 1
%     text(settings.target(1),settings.target(2),settings.target(3),'Target')
% end
% 
% 
% 
% % plot3(R_cut_1,R_cut_2,R_cut_3,'.','color',[0.8 0.8 0.8])
% 
% % scatter1 = scatter3(R_cut_1,R_cut_2,R_cut_3,2,'MarkerFaceColor',[.8 .8 .8],'MarkerEdgeColor',[.8 .8 .8]); 
% % % Set property MarkerFaceAlpha and MarkerEdgeAlpha to <1.0
% % scatter1.MarkerFaceAlpha = .3;
% % scatter1.MarkerEdgeAlpha = .3;
% 
% scatter1 = scatter3(settings.R(:,1),settings.R(:,2),settings.R(:,3),4,'MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7]); 
% % Set property MarkerFaceAlpha and MarkerEdgeAlpha to <1.0
% scatter1.MarkerFaceAlpha = .3;
% scatter1.MarkerEdgeAlpha = .3;
%  
% text(0,0,0,'Start')
% grid on
% view(-40,30)
% title("(a)")
% 
% %%
% subplot(2,2,2)
% 
% cutoff = settings.R(:,2)>0;
% 
% R_cut_1 = settings.R(:,1) .* cutoff;
% R_cut_2 = settings.R(:,2) .* cutoff;
% R_cut_3 = settings.R(:,3) .* cutoff;
% 
% plot3(batpositions(:,1,4), batpositions(:,2,4), batpositions(:,3,4), 'r-','LineWidth',2)
% hold on
% 
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% 
% 
% xlim([-5 25])
% 
% if settings.targetsearch == 1
%     text(settings.target(1),settings.target(2),settings.target(3),'Target')
% end
% 
% scatter1 = scatter3(R_cut_1,R_cut_2,R_cut_3,4,'MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7]); 
% % Set property MarkerFaceAlpha and MarkerEdgeAlpha to <1.0
% scatter1.MarkerFaceAlpha = .3;
% scatter1.MarkerEdgeAlpha = .3;
% 
% %  plot3(R_cut_1,R_cut_2,R_cut_3,'.','color',[0.8 0.8 0.8])
%  
% text(0,0,0,'Start')
% grid on
% view(0,0)
% title("(b)")
% 
% %%
% subplot(2,2,4)
% 
% cutoff = (settings.R(:,3)<0.9*settings.R(:,1));
% 
% R_cut_1 = settings.R(:,1) .* cutoff;
% R_cut_2 = settings.R(:,2) .* cutoff;
% R_cut_3 = settings.R(:,3) .* cutoff;
% 
% plot3(batpositions(:,1,4), batpositions(:,2,4), batpositions(:,3,4), 'r-','LineWidth',2)
% hold on
% 
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% 
% ylim([-13 13])
% 
% if settings.targetsearch == 1
%     text(settings.target(1),settings.target(2),settings.target(3),'Target')
% end
% 
% scatter1 = scatter3(R_cut_1,R_cut_2,R_cut_3,4,'MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7]); 
% % Set property MarkerFaceAlpha and MarkerEdgeAlpha to <1.0
% scatter1.MarkerFaceAlpha = .3;
% scatter1.MarkerEdgeAlpha = .3;
% 
% %  plot3(R_cut_1,R_cut_2,R_cut_3,'.','color',[0.8 0.8 0.8])
%  
% text(0,0,0,'Start')
% grid on
% view(-90,0)
% title("(c)")

%%
subplot(1,2,2)
load('ob1.mat')
a.time_std = std(iteration_valid * 0.1);
a.collision_std = std(collision_valid);
a.tortuosity_std = std(tortuosity_valid);

a.collision_std = std(collision_times);
a.collision_mean = mean(collision_times);

histogram(collision_times,'Normalization','probability','FaceColor',[0.611, 0.611, 0.611],'LineWidth',1.5);
xlabel('Nr of Collisions');
ylabel('Proportion');
collision_median = median(collision_times);
ylim([0,0.5]);
% mylegend = "median:" + string(collision_median) + " std: " + string(a.collision_std) + " mean: " + string(a.collision_mean);
% %add to plot
% legend(mylegend);
% annotation('textbox','String',{'hello', 'world'})
text(12,0.45,'Median: ' + string(collision_median));
text(12,0.4,'Mean: ' + string(a.collision_mean));
text(12,0.35,'Std: ' + string(a.collision_std));
title('(b)')


%%
subplot(1,2,1)
load('ob2.mat')
cutoff = settings.R(:,1)>0;

R_cut_1 = settings.R(:,1) .* cutoff;
R_cut_2 = settings.R(:,2) .* cutoff;
R_cut_3 = settings.R(:,3) .* cutoff;

% plot3(batpositions(:,1,2), batpositions(:,2,2), batpositions(:,3,2), 'r-','LineWidth',2)
h = plot3t(batpositions(:,1,1), batpositions(:,2,1), batpositions(:,3,1),0.05,'r');
% set(h, 'FaceLighting','phong','SpecularColorReflectance', 0, 'SpecularExponent', 10, 'DiffuseStrength', 1);
material shiny; camlight;
hold on

axis equal
xlabel('X')
ylabel('Y')
zlabel('Z')


xlim([-2 2])
ylim([-2,2])
zlim([-2,2])

if settings.targetsearch == 1
    text(settings.target(1),settings.target(2),settings.target(3),'Target')
end

scatter1 = scatter3(R_cut_1,R_cut_2,R_cut_3,100,'MarkerFaceColor',[.7 .7 .7],'MarkerEdgeColor',[.7 .7 .7]); 
% Set property MarkerFaceAlpha and MarkerEdgeAlpha to <1.0
scatter1.MarkerFaceAlpha = .3;
scatter1.MarkerEdgeAlpha = .3;

%  plot3(R_cut_1,R_cut_2,R_cut_3,'.','color',[0.8 0.8 0.8])
 
% text(0,0,0,'Start')
grid on
view(-140,20)
title("(a)")



