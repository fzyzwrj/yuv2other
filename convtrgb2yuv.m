function convtrgb2yuv(filename, width, height, yuvformat, convmat, is_gamma_corrected)
if nargin < 4
    yuvformat = 'YUV420_8';
end
if nargin < 5
    convmat = 'BT601_common';
end
if nargin < 6
    is_gamma_corrected = true;
end

fid = fopen(filename, 'r');
img_sz = [height, width];
R = fread(fid, img_sz, '*uint8');
G = fread(fid, img_sz, '*uint8');
B = fread(fid, img_sz, '*uint8');

if ~is_gamma_corrected
    error('TODO');
end
switch yuvformat
    case YUV444_8
        
    otherwise
        body
end


end