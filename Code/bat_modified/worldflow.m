function [aznew, elnew, objrangenew] = worldflow(old, current_az, current_el, movement)

aznew = old(:,1) - current_az;
elnew = old(:,2) - current_el;

range = old(:,3).*cos(elnew);

X = range.*cos(aznew);
Y = old(:,3).*sin(elnew);
Z = range.*sin(aznew);

Znew = Z - movement;

objrangenew = sqrt(X.^2 + Y.^2 + Znew.^2);



end