% function [aznew, elnew, objrangenew] = worldflow(old, deta_az, deta_el, movement)
% 
% aznew = old(:,1) - deg2rad(deta_az);
% elnew = old(:,2) - deg2rad(deta_el);
% 
% range = old(:,3).*cos(elnew);
% 
% X = range.*cos(aznew);
% Y = old(:,3).*sin(elnew);
% Z = range.*sin(aznew);
% 
% Znew = Z - movement;
% 
% aznew = atan2(Znew(:),X(:));
% elnew = atan2(Y(:),Znew(:));
% 
% objrangenew = sqrt(X.^2 + Y.^2 + Znew.^2);
% 
% end

function [Xnew, Ynew, Znew] = worldflow(oldXYZ, deta_az, deta_el, movement)

rads = -deta_el;
Rot1 = [1   0           0;
        0   cos(rads)   sin(rads);
        0   -sin(rads)  cos(rads)];
    
rads = -deta_az;
Rot2 = [cos(rads)   0   sin(rads);
        0           1   0;
        -sin(rads)   0   cos(rads)];

newXYZ = oldXYZ * Rot1 * Rot2;
Xnew = newXYZ(:,1);
Ynew = newXYZ(:,2);
Znew = newXYZ(:,3) - movement;

end








