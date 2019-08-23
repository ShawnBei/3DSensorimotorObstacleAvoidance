load('clustersGood.mat')
plot3(settings.R(:,1),settings.R(:,2),settings.R(:,3),'.b')
axis equal
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
text(settings.target(1),settings.target(2),settings.target(3),'Target')


text(0,0,0,'Start')