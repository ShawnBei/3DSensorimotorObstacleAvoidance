function [az,el,objrange]= mycart2sph(X,Y,Z)

objrange = sqrt(X.^2 + Y.^2 + Z.^2);
az = atan2(Z(:),X(:));
el = atan2(Y(:),Z(:));

end



