%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function Name : Word Spotting                                          %
%  Author : Tanmay                                                        %
%  Date : 08/09/2012                                                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I think it is for windows only see the path given here





tic;
clear all;
close all;
clc;
% matlabpool open;

% [obtainedMatchingResultOfEachRefImg] = batchProcessDocumentsOfflineMatch();

 load('segmentedDocImageSequence.mat');
 load('imagePath.mat');


dirOutputRefImg = uigetdir('C:\Study Guru\STUDY GURU\Dataset','Select Folder for Reference Image Dateset');
filesRef = dir(fullfile(dirOutputRefImg, '*.jpg'));
fileNamesRef = {filesRef.name}';
imgPathRef = strcat(dirOutputRefImg,'\');
nImagesRef = (length(fileNamesRef));

imagePathProb = imagePath;

storMatchForEachRefImage = cell(nImagesRef,1); % storing match for each reference Image;
dickDoom = cell((size(segmentedDocImageSequence,1)),1);%cell(2,1); 
cntdd = 1;
for jick = 1:1:(size(segmentedDocImageSequence,1))
    dickDoom{cntdd,1} = segmentedDocImageSequence{jick,1}; 
    cntdd = cntdd +1;
end

% bestImageMatchForRefImg = cell(nImagesRef,1);
progressbar(0,0,0) % Init 3 bars
clearvars -except dickDoom imagePathProb storMatchForEachRefImage fileNamesRef imgPathRef nImagesRef
storThresh = zeros(nImagesRef,3);
for refImg = 1:1:nImagesRef
    imageFilePathRef = [imgPathRef,fileNamesRef{refImg}];
    ImgRef = imread(imageFilePathRef);
    if(size(ImgRef,3)==3)
        ImgRef = rgb2gray(ImgRef);
    end
   
    ImgRef = uint8(ImgRef);
    
    [beforeRLSARef,afterRLSARef,avgCharHght] = wordSpottingBasicOperationRef(ImgRef); % for reference image
    
    % Normalize each feature in right manner so that the feature matrix
    % should not have any influence on height of component
    
    %     refComponentMat = AnalyzeComponentRefWordForWordLevel(beforeRLSARef,afterRLSARef,ImgRef);
    %     refComponentSize = (size(refComponentMat{1,2},2));
    %     refMatForMatch = (refComponentMat{1,3}); % getting the number of columns of the image
    %     realIndexRef = (refComponentMat{1,4});
    
    storMatchingDistanceOfEachImg = cell((size(dickDoom,1)),1); % equal to the number of image for testing
    storMatchingWarpingPathOfEachImg = cell((size(dickDoom,1)),1);
    storMatchingBoundaryOfEachImg = cell((size(dickDoom,1)),1);
    storRefImgForEachImg = cell((size(dickDoom,1)),1);
    storPathOfEachImg = cell((size(dickDoom,1)),1);
    %**************
    progressbar([],[],0) % Reset 2nd bar
    sz_11 = size(dickDoom,1);
    if(refImg == 8)
        disp('hello');
    end
    for eachImg = 1:size(dickDoom,1)
        
        [~,~,componentsFeatureMatrixRefined] = findApplicableForCell(dickDoom{eachImg,1}{1,4}); % the orogonal feature mat
        [~,~,segmentedWarpingPathRefined] = findApplicableForCell(dickDoom{eachImg,1}{1,5});
        [~,~,segmentedDocImageSequenceBoundaryRefined] = findApplicableForCell(dickDoom{eachImg,1}{1,3}); % store the boundary of each component
        
        storWarpingPathOfComponents = cell((size(segmentedWarpingPathRefined,1)),1); % doing for each component in the image
        storDistancesOfComponents = zeros((size(componentsFeatureMatrixRefined,1)),1); % doing for each component in the image
        storBoundaryOfComponents = cell((size(segmentedDocImageSequenceBoundaryRefined,1)),1);
        storRefImgForEachCompoent = cell((size(segmentedDocImageSequenceBoundaryRefined,1)),1);
        averageChHghtInPage = dickDoom{eachImg,1}{1,6}; % average height of the image
        
        
        % TAKING THE NORMAL FEATURE MATRIX NOT THE PRINCIPAL COMPONENT
        % MATRIX
        
        % avgCharHght =  the average height of the characters in the
        % compponent image
        
        progressbar([],0)
        sz_12 = (size(componentsFeatureMatrixRefined,1));
        parfor eachRelevantComp = 1:(size(componentsFeatureMatrixRefined,1)) % for all the no. component having in the image
            
            
            if(~(isempty(componentsFeatureMatrixRefined{eachRelevantComp,1})))
                testMat = (componentsFeatureMatrixRefined{eachRelevantComp,1});
                
                componentHght = ((segmentedDocImageSequenceBoundaryRefined{eachRelevantComp,1}(1,2)) - ...
                    (segmentedDocImageSequenceBoundaryRefined{eachRelevantComp,1}(1,1)))+1;
                % resizing each ref image w.r.t the component image height
                refComponentMat = AnalyzeComponentRefWordForWordLevel(beforeRLSARef,afterRLSARef,ImgRef,componentHght);
                
                refComponentSize = (size(refComponentMat{1,2},2)); % getting number of col in ref component img
                refMatForMatch = (refComponentMat{1,3}); % getting the number of columns of the image
                realIndexRef = (refComponentMat{1,4});
                
                realImageRef = ImgRef((refComponentMat{1,1}(1,3)):(refComponentMat{1,1}(3,3)),(refComponentMat{1,1}(1,4)):(refComponentMat{1,1}(4,4)));
                
                
                
                
                if((refComponentSize/4) <= (size(testMat,1))) % If the size of the word is more than the reference word
                    realIndexTest = segmentedWarpingPathRefined{eachRelevantComp,1}; % the real index is stored in the 5th cell
                    [~,distVal,getIndexes] = stringMatchingWithMVM(refMatForMatch,testMat,realIndexRef,realIndexTest);
                    storWarpingPathOfComponents{eachRelevantComp,1} = getIndexes;
                    storDistancesOfComponents(eachRelevantComp,1) = distVal;
                    storRefImgForEachCompoent{eachRelevantComp,1} = refComponentMat{1,2};%keeping the componentn image
                    storBoundaryOfComponents{eachRelevantComp,1} = segmentedDocImageSequenceBoundaryRefined{eachRelevantComp,1};
                end
                
            end
            progressbar([],eachRelevantComp/sz_12) % Update 3rd bar
        end
        
        clearvars -except storMatchingDistanceOfEachImg storWarpingPathOfComponents storDistancesOfComponents...
            storRefImgForEachCompoent storBoundaryOfComponents dickDoom imageFilePathRef...
            storRefImgForEachImg storPathOfEachImg storMatchingWarpingPathOfEachImg storMatchingBoundaryOfEachImg...
            eachImg storDistancesOfComponents storRefImgForEachCompoent storBoundaryOfComponents imagePathProb sz_11...
            beforeRLSARef afterRLSARef avgCharHght ImgRef refImg nImagesRef imgPathRef fileNamesRef storMatchForEachRefImage;
        
        %         storWarpingPathOfComponents will contain all the warping path of
        %         all the component in the every image
        [indexWrapPath,~,nonZeroWarpingPathOfComponents] = findApplicableForCell(storWarpingPathOfComponents); % warping path
        [~,~,nonZeroDistancesOfComponents] = find(storDistancesOfComponents); % store distance
        [~,~,nonZeroRefImgForEachCompoent] = findApplicableForCell(storRefImgForEachCompoent); % store distance
        [~,~,nonZeroBoundaryOfComponents] = findApplicableForCell(storBoundaryOfComponents); % warping path
        
        storMatchingDistanceOfEachImg{eachImg,1} =  nonZeroDistancesOfComponents;
        storMatchingWarpingPathOfEachImg{eachImg,1} = nonZeroWarpingPathOfComponents;
        storMatchingBoundaryOfEachImg{eachImg,1} = nonZeroBoundaryOfComponents;
        storRefImgForEachImg{eachImg,1} = nonZeroRefImgForEachCompoent;
        storPathOfEachImg{eachImg,1} = imagePathProb{eachImg,1};
        progressbar([],[],eachImg/sz_11)
    end
    
    
    %     [~,~,storMatchingDistanceOfEachImg] = findApplicableForCell(storMatchingDistanceOfEachImg);
    %     [~,~,storMatchingWarpingPathOfEachImg] = findApplicableForCell(storMatchingWarpingPathOfEachImg);
    %     [~,~,storMatchingBoundaryOfEachImg] = findApplicableForCell(storMatchingBoundaryOfEachImg);
    [~,~,storPathOfEachImg] = findApplicableForCell(storPathOfEachImg);
    
    clearvars -except storMatchingDistanceOfEachImg storMatchingWarpingPathOfEachImg storMatchingBoundaryOfEachImg...
        storRefImgForEachImg storPathOfEachImg dickDoom imageFilePathRef eachImg imagePathProb refImg nImagesRef  imgPathRef fileNamesRef storMatchForEachRefImage; 
    
    
    
    %% For calculating the threshold distance
    
    mergeDistMat = zeros((size(storMatchingDistanceOfEachImg{1,1},1)),1);
    
    for eachImgMatchingDist = 1:(size(storMatchingDistanceOfEachImg,1))
        if(eachImgMatchingDist == 1)
            getAllDist = storMatchingDistanceOfEachImg{eachImgMatchingDist,1};
            mergeDistMat(1:end) = getAllDist(1:end);
        else
            getAllDist = storMatchingDistanceOfEachImg{eachImgMatchingDist,1};
            sizeOfDistArr = size(getAllDist,1);
            sizeOfCurrentMergeDist = size(mergeDistMat,1);
            mergeDistMat((end+1):(sizeOfCurrentMergeDist+sizeOfDistArr),1) = getAllDist(1:end);
            
        end
        
    end
    mergeDistMat = sort(mergeDistMat);
    topEntries_1 = ceil(((size(mergeDistMat,1))*15)/100); % top 15% entries is upto which cell
    topEntries_2 = ceil(((size(mergeDistMat,1))*30)/100); % top 30% entries is upto which cell
    topEntries_3 = ceil(((size(mergeDistMat,1))*65)/100); % top 65% entries is upto which cell
    
    %     meanDistVal = nanmedian(mergeDistMat);
    %     prominentLevel1 = ((meanDistVal*33.3333)/100);
    %     prominentLevel2 = ((meanDistVal*(33.3333+33.3333))/100);
    %     prominentLevel3 = meanDistVal;
    
    prominentLevel1 = mergeDistMat(topEntries_1,1);
    prominentLevel2 = mergeDistMat(topEntries_2,1);
    prominentLevel3 = mergeDistMat(topEntries_3,1);
    storThresh(refImg,1) = prominentLevel1;
    storThresh(refImg,2) = prominentLevel2;
    storThresh(refImg,3) = prominentLevel3;
    %%
    
    indexOfPage = 0;
    componentIndex = 0;
    
    storCandidatePositionHolder = cell(size(storMatchingDistanceOfEachImg,1),1);
    
    for forEachImg = 1:(size(storMatchingDistanceOfEachImg,1))
        
        nonZeroDistVal = size(storMatchingDistanceOfEachImg{forEachImg,1},1);
        
        firstMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);
        secondMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);
        thirdMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);
        fourthMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);
        
        firstMostProbableCandidatesCounter = 1;
        secondMostProbableCandidatesCounter = 1;
        thirdMostProbableCandidatesCouter = 1;
        fourthMostProbableCandidatesCounter = 1;
        
        imageHavingComponent = 0; % checking whether this image having some relevant matche component or not
        candidatePositionHolder = cell(7,1);
        minDist = storMatchingDistanceOfEachImg{forEachImg,1}(end,1);
        imagePath = storPathOfEachImg{forEachImg,1};
        allRefImg = storRefImgForEachImg{forEachImg,1};
        for eachComp = 1:1:(size(storMatchingDistanceOfEachImg{forEachImg,1},1))
            
            distVal = storMatchingDistanceOfEachImg{forEachImg,1}(eachComp,1);
            
            Chk = eachComp;
            if(minDist > distVal)
                indexOfPage = forEachImg;
                componentIndex = eachComp;
            end
            minRow = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,1); % minimum row of the component
            maxRow = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,2); % maximum row of the component
            minCol = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,3); % minimum col of the component
            maxCol = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,4); % minimum col of the component
            
            if((0< distVal)&&(distVal <= prominentLevel1))
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,1) = minCol;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,2) = minRow;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,3) = maxCol;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,4) = maxRow;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,5) = distVal; % storing the distance value
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,6) = Chk; % storing the index to retrieve the warping path
                
                firstMostProbableCandidatesCounter = firstMostProbableCandidatesCounter +1;
                
                imageHavingComponent = 1;
            elseif ((prominentLevel1 < distVal)&&(distVal <= prominentLevel2)) % more prominent match
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,1) = minCol;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,2) = minRow;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,3) = maxCol;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,4) = maxRow;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,5) = distVal;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,6) = Chk;
                
                secondMostProbableCandidatesCounter = secondMostProbableCandidatesCounter +1;
                
                imageHavingComponent = 1;
            elseif ((prominentLevel2 < distVal)&& (distVal <= prominentLevel3)) % more prominent match
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,1) = minCol;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,2) = minRow;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,3) = maxCol;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,4) = maxRow;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,5) = distVal;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,6) = Chk;
                
                thirdMostProbableCandidatesCouter = thirdMostProbableCandidatesCouter +1;
                
                imageHavingComponent = 1;
            elseif (prominentLevel3 < distVal ) % more prominent match
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,1) = minCol;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,2) = minRow;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,3) = maxCol;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,4) = maxRow;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,5) = distVal;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,6) = Chk;
                
                fourthMostProbableCandidatesCounter = fourthMostProbableCandidatesCounter +1;
                
                imageHavingComponent = 1;
            else
                fprintf('Dont know why it cannot find any match \n ');
            end
        end
        
        
        if(firstMostProbableCandidatesCounter > 1)
            firstMostProbableCandidates = firstMostProbableCandidates((1:(firstMostProbableCandidatesCounter-1)),:);
        end
        if(secondMostProbableCandidatesCounter > 1)
            secondMostProbableCandidates = secondMostProbableCandidates((1:(secondMostProbableCandidatesCounter-1)),:);
        end
        if(thirdMostProbableCandidatesCouter > 1)
            thirdMostProbableCandidates = thirdMostProbableCandidates((1:(thirdMostProbableCandidatesCouter-1)),:);
        end
        if(fourthMostProbableCandidatesCounter > 1)
            fourthMostProbableCandidates = fourthMostProbableCandidates((1:(fourthMostProbableCandidatesCounter-1)),:);
        end
        if(imageHavingComponent == 1) % I think this IF loop will always be satisfied
            candidatePositionHolder{1,1} = firstMostProbableCandidates;
            candidatePositionHolder{1,2} = firstMostProbableCandidatesCounter;
            
            candidatePositionHolder{2,1} = secondMostProbableCandidates;
            candidatePositionHolder{2,2} = secondMostProbableCandidatesCounter;
            
            candidatePositionHolder{3,1} = thirdMostProbableCandidates;
            candidatePositionHolder{3,2} = thirdMostProbableCandidatesCouter;
            
            candidatePositionHolder{4,1} = fourthMostProbableCandidates;
            candidatePositionHolder{4,2} = fourthMostProbableCandidatesCounter;
            
            candidatePositionHolder{5,1} = storMatchingWarpingPathOfEachImg{forEachImg,1}; % for each image storing all the component's warping path
            candidatePositionHolder{6,1} = imagePath; % the path of the full image, whose component's info are stored
            candidatePositionHolder{7,1} = allRefImg;
            
            storCandidatePositionHolder{forEachImg,1} = candidatePositionHolder;
        end
        
    end
    if(imageHavingComponent == 1) % If we got match in the full image dataset then this flag will be on
        bestCandidate = zeros(1,4);
        bestCandidate(1,1) = storMatchingBoundaryOfEachImg{indexOfPage,1}{componentIndex,1}(1,3);
        bestCandidate(1,2) = storMatchingBoundaryOfEachImg{indexOfPage,1}{componentIndex,1}(1,1);
        bestCandidate(1,3) = storMatchingBoundaryOfEachImg{indexOfPage,1}{componentIndex,1}(1,4);
        bestCandidate(1,4) = storMatchingBoundaryOfEachImg{indexOfPage,1}{componentIndex,1}(1,2);
        bestImageMatchForRefImg = storPathOfEachImg{indexOfPage,1};
    end
    
    storMatchForEachRefImage{refImg,1} = storCandidatePositionHolder; % storing result for each reference image
    storMatchForEachRefImage{refImg,2} = bestCandidate;
    %     storMatchForEachRefImage{refImg,3} = realImageRef;
    storMatchForEachRefImage{refImg,4} = imageFilePathRef; % for creating the seperate folder of the referene image
    
    
    
    obtainedMatchingResultOfEachRefImg = storMatchForEachRefImage;
    clearvars -except obtainedMatchingResultOfEachRefImg dickDoom...
        eachImg bestImageMatchForRefImg imagePathProb refImg nImagesRef imgPathRef fileNamesRef storMatchForEachRefImage;
     
    nImages = size(obtainedMatchingResultOfEachRefImg,1);
    
    % for 1=1:nImages % for each reference image
    
    % Get referene image
    macPath = 'C:\Study Guru\STUDY GURU\Dataset\Dataset_1\Selected Img';
    imageMatchedForTheRefImg = size(obtainedMatchingResultOfEachRefImg{refImg,1},1);
    for j = 1:1:imageMatchedForTheRefImg % for each image in the image dataset for matching with the refernce image
        
        winPath = (obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{6,1});
        [~, winName, winExt] = fileparts(winPath);
        macPath_1 = [macPath winName winExt];
        fullImg = imread(macPath_1);
        if(size(fullImg,3)==3)
            fullImg = rgb2gray(fullImg);
        end
        fullImg = uint8(fullImg);
        [~, name, ~] = fileparts(obtainedMatchingResultOfEachRefImg{refImg,4}); % The path of the reference image
        pathstr = 'C:\Study Guru\STUDY GURU\Dataset\Dataset_1\';
        imageFiePath_1 = [pathstr 'result\'];
        imageFilePath_Full = [imageFiePath_1 name '\'];
        imageFilePath_2 = imageFilePath_Full;%[imageFiePath_1 name 'fullAnnotatedImages/']; % joining the image name with the folder path i.e.
        %     E:\STUDY GURU\Document Dewarping\Perspective_Version1.3\MVM_WordStringMatching\ImageName
        imageFilePath_3 = [imageFilePath_2 '1st TopMost\'];
        imageFilePath_4 = [imageFilePath_2 '2nd TopMost\'];
        imageFilePath_5 = [imageFilePath_2 '3rd TopMost\'];
        imageFilePath_6 = [imageFilePath_2 '4th TopMost\'];
        
        if((exist(imageFiePath_1,'dir'))==0)
            mkdir(imageFiePath_1);
        end
        
        if((exist(imageFilePath_2,'dir'))==0)
            mkdir(imageFilePath_2);
        end
        
        if((exist(imageFilePath_3,'dir'))==0)
            mkdir(imageFilePath_3);
        end
        if((exist(imageFilePath_4,'dir'))==0)
            mkdir(imageFilePath_4);
        end
        if((exist(imageFilePath_5,'dir'))==0)
            mkdir(imageFilePath_5);
        end
        if((exist(imageFilePath_6,'dir'))==0)
            mkdir(imageFilePath_6);
        end
        
        warpingPathOfAllComponentOfParticularImg = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{5,1};
        refinedRefImgForParticularCom =  obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{7,1};
        
        distanceText = strcat(imageFilePath_3,'distanceValue.txt');
        fid = fopen(distanceText, 'wt'); %open the file
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1},1))
                prominentLevel_1_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,1);
                prominentLevel_1_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,2);
                prominentLevel_1_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,3);
                prominentLevel_1_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,6);
                
                
                nColsComponent = (prominentLevel_1_Match_3 - prominentLevel_1_Match_1) +1;
                nRowsComponent = (prominentLevel_1_Match_4 - prominentLevel_1_Match_2) + 1;
                
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                [nRowsRef nColsRef] = size(ImageRef);
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
                end
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                    fullImg(prominentLevel_1_Match_2:(prominentLevel_1_Match_4),...
                    prominentLevel_1_Match_1:(prominentLevel_1_Match_3));
                
                
                mergedImg = mat2gray(stitchImage);
                %                 figure, imshow(mergedImg);
                %                 set(gcf,'Visible', 'on');
                %
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                % Drawing permanent rectangle box in the image for the component
                fullImg(prominentLevel_1_Match_2:prominentLevel_1_Match_4,prominentLevel_1_Match_1)=0;
                fullImg(prominentLevel_1_Match_4,prominentLevel_1_Match_1:prominentLevel_1_Match_3)=0;
                fullImg(prominentLevel_1_Match_2:prominentLevel_1_Match_4,prominentLevel_1_Match_3)=0;
                fullImg(prominentLevel_1_Match_2,prominentLevel_1_Match_1:prominentLevel_1_Match_3)=0;
                
                
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+8+5;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        if(mergedImgTestCol>mergedImgRefCol)
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        else
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        end
                        %                         line(X,Y);
                        %                         hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                
                
                
                %                 f = getframe(gcf);
                %                 imFrame = frame2im(f);
                                 str1 = int2str(m);
                
                imwrite(mergedImg,[imageFilePath_3,str1 '.jpg']);
                %                 hold off
                %                 close;
                fprintf(fid,'The Distance Value of %dth component is : %d \n',m,distValue); %write first value
                
                
                %   clear I;
            end
        end
        fclose(fid); %close the file
        
        distanceText = strcat(imageFilePath_4,'distanceValue.txt');
        fid = fopen(distanceText, 'wt'); %open the file
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1},1))
                prominentLevel_2_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,1);
                prominentLevel_2_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,2);
                prominentLevel_2_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,3);
                prominentLevel_2_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,6);
                
                nColsComponent = (prominentLevel_2_Match_3 - prominentLevel_2_Match_1) +1;
                nRowsComponent = (prominentLevel_2_Match_4 - prominentLevel_2_Match_2) + 1;
                
                
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                [nRowsRef nColsRef] = size(ImageRef);
                
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
                end
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                    fullImg((prominentLevel_2_Match_2:(prominentLevel_2_Match_4)),...
                    (prominentLevel_2_Match_1:(prominentLevel_2_Match_3)));
                
                
                mergedImg = mat2gray(stitchImage);
                %                 figure, imshow(mergedImg);
                %                 set(gcf,'Visible', 'on');
                
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                % Drawing permanent rectangle box in the image for the component
                fullImg(prominentLevel_2_Match_2:prominentLevel_2_Match_4,prominentLevel_2_Match_1)=0;
                fullImg(prominentLevel_2_Match_4,prominentLevel_2_Match_1:prominentLevel_2_Match_3)=0;
                fullImg(prominentLevel_2_Match_2:prominentLevel_2_Match_4,prominentLevel_2_Match_3)=0;
                fullImg(prominentLevel_2_Match_2,prominentLevel_2_Match_1:prominentLevel_2_Match_3)=0;
                
                
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+8+5;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        if(mergedImgTestCol>mergedImgRefCol)
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        else
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        end
                        %                         line(X,Y);
                        %                         hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                
                %                 f = getframe(gcf);
                %                 imFrame = frame2im(f);
                                 str1 = int2str(m);
                %
                imwrite(mergedImg,[imageFilePath_4,str1 '.jpg']);
                %                 hold off
                %                 close;
                fprintf(fid,'The Distance Value of %dth component is : %d \n',m,distValue); %write first value
                
            end
        end
        
        fclose(fid); %close the file
        distanceText = strcat(imageFilePath_5,'distanceValue.txt');
        fid = fopen(distanceText, 'wt'); %open the file
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1},1))
                prominentLevel_3_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,1);
                prominentLevel_3_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,2);
                prominentLevel_3_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,3);
                prominentLevel_3_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,6);
                
                nColsComponent = (prominentLevel_3_Match_3 - prominentLevel_3_Match_1) +1;
                nRowsComponent = (prominentLevel_3_Match_4 - prominentLevel_3_Match_2) + 1;
                if(refImg == 4)
                    disp('get me');
                end
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                [nRowsRef nColsRef] = size(ImageRef);
                
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
                end
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                    fullImg((prominentLevel_3_Match_2:(prominentLevel_3_Match_4)),...
                    (prominentLevel_3_Match_1:(prominentLevel_3_Match_3)));
                
                
                mergedImg = mat2gray(stitchImage);
                %                 figure, imshow(mergedImg);
                %                 set(gcf,'Visible', 'on');
                
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                %  Drawing permanent rectangle box in the image for the component
                fullImg(prominentLevel_3_Match_2:prominentLevel_3_Match_4,prominentLevel_3_Match_1)=0;
                fullImg(prominentLevel_3_Match_4,prominentLevel_3_Match_1:prominentLevel_3_Match_3)=0;
                fullImg(prominentLevel_3_Match_2:prominentLevel_3_Match_4,prominentLevel_3_Match_3)=0;
                fullImg(prominentLevel_3_Match_2,prominentLevel_3_Match_1:prominentLevel_3_Match_3)=0;
                
                
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+8+5;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        if(mergedImgTestCol>mergedImgRefCol)
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        else
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        end
                        %                         line(X,Y);
                        %                         hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                
                %                 f = getframe(gcf);
                %                 imFrame = frame2im(f);
                                 str1 = int2str(m);
                
                imwrite(mergedImg,[imageFilePath_5,str1 '.jpg']);
                %                 hold off
                %                 close;
                %                 fprintf(fid,'The Distance Value of %dth component is : %d \n',m,distValue); %write first value
                %
                
                %   clear I;
            end
        end
        
        
        fclose(fid); %close the file
        distanceText = strcat(imageFilePath_6,'distanceValue.txt');
        fid = fopen(distanceText, 'wt'); %open the file
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1},1))
                prominentLevel_4_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,1);
                prominentLevel_4_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,2);
                prominentLevel_4_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,3);
                prominentLevel_4_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,6);
                
                nColsComponent = (prominentLevel_4_Match_3 - prominentLevel_4_Match_1) +1;
                nRowsComponent = (prominentLevel_4_Match_4 - prominentLevel_4_Match_2) + 1;
                
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                [nRowsRef nColsRef] = size(ImageRef);
                
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
                end
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                    fullImg((prominentLevel_4_Match_2:(prominentLevel_4_Match_4)),...
                    (prominentLevel_4_Match_1:(prominentLevel_4_Match_3)));
                
                
                mergedImg = mat2gray(stitchImage);
                %                 figure, imshow(mergedImg);
                %                 set(gcf,'Visible', 'on');
                %
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                %               Drawing permanent rectangle box in the image for the component
                fullImg(prominentLevel_4_Match_2:prominentLevel_4_Match_4,prominentLevel_4_Match_1)=0;
                fullImg(prominentLevel_4_Match_4,prominentLevel_4_Match_1:prominentLevel_4_Match_3)=0;
                fullImg(prominentLevel_4_Match_2:prominentLevel_4_Match_4,prominentLevel_4_Match_3)=0;
                fullImg(prominentLevel_4_Match_2,prominentLevel_4_Match_1:prominentLevel_4_Match_3)=0;
                
                
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+8+5;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        if(mergedImgTestCol>mergedImgRefCol)
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        else
                            mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        end
                        %                         line(X,Y);
                        %                         hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                
                %
                %                 f = getframe(gcf);
                %                 imFrame = frame2im(f);
                                 str1 = int2str(m);
                
                imwrite(mergedImg,[imageFilePath_6,str1 '.jpg']);
                %                 hold off
                %                 close;
                fprintf(fid,'The Distance Value of %dth component is : %d \n',m,distValue); %write first value
                
            end
        end
        fclose(fid); %close the file
        newStr = int2str(j);
        imwrite(fullImg,[imageFilePath_2, 'FULL_IMAGE',newStr,'.jpg']);
    end
    
    bestMatchVal1 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,1);
    bestMatchVal2 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,2);
    bestMatchVal3 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,3);
    bestMatchVal4 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,4);
    imagePathBest = bestImageMatchForRefImg;%obtainedMatchingResultOfEachRefImg{i,1}{2,1}(1,5);
    
    [~, winNameBest, winExtBest] = fileparts(imagePathBest);
    macPath_2 = [macPath winNameBest winExtBest];
    
    
    bestMatchedImg = imread(macPath_2);
    
    if(size(bestMatchedImg,3)==3)
        bestMatchedImg = rgb2gray(bestMatchedImg);
    end
    
    bestMatchedImg = uint8(bestMatchedImg);
    bestMatchedImg(bestMatchVal2:bestMatchVal4,bestMatchVal1)=0;
    bestMatchedImg(bestMatchVal4,bestMatchVal1:bestMatchVal3)=0;
    bestMatchedImg(bestMatchVal2:bestMatchVal4,bestMatchVal3)=0;
    bestMatchedImg(bestMatchVal2,bestMatchVal1:bestMatchVal3)=0;
    if((exist(imageFilePath_Full,'dir'))==0)
        mkdir(imageFilePath_Full);
    end
    imwrite(bestMatchedImg,[imageFilePath_Full, 'FULL_IMAGE','.jpg']);
    progressbar(refImg/nImagesRef)
end
% matlabpool close;
save storThresh;
toc;



