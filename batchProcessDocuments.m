function[imagePath,segmentedDocImageSequence,copyImageRef] = batchProcessDocuments(dirOutput,fileNames,fcn)

ImgRef = imread('BRom_Montaigne1_0019_Ref.png');
if(size(ImgRef,3)==3)
    ImgRef = rgb2gray(ImgRef);
end

ImgRef = uint8(ImgRef);
[rowRef,~] = size(ImgRef);
[beforeRLSARef,afterRLSARef] = wordSpottingBasicOperation(ImgRef); % for reference image

% figure, imshow(beforeRLSARef),hold on; % showing the reference image
% global refComponent;
refComponent = AnalyzeComponentRefWordForWordLevel(beforeRLSARef,afterRLSARef,ImgRef);

copyImageRef = ImgRef((refComponent{1,1}(1,3)):(refComponent{1,1}(3,3)),(refComponent{1,1}(1,4)):(refComponent{1,1}(4,4)));
% imageFilePath = ['E:\STUDY GURU\Document Dewarping\Perspective_Version1.3\MVM_WordStringMatching\bg1\garamont\' fileNames{3}];
% 
% I = imread(imageFilePath);
% if(size(I,3)==3)
%     I = rgb2gray(I);
% end
% I = uint8(I);
% [nRows,nCols] = size(I);
nImages = (length(fileNames));
segmentedDocImageSequence = cell((nImages),1);
imagePath = cell((nImages),1);
imgPath = strcat(dirOutput,'/');
parfor k = 1:(nImages)
    
    imageFilePath = [imgPath,fileNames{k}];
    ImgTest = imread(imageFilePath);
    if(size(ImgTest,3)==3)
        ImgTest = rgb2gray(ImgTest);
    end
    ImgTest = uint8(ImgTest);
%     segmentedDocImageSequence{k,1} = imageFilePath;
    imagePath{k,1} = imageFilePath;
    segmentedDocImageSequence{k,1} = fcn(ImgTest,refComponent,rowRef);
    
end
return;
end