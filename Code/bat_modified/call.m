function out = call(flag,theta,range,delay_window,reflector_strenght)

call_db = 120;
% F = TriScatteredInterp(thetai(:),hrtf(:));

delays = 2*(range/343); %in seconds

spread_loss = 40*log10(0.1./range);
absorp_loss = -1.3*(2*range);

% determine direct_loss
direct_loss = get_direct_loss(flag,theta);
% direct_loss = F(theta);
direct_loss(direct_loss<=-20)=-120;

% bearing = great_circle(0,0,el,az);
% max_shift = doppler_shift(emission_freq,speed);
% shift = cos(deg2rad(bearing)).*max_shift;
% delta_shift = shift - max_shift;
% Attenuations = -GetAttenuationCurve(delta_shift);

%T1 = nanmax(spread_loss(:));
%T2 = nanmax(absorp_loss(:));
%T3= nanmax(direct_loss(:));
%T4 = nanmax(reflector_strenght(:));
%T5 = nanmax(Attenuations(:));
%disp([T1 T2 T3 T4 T5])
%min(bearing)

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
% out.shift = shift(selected);

end

