clc
close all
clear
load('3Dtunnel.mat')

% figure (1)
% set(1,'position',[500 300 750 450])
% 
% subplot(2,2,[1,3])
% plot3(batpositions(:,1), batpositions(:,2), batpositions(:,3), 'r-','LineWidth',2)
% hold on
% 
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% ylim([-3 3])
% 
% if settings.targetsearch == 1
%     text(settings.target(1),settings.target(2),settings.target(3),'Target')
% end
% text(0,0,0,'Start')
% 
% hs = surf(t_X,t_Z,t_Y) ;
% grid on;
% set(hs,'FaceColor',[.9 .9 .9],'FaceAlpha',0.1,'EdgeAlpha',0.07)
% 
% view(-40,30)
% title("(a)")
% 
% %%
% subplot(2,2,2)
% 
% plot3(batpositions(:,1), batpositions(:,2), batpositions(:,3), 'r-','LineWidth',2)
% hold on
% 
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% zlim([-7 7])
% xlim([-2 12])
% 
% if settings.targetsearch == 1
%     text(settings.target(1),settings.target(2),settings.target(3),'Target')
% end
% text(0,0,0,'Start')
% 
% hs = surf(t_X,t_Z,t_Y) ;
% grid on;
% set(hs,'FaceColor',[.9 .9 .9],'FaceAlpha',0.1,'EdgeAlpha',0.07)
% 
% view(0,0)
% title("(b)")
% 
% %%
% subplot(2,2,4)
% 
% plot3(batpositions(:,1), batpositions(:,2), batpositions(:,3), 'r-','LineWidth',2)
% hold on
% 
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% xlim([-2 12])
% ylim([-4 4])
% 
% if settings.targetsearch == 1
%     text(settings.target(1),settings.target(2),settings.target(3),'Target')
% end
% text(-0.1,-0.5,0,'Start')
% 
% hs = surf(t_X,t_Z,t_Y) ;
% grid on;
% set(hs,'FaceColor',[.9 .9 .9],'FaceAlpha',0.1,'EdgeAlpha',0.07)
% 
% view(0,90)
% title("(c)")

time_std = std(iteration_valid * 0.1);
collision_std = std(collision_valid);
tortuosity_std = std(tortuosity_valid);