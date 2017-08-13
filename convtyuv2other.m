function RGB = convtyuv2other(filename, width, height, yuvformat, convmat)
% Convert yuv format file to other color space file.
% [R, G, B] = convtyuv2other(filename, width, height, yuvformat, convmat)
% Input:
% yuvformat - YUV format [optional, default = 'YUV420_8']. Supported YUV format
%		      formats are:
%             'YUV444_8' = 4:4:4 sample, 8-bit precision
%			  'YUV422_8' = 4:2:2 sample, 8-bit precision
%			  'YUV411_8' = 4:1:1 sample, 8-bit precision
%			  'YUV420_8' = 4:2:0 sample, 8-bit precision
%      		  TODL: In future, I will support 10bit.
% convmat - Conversion matrix [optional, default = 'BT601_1']. The following
% 			conversions are defined bellow:
%			'BT601_common' = ITU-R BT.601 limited [16...235], mostly used.
%			'BT601_525' = ITU-R BT.601 limited [16...235], used in modern NTSC.
%			'BT601_625' = ITU-R BT.601 limited [16...235], used in modern PAL.
%			'BT709' = ITU-R Bt.709 limited [16...235], used in morden 
%			TODO: In future, I will support other convmat.
% Output:
% [R, G, B] - RGB use the full range and not gamma pre-corrected.
if nargin < 4
	yuvformat = 'YUV420_8';
end
if nargin < 5
	convmat = 'BT601_common';
end

[Y, U, V] = read_yuv_from_stream(filename, width, height, yuvformat);

[Y, U, V] = YUV_upsample(Y, U, V);

switch convmat
	case 'BT601_common'
		load('BT601_common_T.mat');
	case 'BT601_525'
		load('BT601_525_T.mat');
	case 'BT601_625'
		load('BT601_625_T.mat');
	case 'BT709'
		load('BT709_T.mat');
	case 'BT2020'
		load('BT2020_T.mat');
	otherwise
		error('Unknow yuvformat');
end
T = inv(rgb2yuvT);
%% TODO add support for 10bit...
yuvoffset = [16, 128, 128];
normal_factor = [219, 224, 224];
yuvoffset  = yuvoffset ./ normal_factor;
Y = Y / normal_factor(1);
U = U / normal_factor(2);
V = V / normal_factor(3);

[R, G, B] = yuv_convert2_rgb(Y, U, V, yuvoffset, T);
RGB = cat(3, R, G, B);
RGB = inv_gamma_precorrected(RGB);
RGB = uint8(round(RGB * 255));
end


function [Y, U, V] = read_yuv_from_stream(filename, width, height, yuvformat)
% Read YUV data from file, format of output data is uchar
height_y = height;
width_y = width;
switch yuvformat
	case 'YUV444_8'
		height_uv = height;
		width_uv = width;
	case 'YUV422_8'
		height_uv = height;
		width_uv = width / 2;
	case 'YUV411_8'
		height_uv = height;
		width_uv = width / 4;
	case 'YUV420_8'
		height_uv = height / 2;
		width_uv = width / 2;
	otherwise
        error('Unexpected yuvformat.');
end
stream_sz = width_y * height_y + width_uv * height_uv * 2;

fid = fopen(filename, 'r');
stream = fread(fid, stream_sz, '*uint8');

% y = zeros(height, width);
% u = zeros(height / 2, width / 2);
% v = zeros(height / 2, width / 2);
y_sz = width_y * height_y;
u_sz = width_uv * height_uv;
v_sz = width_uv * height_uv;

Y = reshape(stream(1:y_sz), [width_y, height_y])';   % 列优先，要旋转
U = reshape(stream(y_sz + 1 : y_sz + u_sz), [width_uv, height_uv])';
V = reshape(stream(y_sz + u_sz + 1 : y_sz + u_sz + v_sz), [width_uv, height_uv])';
end


function [Y, U, V] = YUV_upsample(Y, U, V);
Y = double(Y);
U = imresize(double(U), size(Y), 'bicubic');
V = imresize(double(V), size(Y), 'bicubic');
end 

function [R, G, B] = yuv_convert2_rgb(Y, U, V, yuvoffset, T);
% Y, U, V in [0...1]
% R, G, B in [0...1]

if yuvoffset(1) ~= 0
	Y = Y - yuvoffset(1);
end
if yuvoffset(2) ~= 0
	U = U - yuvoffset(2);
end
if yuvoffset(3) ~= 0
	V = V - yuvoffset(3);
end

R = T(1, 1) * Y + T(1, 2) * U + T(1, 3) * V;
G = T(2, 1) * Y + T(2, 2) * U + T(2, 3) * V;
B = T(3, 1) * Y + T(3, 2) * U + T(3, 3) * V;
end

function Y = inv_gamma_precorrected(X, alpha, beta)
if nargin < 2
	alpha = 1.099;
	beta = 0.018;
end

% if (X < 0) || (X > 1)
% 	error('X should be in range [0...1]');
% end
if X < beta
	Y = X / 4.5;
else
	Y = ((X + alpha - 1) / alpha).^(1 / 0.45);
end
% TODO
Y = real(Y);
end


function Y = gamma_precorrected(X, alpha, beta)
if nargin < 2
	alpha = 1.099;
	beta = 0.018;
end
% if (X < 0) || (X > 1)
% 	error('X should be in range [0...1]');
% end
if X < beta
	Y = X * 4.5;
else
	Y = alpha * X.^0.45 - (alpha - 1);
end
Y = real(Y);
end
