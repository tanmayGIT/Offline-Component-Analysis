
clear all;
close all;
clc;
% matlabpool open;

% [obtainedMatchingResultOfEachRefImg] = batchProcessDocumentsOfflineMatch();

load('segmentedDocImage.mat');
load('imagePath.mat');
% segmentedDocImageSequence = segmentedDocImageSequence_GW;

% kd = macPathStore;
% macPathStore = segmentedDocImageSequence;
% segmentedDocImageSequence = kd;
clearvars -except imagePath segmentedDocImage

pathstr = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/dickDoom/ComponentsImage/';

if((exist(pathstr,'dir'))==0)
    mkdir(pathstr);
end
cnt = 1;
for goEachImg = 1:1:size(imagePath,1)
    imageFilePath = imagePath{goEachImg,1};
    fullImg = imread(imageFilePath);
    for eachComp = 1:1:size((segmentedDocImage{goEachImg,1}{1,3}),1);
        if(~isempty(segmentedDocImage{goEachImg,1}{1,3}{eachComp,1}))
            r1 = segmentedDocImage{goEachImg,1}{1,3}{eachComp,1}(1,1);
            r2 = segmentedDocImage{goEachImg,1}{1,3}{eachComp,1}(1,2);
            c1 = segmentedDocImage{goEachImg,1}{1,3}{eachComp,1}(1,3);
            c2 = segmentedDocImage{goEachImg,1}{1,3}{eachComp,1}(1,4);
            componentImg = fullImg(r1:r2,c1:c2);
            
            imwrite(componentImg,[pathstr, (int2str(cnt)) '.jpg']);
            cnt = cnt +1;
        end
    end
end
