clc;
clear all;

img = imread('sign.jpg');
img = rgb2gray(img);
img = imbinarize(img);
img = bin2gray(img,'qam',16);
img_size = size(img);
alpha = ones(img_size(1), img_size(2));
alpha(img == 1) = 0;
imwrite(img, 'test.png','BitDepth',8,'Alpha',alpha);
imshow(img);