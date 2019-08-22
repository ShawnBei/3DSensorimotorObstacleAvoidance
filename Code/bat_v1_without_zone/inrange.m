function elevation_ok = inrange(alpha, range)

if alpha > range(2) || alpha < range(1)
    elevation_ok = false;  
else
    elevation_ok = true;
end


end