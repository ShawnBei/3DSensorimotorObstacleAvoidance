function out = call(flag,theta,range,delay_window,reflector_strenght)

call_db = 120;
% F = TriScatteredInterp(thetai(:),hrtf(:));

delays = 2*(range/340); %in seconds

spread_loss = 40*log10(0.1./range);
spread_loss(spread_loss>0)=0;
absorp_loss = -1.3*(2*range);

% determine direct_loss
direct_loss = get_direct_loss(flag,theta);
direct_loss(direct_loss<=-20)=-120;

gains = call_db + spread_loss + absorp_loss + direct_loss + reflector_strenght;

selected1 = gains>0; 
max_delay = min(min(delays(selected1)))+delay_window;
if isempty(max_delay);max_delay=0;end
selected2 = delays<=max_delay; 
selected  = (selected1.*selected2)==1;

% out.bearing = bearing(selected);
out.theta = theta(selected);
out.range = range(selected);
out.spread_loss = spread_loss(selected );
out.absorp_loss = absorp_loss(selected );
out.direct_loss = direct_loss(selected );
out.gains = gains(selected);
out.gains_linear =  2*10.^-5 * 10.^(out.gains/20);%http://www.sengpielaudio.com/calculator-soundlevel.htm

end

