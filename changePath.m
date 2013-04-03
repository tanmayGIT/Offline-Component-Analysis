tic;
clear all;
close all;
clc;
macPath1 = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/Dataset_1/Selected Img/';
load('imagePath.mat');
macPathStore = cell((size(imagePath,1)),1);
for getPath = 1:1:size(imagePath,1)
    imgPath = imagePath{getPath,1};
    [~, storedName, storedExt] = fileparts(imgPath);
    macPath = [macPath1 storedName storedExt];
    macPathStore{getPath,1} = macPath;
end
save macPathStore;