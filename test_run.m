RGB = convtyuv2other('flower.yuv', 720, 480, 'YUV420_8');
figure(1);
subplot(221); imshow(RGB(:, :, 1));
subplot(222); imshow(RGB(:, :, 2));
subplot(223); imshow(RGB(:, :, 3));