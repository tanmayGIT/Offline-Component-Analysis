function generateWordSpottingOfflineComponentDataExperiment()

dirOutput = uigetdir('/Users/tanmoymondal/Documents/Parallel Word Spotting 1.1/Parallel Word Spotting/BatchProcessing/Space Seperated/By MVM/Offline Component Analysis/test folder/','Select a folder');
files = dir(fullfile(dirOutput, '*.png'));
fileNames = {files.name}';

% matlabpool open;
[testImagePath,testFeatureValues] = batchProcessDocumentsOfflineExp(dirOutput,fileNames,@wordSpottingBatchOperationOfflineModeExp);

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

save testFeatureValues;
save testImagePath;
% matlabpool close;
return;
end
