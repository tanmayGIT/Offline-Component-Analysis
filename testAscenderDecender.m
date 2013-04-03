

clear all;
close all;
clc;
dirOutput = uigetdir('/Users/tanmoymondal/Documents/Parallel Word Spotting 1.1/Parallel Word Spotting/BatchProcessing/Space Seperated/By MVM/Offline Component Analysis/','Select a folder');
files = dir(fullfile(dirOutput, '*.tif'));
fileNames = {files.name}';
nImages = (length(fileNames));
segmentedDocImageSequence = cell((nImages),1);
imagePath = cell((nImages),1);
imgPath = strcat(dirOutput,'/');
storePath = '/Users/tanmoymondal/Documents/Parallel Word Spotting 1.1/Parallel Word Spotting/BatchProcessing/Space Seperated/By MVM/Offline Component Analysis/textAcsenderDecender/';

if((exist(storePath,'dir'))==0)
    mkdir(storePath);
end
for k = 1:(nImages)
    if(k==5)
        disp('want to see u');
    end
    imageFilePath = [imgPath,fileNames{k}];
    ImgTest = imread(imageFilePath);
    if(size(ImgTest,3)==3)
        ImgTest = rgb2gray(ImgTest);
    end
    ImgTest = uint8(ImgTest);
    performPrunning(ImgTest,k,storePath);
end

return;