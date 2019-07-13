clc
clear
close all

%% // Ring properties
ring.x0 = 5 ;                 %// Center of ring
ring.y0 = 0 ;                 %// Center of ring
ring.radius = 5   ;  %// Radius of core circle profile
ring.nDiv   = 300  ;             %// number of divisions for the core circle profile
ring.theta  = linspace(0,2*pi,ring.nDiv) ;
ring.X = cos(ring.theta) * ring.radius + ring.x0 ;
ring.Y = sin(ring.theta) * ring.radius + ring.y0 ;

%% // Create a base CIRCULAR cross section
cs.Ndiv = 100 ; % 
cs.radius = 1   ; %// Radius of each cross section circle
% cs.rout = 0.25;
cs.theta = linspace(0,2*pi,cs.Ndiv) ;
Npts = length(cs.theta) ;

%// first cross section is the the XZ plane
csY0 = zeros(1,Npts) ;  %// will be used as base for rotating cross sections
csX = sin(cs.theta) * cs.radius ;
csZ = cos(cs.theta) * cs.radius ;

%% Generate coordinates for each cross section and merge them
nCS = length(ring.X) ; %// number of cross sections composing the surface

%// pre-allocation is always good
X = zeros( nCS , Npts ) ;
Y = zeros( nCS , Npts ) ;
Z = zeros( nCS , Npts ) ;

for ip = 1:nCS
   %// rotate the cross section (around Z axis, around origin)
   Rmat = [ cos(ring.theta(ip))  -sin(ring.theta(ip))    ; 
            sin(ring.theta(ip))   cos(ring.theta(ip))   ] ;
   csTemp = Rmat * [csX ; csY0]  ;

   %// translate the coordinates of cross section to final position and store with others 
   X(ip,:) = csTemp(1,:) + ring.X(ip) ;
   Y(ip,:) = csTemp(2,:) + ring.Y(ip) ;
   Z(ip,:) = csZ  ;
end



%% Put x y z into lists
Xlist = X(:);
Ylist = Y(:);
Zlist = Z(:);

%% // Plot the final surface
hs = surf(Xlist,Ylist,Zlist) ;
grid on;
set(hs,'FaceColor',[.7 .7 .7],'FaceAlpha',0.5,'EdgeAlpha',0.2)
view(155,26)

axis equal
xlabel('X') ; ylabel('Y') ; zlabel('Z') ;


