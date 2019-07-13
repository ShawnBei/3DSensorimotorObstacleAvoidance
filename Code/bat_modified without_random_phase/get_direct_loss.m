function direct_loss = get_direct_loss(flag,theta)

m = size(theta, 1);
switch flag
    case 1 % left ear 
        thetaLeft = theta - 2.3562;
        for i = 1:m
            if thetaLeft(i,1) > pi
                thetaLeft(i,1) = 2*pi - thetaLeft(i,1);
            elseif thetaLeft(i,1) < -pi
                thetaLeft(i,1) = 2*pi + thetaLeft(i,1);
            end
        end
        direct_loss = (cos(thetaLeft) - 1) * 20;
        
    case 2 % right ear
        thetaRight = theta - 0.7854;
        for i = 1:m
            if thetaRight(i,1) > pi
                thetaRight(i,1) = 2*pi - thetaRight(i,1);
            elseif thetaRight(i,1) < -pi
                thetaRight(i,1) = 2*pi + thetaRight(i,1);
            end
        end
        direct_loss = (cos(thetaRight) - 1) * 20;
        
    case 3 % top ear
        thetaTop = theta - 0.5236;
        for i = 1:m
            if thetaTop(i,1) > pi
                thetaTop(i,1) = 2*pi - thetaTop(i,1);
            elseif thetaTop(i,1) < -pi
                thetaTop(i,1) = 2*pi + thetaTop(i,1);
            end
        end
        direct_loss = (cos(thetaTop) - 1) * 20;
        
    case 4 % bottom ear
        thetaBottom = theta + 0.5236;
        for i = 1:m
            if thetaBottom(i,1) > pi
                thetaBottom(i,1) = 2*pi - thetaBottom(i,1);
            elseif thetaBottom(i,1) < -pi
                thetaBottom(i,1) = 2*pi + thetaBottom(i,1);
            end
        end
        direct_loss = (cos(thetaBottom) - 1) * 20;
end


end