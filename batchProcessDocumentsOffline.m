function[segmentedDocImageSequence,imagePath] = batchProcessDocumentsOffline(dirOutput,fileNames,fcn)


nImages = (length(fileNames));
segmentedDocImageSequence = cell((nImages),1);
imagePath = cell((nImages),1);
imgPath = strcat(dirOutput,'/');
% global str1;
% str1 = 1;
% global imageFilePath_4
% imageFilePath_4 = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/Dataset_1/testProblem';
progressbar(0,0,0); % Init 3 bars
parfor k = 1:(nImages)
%     if(k==5)
%         disp('want to see u');
%     end
    imageFilePath = [imgPath,fileNames{k}];
    ImgTest = imread(imageFilePath);
    if(size(ImgTest,3)==3)
        ImgTest = rgb2gray(ImgTest);
    end
    ImgTest = uint8(ImgTest);
%     segmentedDocImageSequence{k,1} = imageFilePath;
%     if(k==9)
%         disp('I m here');
%     end
    imagePath{k,1} = imageFilePath;
    segmentedDocImageSequence{k,1} = fcn(ImgTest);
%     waitbar(k/nImages);`
     progressbar(k/nImages)  
end
% close(h);
return;
end