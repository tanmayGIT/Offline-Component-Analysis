close all;
clear all;
clc;
Img = imread('IMG_1306.JPG');
if(size(Img,3)==3)
    Img = rgb2gray(Img);
end
Img = uint8(Img);



RetineX = retinex_mccann99(Img,4);
RetineX = uint8(RetineX);

figure,imshow(RetineX);

% borderRemoval(Img)