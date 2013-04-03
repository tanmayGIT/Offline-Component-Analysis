%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This code match more than one reference image kept in folder named
% "reference Img" in the following given path and generate the result
% folder. The result folder will contain seperate folders named after 
% the reference images. These reference folders will contain the results 
% of the matching
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

load('segmentedDocImage.mat');
load('imagePath.mat');

clearvars -except testImagePath testFeatureValues
global dividedFeatureMat
global dividedPathMat

dirOutputRefImg = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/reference Img';
filesRef = dir(fullfile(dirOutputRefImg, '*.png'));
fileNamesRef = {filesRef.name}';
imgPathRef = strcat(dirOutputRefImg,'/');
nImagesRef = (length(fileNamesRef));

for goEachRefImg = 1:1:nImagesRef
    imageFilePathRef = [imgPathRef,fileNamesRef{goEachRefImg}];
    [~, refName, refExt] = fileparts(imageFilePathRef);
    
    ImgRef = imread(imageFilePathRef);
    if(size(ImgRef,3)==3)
        ImgRef = rgb2gray(ImgRef);
    end
    
    ImgRef = uint8(ImgRef);
    
    
    dividedFeatureMat = testFeatureValues;
    dividedPathMat = testImagePath;
    performOfflineTest(ImgRef,imageFilePathRef);
    
    
end
