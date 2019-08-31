clear
clc
close all
figure (1)

% subplot(1,2,1);
% 
% closest = [0:0.1:6];
%  linear_velocity = interp1([20000 5 0],[6 6 0.3],closest);
%  plot(closest,linear_velocity,'k-','LineWidth',2)
% xlabel('Closest Distance [m]')
% ylabel('Linear Velocity [ms^{-1}]')
% ylim([0 7])
% title('(a)')
% 
% subplot(1,2,2);
% 
% linear_velocity = [0:0.1:6];
%  angular_vel = interp1([0 5.71 10],[666 0 0],linear_velocity);
%  if angular_vel<0;angular_vel=0;end
%  plot(linear_velocity,angular_vel,'k-','LineWidth',2)
% xlabel('Linear Velocity [m/s^{-1}]')
% ylabel('Maximum Angular Velocity [degree/s]')
% title('(b)')



x1 = [0:0.1:1];
y1 = interp1([0 0.3 0.5 10],[0 0 100 100],x1);
plot(x1,y1,'k-','LineWidth',2)
hold on
y2 = interp1([0 0.3 0.5 10],[100 100 0 0],x1);
plot(x1,y2,'k--','LineWidth',2)
hold on
xlim([0.2 0.6])
xlabel('Closest Distance [m]')
ylabel('Weights [%]')
a=legend('Target Search','Obstacle Avoidance')
legend(a,'Location','best') 