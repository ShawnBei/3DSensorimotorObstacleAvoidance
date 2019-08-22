function [heading_new,Y_axis_new,X_axis_new] = headingRot(heading,Y_axis,X_axis,current_el,current_az)
%HEADING Summary of this function goes here
%   Detailed explanation goes here

    W_x = [0             -X_axis(3)      X_axis(2);
        X_axis(3)     0               -X_axis(1);
        -X_axis(2)    X_axis(1)       0        ];     % el
    
    rads = -current_el;
    RotX = eye(3) + sin(rads) * W_x + (2*(sin(rads/2)^2)) * (W_x^2);
    
    % elevation rotation
    Y_axis_new = RotX * Y_axis;
    heading_new = RotX * heading;
    
    W_y = [0             -Y_axis_new(3)      Y_axis_new(2);
        Y_axis_new(3)     0               -Y_axis_new(1);
        -Y_axis_new(2)    Y_axis_new(1)       0        ];     % az
    
    rads = -current_az;
    RotY = eye(3) + sin(rads) * W_y + (2*(sin(rads/2)^2)) * (W_y^2);
    
    % azimuth rotation
    X_axis_new = RotY * X_axis;
    heading_new = RotY *  heading_new;



end

