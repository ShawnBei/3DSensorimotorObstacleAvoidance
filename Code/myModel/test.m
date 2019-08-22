clc; clear; close; % clear everything

[x,y,z] = ndgrid(-1:2:12, -8:0.01:8, -1:2:12);
R = [x(:),y(:),z(:)];

plot3(R(:,1),R(:,2),R(:,3),'.b')
axis equal

