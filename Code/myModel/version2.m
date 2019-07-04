clc;
clear;
close all;

%% gi

% Initialization
gbat = 120; % 120 dB
af = -1.3; % -1.3dB/m
batPosition = [0; 0]; 
Heading = pi/4; % Heading direction 45º to x axis
linearVelocity = 6; % 6m/s
angularVelocity = 0; % 0rad/s


BAT = [batPosition; Heading; linearVelocity; angularVelocity];

% store bat position into position history
batPositionHistory = batPosition;

reflector = [1 2 3 1.1 ; 
             2 3 1 1.9 ]



% for loop starts

% Distance between reflectors and bat
range = sqrt((reflector(1,:) - batPosition(1,1)).^2 + (reflector(2,:) - batPosition(2,1)).^2);

% Travel time
travelTime = range*2/340;

% find the smallest range and travel time 
minTravelTime = min(travelTime);
minRange = min(range);

% remove echoes later than 1ms + minTravelTime
oneMilliSecond = minTravelTime + 0.001;
Filtered = [reflector; range; travelTime];
Filtered(:, Filtered(4,:) > oneMilliSecond) = [];

% The angle between two ears is 60º
leftHeading = BAT(3,1) + pi/6;
rightHeading = BAT(3,1) - pi/6;

% Directionality
thetaLeft = atan2(Filtered(2,:), Filtered(1,:)) - leftHeading;
thetaRight = atan2(Filtered(2,:), Filtered(1,:)) - rightHeading;

m = size(thetaLeft, 2);
for i = 1:m
    if thetaLeft(1,i) > pi
        thetaLeft(1,i) = 2*pi - thetaLeft(1,i);
    end
    if thetaLeft(1,i) < -pi
        thetaLeft(1,i) = 2*pi + thetaLeft(1,i);
    end
    if thetaRight(1,i) > pi
        thetaRight(1,i) = 2*pi - thetaRight(1,i);
    end
    if thetaRight(1,i) < -pi
        thetaRight(1,i) = 2*pi + thetaRight(1,i);
    end
end


dLeft = (cos(thetaLeft) - 1) * 20;
dRight = (cos(thetaRight) - 1) * 20;

% intensity
gi = gbat + 40*log10(0.1./Filtered(3,:)) + 2*(Filtered(3,:)-0.1)*af;
giL = gi + dLeft;
giR = gi + dRight;

LEFT = [Filtered; thetaLeft; dLeft; giL];
RIGHT = [Filtered; thetaRight; dRight; giR];


% set giL to 0 when theta>90 or theta<-90
giL(1, thetaLeft(1,:) < -pi/2 | thetaLeft(1,:) > pi/2 ) = 0;
giR(1, thetaRight(1,:) < -pi/2 | thetaRight(1,:) > pi/2 ) = 0;
 

figure (1)
set(1,'position',[850 400 400 400])
plot(LEFT(4,:), LEFT(7,:), '*b')
axis([0 0.05 0 120])
hold on
plot(RIGHT(4,:), RIGHT(7,:), '*r')

figure (2)
clf
plot(reflector(1,:), reflector(2,:),'*b')
hold on
plot(batPosition(1,:),batPosition(2,:), 'or')
batPosition
batCos = 0.05*linearVelocity * cos(Heading);
batSin = 0.05*linearVelocity * sin(Heading);
plot([batPosition(1,:) batPosition(1,:)+batCos],[batPosition(2,:) batPosition(2,:)+batSin], 'r')


%% gt

% gennerate random phase between -pi and pi
min = -pi;
max = pi;
randomPhaseLeft = -pi + 2*pi*rand(1,size(LEFT, 2));
randomPhaseRight = -pi + 2*pi*rand(1,size(RIGHT, 2));

% calculate gt for both ears
sumL = abs(sum(10.^(LEFT(7,:)/20) .* exp(1i*randomPhaseLeft)));
sumR = abs(sum(10.^(RIGHT(7,:)/20) .* exp(1i*randomPhaseRight)));

gtL = 20*log10(sumL);
gtR = 20*log10(sumR);

%% determine speed and angular velocity

% calculate the position during t = 0 ?> t = minTravelTime + 50ms + 1ms


% store position in batPositionHistory


% calculate the position during t = minTravelTime + 50ms + 1ms --> t = 100ms
linearVelocityDesired = 1.14*minRange+0.3;
timeLinearChange = (linearVelocityDesired - linearVelocity)/4.3;

% store position in batPositionHistory


% for loop ends


















