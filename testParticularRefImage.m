% May be this code is checking the component in a particular image with a
% single component. For the test purpose only I had generated a image by typing 
% in the Ms word with some word having predecessor and sucessors. The
% purpose was to check the robustness of the algorighm with different
% predessor and sucessor.
% So here the input argument is: 1 image with different words and the image
% of a sigle word
 

clear all;
close all;
clc;

load('segmentedDocImageGW.mat');
load('imagePathGW.mat');
global dividedFeatureMat;
global dividedPathMat;

dividedFeatureMat = segmentedDocImageGW;
dividedPathMat = imagePathGW;
[fn pn] = uigetfile('*.jpg','select reference file');
complete = strcat(pn,fn);

ImgRef = imread(complete);
if(size(ImgRef,3)==3)
    ImgRef = rgb2gray(ImgRef);
end

ImgRef = uint8(ImgRef);

performOfflineTest(ImgRef,complete)
