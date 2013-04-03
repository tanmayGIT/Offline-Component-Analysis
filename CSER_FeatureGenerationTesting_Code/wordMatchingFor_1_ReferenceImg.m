
clear all;
close all;
clc;

load('segmentedDocImageFrancois.mat');
load('imagePathFrancois.mat');

clearvars -except imagePathFrancois segmentedDocImageFrancois
global dividedFeatureMat
global dividedPathMat

dirOutput = uigetdir('/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/reference Img/','Select a folder');
files = dir(fullfile(dirOutput, '*.jpg'));
fileNamesRef = {files.name}';
imgPathRef = strcat(dirOutput,'/');
nImagesRef = (length(fileNamesRef));

for goEachRefImg = 1:1:nImagesRef
    imageFilePathRef = [imgPathRef,fileNamesRef{goEachRefImg}];
    [~, refName, refExt] = fileparts(imageFilePathRef);
    
    ImgRef = imread(imageFilePathRef);
    if(size(ImgRef,3)==3)
        ImgRef = rgb2gray(ImgRef);
    end
    
    ImgRef = uint8(ImgRef);
    
    
    dividedFeatureMat = segmentedDocImageFrancois;
    dividedPathMat = imagePathFrancois;
    performOfflineTest(ImgRef,imageFilePathRef);
    
    
end
