function generateWordSpottingOfflineData_CSER()

dirOutput = uigetdir('/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/M0275_01_PR_Tests/Images/','Select a folder');
files = dir(fullfile(dirOutput, '*.jpg'));
fileNames = {files.name}';

% matlabpool open;
[segmentedDocImageFrancois,imagePathFrancois] = batchProcessDocumentsOffline(dirOutput,fileNames,@wordSpottingBatchOperationOfflineMode);

% for i=1:1:(size(segmentedDocImageSequence,1))
%     path = imagePath{i,1};
%     im = imread(path);
%     figure, imshow(im);
%     for j = 1:1:size(segmentedDocImageSequence{i,1}{1,3},1)
%         if(~isempty(segmentedDocImageSequence{i,1}{1,3}{j,1}))
%             minRw = segmentedDocImageSequence{i,1}{1,3}{j,1}(1,1);
%             maxRw = segmentedDocImageSequence{i,1}{1,3}{j,1}(1,2);
%             minCol = segmentedDocImageSequence{i,1}{1,3}{j,1}(1,3);
%             maxCol = segmentedDocImageSequence{i,1}{1,3}{j,1}(1,4);
% %             Y = [minRw maxRw];
% %             X = [minCol maxCol];
%             rectangle('Position',[minCol,minRw,(maxCol-minCol),(maxRw-minRw)]);
%         end
%     end
% end
save segmentedDocImageFrancois;
save imagePathFrancois;
% performTest(segmentedDocImageSequence,imagePath);

% matlabpool close;
return;
end
