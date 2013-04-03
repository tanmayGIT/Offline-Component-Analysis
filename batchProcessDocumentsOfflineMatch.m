function[storMatchForEachRefImage] = batchProcessDocumentsOfflineMatch()

load('segmentedDocImageSequence.mat');
load('imagePath.mat');


dirOutputRefImg = uigetdir('/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/Dataset_1/','Select Folder for Reference Image Dateset');
filesRef = dir(fullfile(dirOutputRefImg, '*.jpg'));
fileNamesRef = {filesRef.name}';
imgPathRef = strcat(dirOutputRefImg,'/');
nImagesRef = (length(fileNamesRef));


storMatchForEachRefImage = cell(nImagesRef,4); % storing match for each reference Image;

for refImg = 1:1:nImagesRef
    imageFilePathRef = [imgPathRef,fileNamesRef{refImg}];
    ImgRef = imread(imageFilePathRef);
    if(size(ImgRef,3)==3)
        ImgRef = rgb2gray(ImgRef);
    end
    
    ImgRef = uint8(ImgRef);
    
    [beforeRLSARef,afterRLSARef] = wordSpottingBasicOperationRef(ImgRef); % for reference image
    
    % Normalize each feature in right manner so that the feature matrix
    % should not have any influence on height of component
    
    
    %     refComponentMat = AnalyzeComponentRefWordForWordLevel(beforeRLSARef,afterRLSARef,ImgRef);
    %     refComponentSize = (size(refComponentMat{1,2},2));
    %     refMatForMatch = (refComponentMat{1,3}); % getting the number of columns of the image
    %     realIndexRef = (refComponentMat{1,4});
    
    
    
    
    
    realImageRef = ImgRef((refComponentMat{1,1}(1,3)):(refComponentMat{1,1}(3,3)),(refComponentMat{1,1}(1,4)):(refComponentMat{1,1}(4,4)));
    
    
    
    
    
    storMatchingDistanceOfEachImg = cell((size(segmentedDocImageSequence,1)),1); % equal to the number of image for testing
    storMatchingPathOfEachImg = cell((size(segmentedDocImageSequence,1)),1);
    storMatchingBoundaryOfEachImg = cell((size(segmentedDocImageSequence,1)),1);
    
    for eachImg = 1:(size(segmentedDocImageSequence,1))
        
        [~,~,segmentedDocImageSequenceRefined] = find(segmentedDocImageSequence{eachImg,1}{1,1}); % the first cell in each image contains the
        
        storWarpingPathOfComponents = zeros((size(segmentedDocImageSequenceRefined,1)),1); % doing for each component in the image
        storDistancesOfComponents = zeros((size(segmentedDocImageSequenceRefined,1)),1); % doing for each component in the image
        averageHght = segmentedDocImageSequence{eachImg,1}{1,6}; % average height of the image
        
        refComponentMat = AnalyzeComponentRefWordForWordLevel(beforeRLSARef,afterRLSARef,ImgRef,averageHght);
        refComponentSize = (size(refComponentMat{1,2},2));
        refMatForMatch = (refComponentMat{1,3}); % getting the number of columns of the image
        realIndexRef = (refComponentMat{1,4});
       
        parfor eachRelevantComp = 1:(size(segmentedDocImageSequenceRefined,1)) % for all the no. component having in the image
            if(~(isempty(segmentedDocImageSequenceRefined{eachRelevantComp,1})))
                testMat = (segmentedDocImageSequenceRefined{eachRelevantComp,1});
                
                if((refComponentSize/4) <= (size(testMat,1))) % If the size of the word is more than the reference word
                    realIndexTest = segmentedDocImageSequence{eachImg,1}{1,5}; % the real index is stored in the 5th cell
                    [~,distVal,getIndexes] = stringMatchingWithMVM(refMatForMatch,testMat,realIndexRef,realIndexTest);
                    storWarpingPathOfComponents{eachRelevantComp,1} = getIndexes;
                    storDistancesOfComponents(eachRelevantComp,1) = distVal;
                end
                
            end
            
        end
        [indexWrapPath,~,nonZeroWarpingPathOfComponents] = find(storWarpingPathOfComponents);
        [~,~,nonZeroDistancesOfComponents] = find(storDistancesOfComponents);
        [~,~,refinedSegmentedDocImageSequence] = find(segmentedDocImageSequence{eachImg,1}{1,3});
        
        storMatchingDistanceOfEachImg{eachImg,1} =  nonZeroDistancesOfComponents;
        storMatchingPathOfEachImg{eachImg,1} = nonZeroWarpingPathOfComponents;
        storMatchingBoundaryOfEachImg{eachImg,1} = (refinedSegmentedDocImageSequence{indexWrapPath,1});
        
    end
    
    
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
    meanDistVal = nanmedian(mergeDistMat);
    prominentLevel1 = ((meanDistVal*33.3333)/100);
    prominentLevel2 = ((meanDistVal*(33.3333+33.3333))/100);
    prominentLevel3 = meanDistVal;
    %%
    minDist = 0;
    indexOfPage = 0;
    componentIndex = 0;
    
    storCandidatePositionHolder = zeros(size(storMatchingDistanceOfEachImg,1),1);
    
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
        candidatePositionHolder = cell{6,1};
        for eachComp = 1:1:(size(storMatchingDistanceOfEachImg{forEachImg,1},1))
            
            distVal = storMatchingDistanceOfEachImg{forEachImg,1}(eachComp,1);
            
            Chk = eachComp;
            if(minDist > distVal)
                indexOfPage = indeachImg;
                componentIndex = eachComp;
            end
            minRow = storMatchingBoundaryOfEachImg{forEachImg,1}(1,1); % minimum row of the component
            maxRow = storMatchingBoundaryOfEachImg{forEachImg,1}(1,2); % maximum row of the component
            minCol = storMatchingBoundaryOfEachImg{forEachImg,1}(1,3); % minimum col of the component
            maxCol = storMatchingBoundaryOfEachImg{forEachImg,1}(1,4); % minimum col of the component
            imagePath = storMatchingPathOfEachImg{forEachImg,1};
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
            
            candidatePositionHolder{5,1} = storMatchingPathOfEachImg;
            candidatePositionHolder{6,1} = imagePath;
            
            
            storCandidatePositionHolder{forEachImg,1} = candidatePositionHolder;
        end
        
    end
    if(imageHavingComponent == 1) % If we got match in the full image dataset then this flag will be on
        bestCandidate = zero(1,5);
        bestCandidate(1,1) = storMatchingBoundaryOfEachImg{indexOfPage,1}(componentIndex,3);
        bestCandidate(1,2) = storMatchingBoundaryOfEachImg{indexOfPage,1}(componentIndex,1);
        bestCandidate(1,3) = storMatchingBoundaryOfEachImg{indexOfPage,1}(componentIndex,4);
        bestCandidate(1,4) = storMatchingBoundaryOfEachImg{indexOfPage,1}(componentIndex,2);
        bestCandidate(1,5) = storMatchingPathOfEachImg{indexOfPage,1};
    end
    
    storMatchForEachRefImage{refImg,1} = storCandidatePositionHolder; % storing result for each reference image
    storMatchForEachRefImage{refImg,2} = bestCandidate;
    storMatchForEachRefImage{refImg,3} = realImageRef;
    storMatchForEachRefImage{refImg,4} = imageFilePathRef; % for creating the seperate folder of the referene image
    
end

return;
end