close all;
clear all;
clc;

% Read text file "relvance_judgement.txt"
fid = fopen('relevance_judgment.txt','rt');
nLinesT1 = 0;

global dividedFeatureMat
global dividedPathMat

while (fgets(fid) ~= -1),
    nLinesT1 = nLinesT1+1;
    %     [P{nLinesT1,1},Q{nLinesT1,1},R{nLinesT1,1},S{nLinesT1,1}] = textread('testsuite_images.txt','%s',1);
end
fclose(fid);
[P,Q,R,S] = textread('relevance_judgment.txt','%d %s %d %d',nLinesT1);


%Read text line "testsuite_images.txt"
fid = fopen('testsuite_images.txt','rt');
nLinesT2 = 0;

while (fgets(fid) ~= -1),
    nLinesT2 = nLinesT2+1;
    
end
[A] = textread('testsuite_images.txt','%s',nLinesT2);
fclose(fid);
%randNum = randi(nLinesT2,1,30);

load ('segmentedDocImageGW.mat');
load ('imagePathGW.mat');

X = segmentedDocImageGW;
dividedFeatureMat = X;
allImgPath = imagePathGW;
dividedPathMat = allImgPath;
% clearvars -except X allImgPath dividedPathMat dividedFeatureMat;
nImage = size(X,1);
% randNum = randi(nImage,1,5);
% randNum = [6 15 32 54 65];
 randNum = [15 32]; %54 65 93 112 179 205 206 208 248 491 496 2358 2203 2167 2138 1166 1097 1023 784 249 227 219 119 93];
% randNum = [206 208 248 491 496 2358 2203 2167 2138 1166 1097 1023 784 249 227 219 119 93];

path_1 = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/GW/';


% h=waitbar(0,'Please wait..');
for ichk=1:1:(length(randNum))
    

    imgPath = allImgPath{(randNum(1,ichk)),1} ;
    [pathstr, name, ext] = fileparts(imgPath) ;
    
    refImgIndex = (randNum(1,ichk));
    %     testImgPath = allImgPath{testImgIndex,1};
    refImgRead = imread(imgPath);
    %     figure,imshow(testImgRead);
    
    
    %make directory same name of the image
    imageFolder = [path_1 name '/'];
    
    imageFolder_1 = [imageFolder 'shouldMatch' '/'];
    
    if((exist(imageFolder_1,'dir'))==0)
        mkdir(imageFolder_1);
    end
    imwrite(refImgRead,[imageFolder_1,'refMainImg' '.jpg']);
    
    imgIndex = getIndexOfImage(name,A);
    indx1 = find(P == imgIndex);
    %     indx2 = find(R == imgIndex);
    sameImgNameMat = cell((length(indx1)),1);
    if(~isempty(indx1))
        for getSame = 1:1:(length(indx1))
            sameImageName = A{(R((indx1(getSame,1)),1)),1};
            sameImgNameMat{getSame,1} = sameImageName;
            fullImagePath = [pathstr,'/',sameImageName];
            sameImg = imread(fullImagePath);
            imwrite(sameImg,[imageFolder_1,(int2str(getSame)) '.jpg']);
        end
       
    end
      callPrunning(refImgRead,imageFolder_1,sameImgNameMat)
    
end