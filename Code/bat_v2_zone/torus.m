function [R, X, Y, Z] = torus(Rring,Rtorus,x,y,z)


%% // Ring properties
ring.x0 = x ;                 %// Center of ring
ring.y0 = y ;                 %// Center of ring
ring.radius = Rring   ;         %// Radius of core circle profile
ring.nDiv   = 200  ;             %// number of divisions for the core circle profile
ring.theta  = linspace(0,2*pi,ring.nDiv) ;
ring.X = cos(ring.theta) * ring.radius + ring.x0 ;
ring.Y = sin(ring.theta) * ring.radius + ring.y0 ;

%% // Create a base CIRCULAR cross section
cs.Ndiv = 80 ; % 
cs.radius = Rtorus   ; %// Radius of each cross section circle
% cs.rout = 0.25;
cs.theta = linspace(0,2*pi,cs.Ndiv) ;
Npts = length(cs.theta) ;

%// first cross section is the the XZ plane
csY0 = zeros(1,Npts) ;  %// will be used as base for rotating cross sections
csX = sin(cs.theta) * cs.radius ;
csZ = cos(cs.theta) * cs.radius ;

%% Generate coordinates for each cross section and merge them
nCS = ring.nDiv ; %// number of cross sections composing the surface

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

%% // Plot the final surface
hs = surf(X,Z,Y) ;%1 and 2 change position
grid on;
set(hs,'FaceColor',[.9 .9 .9],'FaceAlpha',0.3,'EdgeAlpha',0.1)
% view(155,26)

axis equal
xlabel('X') ; ylabel('Y') ; zlabel('Z') ;
hold on

%% Put x y z into lists
Xlist = X(:);
Ylist = Z(:);
Zlist = Y(:);%

R = [Xlist,Ylist,Zlist];

end

