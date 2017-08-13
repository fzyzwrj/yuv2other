%% BT.601 mostly used.
%% RGB primaries and reference white
r = [0.67, 0.33, 0.00]';
g = [0.21, 0.71, 0.08]';
b = [0.14, 0.08, 0.78]';
w = [0.3101, 0.3162, 0.3737]';
disp('BT.601 mostly used.');
rgb2yuvT = calf_YUV_coeff(r, g, b, w);
filename = 'BT601_common_T.mat';
save(filename, 'rgb2yuvT');
%    0.2990    0.5870    0.1140
%   -0.1690   -0.3310    0.5000
%    0.5000   -0.4190   -0.0810

%% BT.601 modern 625
r = [0.640; 0.330];
g = [0.290; 0.660];
b = [0.150; 0.060];
w = [0.3127; 0.3290];
disp('BT.601 625.');
rgb2yuvT = calf_YUV_coeff(r, g, b, w);
filename = 'BT601_625_T.mat';
save(filename, 'rgb2yuvT');

%% BT.601 modern 525
r = [0.630; 0.340];
g = [0.310; 0.595];
b = [0.155; 0.070];
w = [0.3127; 0.3290];
disp('BT.601 525.');
rgb2yuvT = calf_YUV_coeff(r, g, b, w);
filename = 'BT601_525_T.mat';
save(filename, 'rgb2yuvT');

%% BT.709
r = [0.640, 0.330];
g = [0.300, 0.600];
b = [0.150, 0.060];
w = [0.3127, 0.3290];
disp('BT.BT709_T.');
rgb2yuvT = calf_YUV_coeff(r, g, b, w);
filename = 'BT709_T.mat';
save(filename, 'rgb2yuvT');

%% BT.2020
% R-REC-BT.2020-2-201510-I!!PDF-E.pdf   P5
r = [0.708  0.292];
g = [0.170  0.797];
b = [0.131  0.046];
w = [0.3127  0.3290];
disp('BT.2020');
rgb2yuvT = calf_YUV_coeff(r, g, b, w);
filename = 'BT2020_T.mat';
save(filename, 'rgb2yuvT');




function YUV_coeff = calf_YUV_coeff(r, g, b, w)
% Calculate coeff of Y according to the RGB primaries and reference white.
% the input param should be length 2 or 3. z = 1 - x - y.
% Input:
% r, g, b - RGB primaries. ie, x_r, x_y, x_z; x_g, y_g, z_g;...
% w - white reference ie, x_w, y_w, z_w.
% 
% Output:
% Y - 3 x 3 coeff.
r = r(:);
g = g(:);
b = b(:);
w = w(:);
if length(r) < 3
    r = [r; 1 - sum(r)];
end
if length(g) < 3
    g = [g; 1 - sum(g)];
end
if length(b) < 3
    b = [b; 1 - sum(b)];
end
if length(w) < 3
    w = [w; 1 - sum(w)];
end
A = [r';g';b']';
K = A \ (w / w(2));
Y = K' .* [r(2), g(2), b(2)];

Y_round = round(Y * 1000) / 1000;
if (sum(Y_round) ~= 1)
%     disp('The sum of coeff Y is not 1');
end
U = [   -Y_round(1),    -Y_round(2), 1 - Y_round(3)] / ((1 - Y_round(3)) / 0.5);
V = [1 - Y_round(1),    -Y_round(2),    -Y_round(3)] / ((1 - Y_round(1)) / 0.5);
U_round = round(U * 1000) / 1000;
if (sum(U_round) ~= 1)
%     disp('The sum of coeff U is not 1');
end

V_round = round(V * 1000) / 1000;
if (sum(V_round) ~= 1)
%     disp('The sum of coeff V is not 1');
end

YUV_coeff = [Y_round; U_round; V_round];
disp(YUV_coeff);
% U = B' - Y    Cb
% V = R' - Y    Cr
end

