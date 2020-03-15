function [ u, v ] = UntreatedVelocitySS( A, B, P )
% UntreatedVelocitySS returns the velocity at point P generated by a source
% sheet between points A and B with density 1 (e.g. "no" multiplicative
% density, hence untreated).

% The flow field for an untreated source sheet from (-1/2, 0) to (1/2, 0)
u = @(x,y) (1/(4*pi)) * log((x.^2 + x + y.^2 + (1/4))/(x.^2 - x + y.^2 + (1/4)));
v = @(x,y) (1/(2*pi)) * (atan((x + (1/2))/y) - atan((x - (1/2))/y));

% Now we transform A, B and P so that TA = (-1/2, 0), TB = (1/2, 0), and
% evaluate & return (u(TP), v(TP)) (properly rotated back)

% 1. translate AB so that the midpoint of AB lies at (0, 0)
M = (A + B) / 2;
P = P - M;
% 2. get angle of AB and rotate backwards so that AB lies horizontal
theta = -atan((B(2) - A(2)) / (B(1) - A(1)));
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
P = (R * P')';
% 3. stretch AB so that A falls on (-1/2, 0) and B falls on (1/2, 0)
P = P / norm(B - A);
% Calculate translated point and velocity at this point
if P(2) == 0 % careful when transformed y is 0
    % Default take the *upwards* normal as the direction
    % NB this may be cause of weird behaviour later!!!
    unvel = [u(P(1), P(2)), 1/2];
else
    unvel = [u(P(1), P(2)), v(P(1), P(2))];
end

% The only inverse transform we have to do on the velocity is rotation.
R_inv = [cos(theta) sin(theta); -sin(theta) cos(theta)];
unvel = (R_inv * unvel')';
u = unvel(1);
v = unvel(2);

end

