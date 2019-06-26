clc;
clear;
close all;

%%
% figure (1)
% set(1,'position',[850 200 800 800])
% figure (2)
% set(2,'position',[850 200 800 800])
% 
% % 
% r = 5;
% x = 0;
% z = 0;
% 
% figure (1)
% circle(x,z,r);
% axis equal
% axis([-5 5 -5 5])
% grid on
% 
% 
% theta = -90:1:90;
% 
%     
% dB = (cos(deg2rad(theta))-1)*25;
% 
% figure (2)
% plot(theta, dB, '*');


%set(gca,'xtick',[])



%%
gbat = 120;
af = -1.3;
batPosition = [0; 0]; 

% Heading direction 45º to x axis
Heading = 45;

% The angle between two ears is 60º
leftHeading = deg2rad(75);
rightHeading = deg2rad(15);

reflector = [1 2 3; 2 3 1];

% Distance between reflectors and bat
range = sqrt((reflector(1,:) - batPosition(1,1)).^2 + (reflector(2,:) - batPosition(2,1)).^2);

% Travel time
travelTime = range*2/340;

% Directionality
thetaLeft = atan2(reflector(2,:), reflector(1,:)) - leftHeading;
thetaRight = atan2(reflector(2,:), reflector(1,:)) - rightHeading;

dLeft = (cos(thetaLeft) - 1) * 20;
dRight = (cos(thetaRight) - 1) * 20;

% intensity
gi = gbat + 40*log10(0.1./range) + 2*(range-0.1)*af;
gl = gi + dLeft;
gr = gi + dRight;


figure (1)
set(1,'position',[850 200 400 400])
plot(travelTime, gl, '*b')
axis([0 0.05 0 120])
hold on
plot(travelTime, gr, '*r')

% gt











