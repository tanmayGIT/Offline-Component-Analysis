tic;
close all;
clear  all;clc;

% wordSpottingBatchOperationOfflineMode(ImgTest);
tic;
close all;
clear  all;clc;
ImgTest = imread('BRom_Montaigne1_0177.jpg');
% figure,imshow(ImgTest);
if(size(ImgTest,3)==3)
    ImgTest = rgb2gray(ImgTest);
end
ImgTest = uint8(ImgTest);
[lineWord] = TestwordSpottingBasicOperation(ImgTest);
toc;














% dirOutputRefImg = uigetdir('C:\Study Guru\STUDY GURU\Dataset\Dataset_1','Select Folder of Full Image Dateset');
% imageFilePath_Full = 'C:\Study Guru\STUDY GURU\Dataset\Dataset_1\test textline\';
% filesRef = dir(fullfile(dirOutputRefImg, '*.jpg'));
% fileNamesRef = {filesRef.name}';
% imgPathRef = strcat(dirOutputRefImg,'\');
% nImagesRef = (length(fileNamesRef));
% 
% nImages = nImagesRef;
% % segmentedDocImageSequence = cell((nImages),1);
% % imagePath = cell((nImages),1);
% imgPath = strcat(dirOutputRefImg,'\');
% % global str1;
% % str1 = 1;
% % global imageFilePath_4
% % imageFilePath_4 = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/Dataset_1/testProblem';
% for k = 1:(nImages)
%     
%     imageFilePath = [imgPath,fileNamesRef{k}];
%     ImgTest = imread(imageFilePath);
%     if(size(ImgTest,3)==3)
%         ImgTest = rgb2gray(ImgTest);
%     end
%     ImgTest = uint8(ImgTest);
%     [lineImage] = TestwordSpottingBasicOperation(ImgTest);
%     if((exist(imageFilePath_Full,'dir'))==0)
%         mkdir(imageFilePath_Full);
%     end
%     str1 = int2str(k);
%     imwrite(lineImage,[imageFilePath_Full, str1,'.jpg']);
%     
% end
% 
% toc;