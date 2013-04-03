
clear all;
close all;
clc;
% matlabpool open;

% [obtainedMatchingResultOfEachRefImg] = batchProcessDocumentsOfflineMatch();

load('segmentedDocImageSequence.mat');
load('imagePath.mat');
% segmentedDocImageSequence = segmentedDocImageSequence_GW;
macPathStore = imagePath;
% kd = macPathStore;
% macPathStore = segmentedDocImageSequence;
% segmentedDocImageSequence = kd;
clearvars -except macPathStore segmentedDocImageSequence

% dirOutputRefImg = uigetdir('/Users/tanmoymondal/Documents/Study Guru/Dataset/','Select Folder for Reference Image Dateset');
dirOutputRefImg = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/reference Img';
filesRef = dir(fullfile(dirOutputRefImg, '*.jpg'));
fileNamesRef = {filesRef.name}';
imgPathRef = strcat(dirOutputRefImg,'/');
nImagesRef = (length(fileNamesRef));


% dirOutputSourceImgFolders = uigetdir('/Users/tanmoymondal/Documents/Study Guru/Dataset/M0275_01_PR_Tests/Images/','Select Folder for Reference Image Dateset');
dirOutputSourceImgFolders = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/M0275_01_PR_Tests/Images';
filesSource = dir(dirOutputSourceImgFolders);
isDir = [filesSource.isdir];
dirNames = {filesSource(isDir).name};



for goEachRefImg = 1:1:nImagesRef
    imageFilePathRef = [imgPathRef,fileNamesRef{goEachRefImg}];
    [~, refName, refExt] = fileparts(imageFilePathRef);
    
    %     ImgRef = imread(imageFilePathRef);
    %     if(size(ImgRef,3)==3)
    %         ImgRef = rgb2gray(ImgRef);
    %     end
    %
    %     ImgRef = uint8(ImgRef);
    
    for matchImgDir = 1:1:(size(dirNames,2))
        myFolder = dirNames{1,matchImgDir};
        if(strcmp(refName,myFolder))
            eachFolderPath = [dirOutputSourceImgFolders '/' myFolder '/'];
            filesInFolder = dir(fullfile(eachFolderPath, '*.jpg'));
            fileNamesInFolder = {filesInFolder.name}';
            nImagesInFolder = (length(fileNamesInFolder));
            
            storMatchForEachRefImage = cell(nImagesInFolder,1);
            cnt = 1;
            matFeature = cell(nImagesInFolder,1);
            matPath = cell(nImagesInFolder,1);
            
            
            pathstr = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/dickDoom/AllComponentsImage/';
            pathstr1 = [pathstr refName '/'];
            
            
            if((exist(pathstr1,'dir'))==0)
                mkdir(pathstr1);
            end
            
            
            
            for imgInFolder = 1:1:nImagesInFolder
                imageFilePath = [eachFolderPath,fileNamesInFolder{imgInFolder}];
                [~, imgName, imgExt] = fileparts(imageFilePath);
                for getPath = 1:1:size(macPathStore,1)
                    imgPath = macPathStore{getPath,1};
                    [~, storedName, storedExt] = fileparts(imgPath);
                    if(strcmp(storedName,imgName))
                        fullImg = imread(imgPath);
                        %                         str1 = int2str(j);
                        
                        imwrite(fullImg,[pathstr1,storedName '.jpg']);
                    end
                end
            end
            %             newMatFeature = cell((cnt-1),1);
            %             newMatPath = cell((cnt-1),1);
            %             for j = 1:1:(cnt-1)
            %                 newMatFeature{j,1} = matFeature{j,1};
            %                 newMatPath{j,1} = matPath{j,1};
            %
            %             end
            %             getAllComponents(newMatFeature,newMatPath,refName);
            %             dividedFeatureMat = newMatFeature;
            %             dividedPathMat = newMatPath;
            %             performOfflineTest(ImgRef,imageFilePathRef);
            
        end
    end
    
end
