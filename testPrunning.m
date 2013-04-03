% This code is to prune the GW dataset based on their height, width and
% aspect ratio.

clear all;
close all;
clc;
path_1 = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/GW_dash/';
refImg = imread('/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/GW/3010301-001/shouldMatch/refMainImg.jpg');
testImg = imread('/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/GW/3010301-001/shouldMatch/3.jpg');
if(size(refImg,3)==3)
    refImg = rgb2gray(refImg);
end
refImg = uint8(refImg);

if(size(testImg,3)==3)
    testImg = rgb2gray(testImg);
end
testImg = uint8(testImg);

decision = callPrunningCopy(refImg,path_1,testImg);