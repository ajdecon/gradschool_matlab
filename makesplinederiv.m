function [spline, deriv]=makesplinederiv(intensity,time)

w=[ ones(1,38), 10*ones(1,62-39), ones(1, 110-62) ];

% Normalize intensity.
%intensity = intensity * 1/max(intensity);


% make splines.
cfunc=csaps(time,intensity,0.0001);
spline=fnval(cfunc,time);
deriv=diff(spline);