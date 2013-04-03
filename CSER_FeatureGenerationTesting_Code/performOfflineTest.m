%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function Name : Word Spotting                                          %
%  Author : Tanmay                                                        %
%  Date : 08/09/2012                                                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function performOfflineTest(ImgRef,imageFilePathRef)

global dividedFeatureMat;
global dividedPathMat;


imagePathProb = dividedPathMat;
segmentedDocImageSequence = dividedFeatureMat;
nImagesRef = 1;

storMatchForEachRefImage = cell(nImagesRef,1); % storing match for each reference Image;
dickDoom = cell((size(segmentedDocImageSequence,1)),1);%cell(2,1);
cntdd = 1;
for jick = 1:1:(size(segmentedDocImageSequence,1))
    dickDoom{cntdd,1} = segmentedDocImageSequence{jick,1};
    cntdd = cntdd +1;
end

% bestImageMatchForRefImg = cell(nImagesRef,1);
progressbar(0,0,0) % Init 3 bars
% clearvars -except dickDoom imagePathProb storMatchForEachRefImage fileNamesRef imgPathRef nImagesRef
storThresh = zeros(nImagesRef,3);
for refImg = 1:1:nImagesRef
    
    
    
    
    
    
    storMatchingDistanceOfEachImg = cell((size(dickDoom,1)),1); % equal to the number of image for testing
    storMatchingWarpingPathOfEachImg = cell((size(dickDoom,1)),1);
    storMatchingBoundaryOfEachImg = cell((size(dickDoom,1)),1);
    storLimitsOfEachComEachImg = cell((size(dickDoom,1)),1);
    storRefImgForEachImg = cell((size(dickDoom,1)),1);
    storPathOfEachImg = cell((size(dickDoom,1)),1);
    %**************
    progressbar([],[],0) % Reset 2nd bar
    sz_11 = size(dickDoom,1);
    nComponent = 0;
    nComponent1 = 0;
    for eachImg = 1:size(dickDoom,1)
        
        %         horiRLSAThresh = (dickDoom{eachImg,1}{1,7});
        %         verRLSAThresh = (dickDoom{eachImg,1}{1,8});
        %         [beforeRLSARef,afterRLSARef] = wordSpottingBasicOperationRef(ImgRef,horiRLSAThresh,verRLSAThresh); % for reference image
        [beforeRLSARef] = wordSpottingBasicOperationRefNoRLSA(ImgRef); % for reference image
        
        [~,~,componentsFeatureMatrixRefined] = findApplicableForCell(dickDoom{eachImg,1}{1,4}); % the orogonal feature mat
        [~,~,segmentedWarpingPathRefined] = findApplicableForCell(dickDoom{eachImg,1}{1,5});
        [~,~,segmentedDocImageSequenceBoundaryRefined] = findApplicableForCell(dickDoom{eachImg,1}{1,3}); % store the boundary of each component
        [~,~,segmentedDocImageAccumulatedCell] = findApplicableForCell(dickDoom{eachImg,1}{1,9});
        
        
        storDistancesOfComponents = zeros((size(componentsFeatureMatrixRefined,1)),1); % doing for each component in the image
        storWarpingPathOfComponents = cell((size(segmentedWarpingPathRefined,1)),1); % doing for each component in the image
        storBoundaryOfComponents = cell((size(segmentedDocImageSequenceBoundaryRefined,1)),1);
        storLimitsOfComponents = cell((size(segmentedDocImageAccumulatedCell,1)),1); % storing the ascender and descender line
        storRefImgForEachCompoent = cell((size(segmentedDocImageSequenceBoundaryRefined,1)),1);
        
        averageChHghtInPage = dickDoom{eachImg,1}{1,6}; % average height of the image, so this will be a single value always
        
        
        % TAKING THE NORMAL FEATURE MATRIX NOT THE PRINCIPAL COMPONENT MATRIX
        
        % avgCharHght =  the average height of the characters in the
        % compponent image
        %         disp('for image:');
        %         disp(eachImg);
        progressbar([],0)
        sz_12 = (size(componentsFeatureMatrixRefined,1));
        [l1Ref,l4Ref,topLineRef,baseLineRef,componentRefImg,ImgRef] = mainBasicFuncForRef(beforeRLSARef,ImgRef);
        
        parfor eachRelevantComp = 1:(size(componentsFeatureMatrixRefined,1)) % for all the no. component having in the image
            %             disp(eachRelevantComp);
            %             if(eachRelevantComp == 40)
            %                 disp('I waana to see u');
            %             end
            %             disp(eachRelevantComp);
            %             if(eachImg == 4)&& (eachRelevantComp == 27)
            %                 disp('wanna see u');
            %             end
            nComponent1 = nComponent1 +1;
            if(~(isempty(componentsFeatureMatrixRefined{eachRelevantComp,1})))
                testMat = (componentsFeatureMatrixRefined{eachRelevantComp,1});
                
                componentHght = ((segmentedDocImageSequenceBoundaryRefined{eachRelevantComp,1}(1,2)) - ...
                    (segmentedDocImageSequenceBoundaryRefined{eachRelevantComp,1}(1,1)))+1;
                accumulatedBoundary = segmentedDocImageAccumulatedCell{eachRelevantComp,1};
                % resizing each ref image w.r.t the component image height
                if(componentHght > 0)
                    
                    refComponentMat = AnalyzeRefWord(l1Ref,l4Ref,topLineRef,baseLineRef,componentRefImg,ImgRef,accumulatedBoundary);
                    
                    refComponentSize = (size(refComponentMat{1,2},2)); % getting number of col in ref component img
                    refMatForMatch = (refComponentMat{1,3}); % getting the number of columns of the image
                    realIndexRef = (refComponentMat{1,4});
                    
                    %                 realImageRef = ImgRef((refComponentMat{1,1}(1,3)):(refComponentMat{1,1}(3,3)),(refComponentMat{1,1}(1,4)):(refComponentMat{1,1}(4,4)));
                    
                    
                    
                    
                    if((ceil(refComponentSize*(3/4))) <= (size(testMat,1))) % If the size of the word is more than the reference word
                        realIndexTest = segmentedWarpingPathRefined{eachRelevantComp,1}; % the real index is stored in the 5th cell
                        [~,distVal,getIndexes] = stringMatchingWithMVM(refMatForMatch,testMat,realIndexRef,realIndexTest);
                        storWarpingPathOfComponents{eachRelevantComp,1} = getIndexes;
                        storDistancesOfComponents(eachRelevantComp,1) = distVal;
                        storRefImgForEachCompoent{eachRelevantComp,1} = refComponentMat{1,2};%keeping the componentn image
                        storBoundaryOfComponents{eachRelevantComp,1} = segmentedDocImageSequenceBoundaryRefined{eachRelevantComp,1};
                        storLimitsOfComponents{eachRelevantComp,1} = accumulatedBoundary;
                        nComponent = nComponent+1;
                    end
                end
            end
            progressbar([],eachRelevantComp/sz_12) % Update 3rd bar
        end
        
        clearvars -except storMatchingDistanceOfEachImg storWarpingPathOfComponents storDistancesOfComponents...
            storRefImgForEachCompoent storBoundaryOfComponents dickDoom imageFilePathRef...
            storRefImgForEachImg storPathOfEachImg storMatchingWarpingPathOfEachImg storMatchingBoundaryOfEachImg...
            eachImg storDistancesOfComponents storRefImgForEachCompoent storBoundaryOfComponents imagePathProb sz_11...
            beforeRLSARef afterRLSARef  ImgRef refImg nImagesRef storMatchForEachRefImage nComponent nComponent1 storLimitsOfComponents storLimitsOfEachComEachImg;
        
        %         storWarpingPathOfComponents will contain all the warping path of
        %         all the component in the every image
        [~,~,nonZeroWarpingPathOfComponents] = findApplicableForCell(storWarpingPathOfComponents); % warping path
        [~,~,nonZeroDistancesOfComponents] = find(storDistancesOfComponents); % store distance
        [~,~,nonZeroRefImgForEachCompoent] = findApplicableForCell(storRefImgForEachCompoent); % store distance
        [~,~,nonZeroBoundaryOfComponents] = findApplicableForCell(storBoundaryOfComponents); % boundary of the component in image
        [~,~,nonZeroLimitsOfComponents] = findApplicableForCell(storLimitsOfComponents); % storing non zero limits of component
        
        storMatchingDistanceOfEachImg{eachImg,1} =  nonZeroDistancesOfComponents;
        storMatchingWarpingPathOfEachImg{eachImg,1} = nonZeroWarpingPathOfComponents;
        storMatchingBoundaryOfEachImg{eachImg,1} = nonZeroBoundaryOfComponents;
        storLimitsOfEachComEachImg{eachImg,1} = nonZeroLimitsOfComponents;
        storRefImgForEachImg{eachImg,1} = nonZeroRefImgForEachCompoent;
        storPathOfEachImg{eachImg,1} = imagePathProb{eachImg,1};
        progressbar([],[],eachImg/sz_11)
    end
    disp('Ohhhh dear good component');
    disp(nComponent);
    disp('Ohhhh dear bad component');
    disp(nComponent1);
    %     [~,~,storMatchingDistanceOfEachImg] = findApplicableForCell(storMatchingDistanceOfEachImg);
    %     [~,~,storMatchingWarpingPathOfEachImg] = findApplicableForCell(storMatchingWarpingPathOfEachImg);
    %     [~,~,storMatchingBoundaryOfEachImg] = findApplicableForCell(storMatchingBoundaryOfEachImg);
    [~,~,storPathOfEachImg] = findApplicableForCell(storPathOfEachImg);
    
    clearvars -except storMatchingDistanceOfEachImg storMatchingWarpingPathOfEachImg storMatchingBoundaryOfEachImg...
        storRefImgForEachImg storPathOfEachImg dickDoom imageFilePathRef storLimitsOfEachComEachImg eachImg imagePathProb refImg nImagesRef storMatchForEachRefImage;
    
    
    
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
    getBestFlag = 0;
    storCandidatePositionHolder = cell(size(storMatchingDistanceOfEachImg,1),1);
    totalFirstMostProbableCandidatesCounter = 0;
    totalSecondMostProbableCandidatesCounter = 0;
    totalThirdMostProbableCandidatesCounter = 0;
    totalFourthMostProbableCandidatesCounter = 0;
    for forEachImg = 1:(size(storMatchingDistanceOfEachImg,1))
        
        nonZeroDistVal = size(storMatchingDistanceOfEachImg{forEachImg,1},1);
        
        firstMostProbableCandidates = zeros(nonZeroDistVal,10);
        secondMostProbableCandidates = zeros(nonZeroDistVal,10);
        thirdMostProbableCandidates = zeros(nonZeroDistVal,10);
        fourthMostProbableCandidates = zeros(nonZeroDistVal,10);
        
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
                getBestFlag = 1;
            end
            minRow = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,1); % minimum row of the component
            maxRow = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,2); % maximum row of the component
            minCol = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,3); % minimum col of the component
            maxCol = storMatchingBoundaryOfEachImg{forEachImg,1}{eachComp,1}(1,4); % minimum col of the component
            l1 = storLimitsOfEachComEachImg{forEachImg,1}{eachComp,1}(1,1);
            l4 = storLimitsOfEachComEachImg{forEachImg,1}{eachComp,1}(1,2);
            topLine = storLimitsOfEachComEachImg{forEachImg,1}{eachComp,1}(1,3);
            botLine = storLimitsOfEachComEachImg{forEachImg,1}{eachComp,1}(1,4);
            
            if((0< distVal)&&(distVal <= prominentLevel1))
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,1) = minCol;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,2) = minRow;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,3) = maxCol;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,4) = maxRow;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,5) = distVal; % storing the distance value
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,6) = Chk; % storing the index to retrieve the warping path
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,7) = l1;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,8) = l4;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,9) = topLine;
                firstMostProbableCandidates(firstMostProbableCandidatesCounter,10) = botLine;
                firstMostProbableCandidatesCounter = firstMostProbableCandidatesCounter +1;
                
                imageHavingComponent = 1;
            elseif ((prominentLevel1 < distVal)&&(distVal <= prominentLevel2)) % more prominent match
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,1) = minCol;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,2) = minRow;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,3) = maxCol;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,4) = maxRow;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,5) = distVal;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,6) = Chk;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,7) = l1;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,8) = l4;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,9) = topLine;
                secondMostProbableCandidates(secondMostProbableCandidatesCounter,10)= botLine;
                secondMostProbableCandidatesCounter = secondMostProbableCandidatesCounter +1;
                
                imageHavingComponent = 1;
            elseif ((prominentLevel2 < distVal)&& (distVal <= prominentLevel3)) % more prominent match
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,1) = minCol;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,2) = minRow;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,3) = maxCol;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,4) = maxRow;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,5) = distVal;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,6) = Chk;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,7) = l1;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,8) = l4;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,9) = topLine;
                thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,10) = botLine;
                thirdMostProbableCandidatesCouter = thirdMostProbableCandidatesCouter +1;
                
                imageHavingComponent = 1;
            elseif (prominentLevel3 < distVal ) % more prominent match
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,1) = minCol;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,2) = minRow;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,3) = maxCol;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,4) = maxRow;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,5) = distVal;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,6) = Chk;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,7) = l1;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,8) = l4;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,9) = topLine;
                fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,10) = botLine;
                fourthMostProbableCandidatesCounter = fourthMostProbableCandidatesCounter +1;
                
                imageHavingComponent = 1;
            else
                fprintf('Dont know why it cannot find any match \n ');
            end
        end
        
        
        if(firstMostProbableCandidatesCounter > 1)
            firstMostProbableCandidates = firstMostProbableCandidates((1:(firstMostProbableCandidatesCounter-1)),:);
            sortedFirstMostProbableCandidates = zeros(size(firstMostProbableCandidates,1),size(firstMostProbableCandidates,2));
            allFirstDist = firstMostProbableCandidates(:,5);
            [~,indexFirst] = sort(allFirstDist);
            for s = 1:1:size(indexFirst,1)
                getIndex = indexFirst(s,1);
                sortedFirstMostProbableCandidates(s,:) = firstMostProbableCandidates(getIndex,:);
            end
        end
        if(secondMostProbableCandidatesCounter > 1)
            secondMostProbableCandidates = secondMostProbableCandidates((1:(secondMostProbableCandidatesCounter-1)),:);
            sortedSecondMostProbableCandidates = zeros(size(secondMostProbableCandidates,1),size(secondMostProbableCandidates,2));
            allSecondDist = secondMostProbableCandidates(:,5);
            [~,indexSecond] = sort(allSecondDist);
            for s = 1:1:size(indexSecond,1)
                getIndex = indexSecond(s,1);
                sortedSecondMostProbableCandidates(s,:) = secondMostProbableCandidates(getIndex,:);
            end
        end
        if(thirdMostProbableCandidatesCouter > 1)
            thirdMostProbableCandidates = thirdMostProbableCandidates((1:(thirdMostProbableCandidatesCouter-1)),:);
            sortedThirdMostProbableCandidates = zeros(size(thirdMostProbableCandidates,1),size(thirdMostProbableCandidates,2));
            allThirdDist = thirdMostProbableCandidates(:,5);
            [~,indexThird] = sort(allThirdDist,1);
            for s = 1:1:size(indexThird)
                getIndex = indexThird(s,1);
                sortedThirdMostProbableCandidates(s,:) = thirdMostProbableCandidates(getIndex,:);
            end
        end
        if(fourthMostProbableCandidatesCounter > 1)
            fourthMostProbableCandidates = fourthMostProbableCandidates((1:(fourthMostProbableCandidatesCounter-1)),:);
            sortedFourthMostProbableCandidates = zeros(size(fourthMostProbableCandidates,1),size(fourthMostProbableCandidates,2));
            allFourthDist = fourthMostProbableCandidates(:,5);
            [~,indexFourth] = sort(allFourthDist,1);
            for s = 1:1:size(indexFourth)
                getIndex = indexFourth(s,1);
                sortedFourthMostProbableCandidates(s,:) = fourthMostProbableCandidates(getIndex,:);
            end
        end
        
        %         if(forEachImg == 15)
        %             disp('I want to see you');
        %         end
        if(imageHavingComponent == 1) % I think this IF loop will always be satisfied
            if(firstMostProbableCandidatesCounter > 1)
                candidatePositionHolder{1,1} = sortedFirstMostProbableCandidates;
                candidatePositionHolder{1,2} = firstMostProbableCandidatesCounter-1;
            else
                candidatePositionHolder{1,1} = 0;
                candidatePositionHolder{1,2} = 0;
            end
            if(secondMostProbableCandidatesCounter > 1)
                candidatePositionHolder{2,1} = sortedSecondMostProbableCandidates;
                candidatePositionHolder{2,2} = secondMostProbableCandidatesCounter-1;
            else
                candidatePositionHolder{2,1} = 0;
                candidatePositionHolder{2,2} = 0;
            end
            if(thirdMostProbableCandidatesCouter > 1)
                candidatePositionHolder{3,1} = sortedThirdMostProbableCandidates;
                candidatePositionHolder{3,2} = thirdMostProbableCandidatesCouter-1;
            else
                candidatePositionHolder{3,1} = 0;
                candidatePositionHolder{3,2} = 0;
            end
            if(fourthMostProbableCandidatesCounter > 1)
                candidatePositionHolder{4,1} = sortedFourthMostProbableCandidates;
                candidatePositionHolder{4,2} = fourthMostProbableCandidatesCounter-1;
            else
                candidatePositionHolder{4,1} = 0;
                candidatePositionHolder{4,2} = 0;
            end
            
            candidatePositionHolder{5,1} = storMatchingWarpingPathOfEachImg{forEachImg,1}; % for each image storing all the component's warping path
            candidatePositionHolder{6,1} = imagePath; % the path of the full image, whose component's info are stored
            candidatePositionHolder{7,1} = allRefImg;
            
            storCandidatePositionHolder{forEachImg,1} = candidatePositionHolder;
            
            totalFirstMostProbableCandidatesCounter = totalFirstMostProbableCandidatesCounter + (firstMostProbableCandidatesCounter-1);
            totalSecondMostProbableCandidatesCounter = totalSecondMostProbableCandidatesCounter + (secondMostProbableCandidatesCounter-1);
            totalThirdMostProbableCandidatesCounter = totalThirdMostProbableCandidatesCounter + (thirdMostProbableCandidatesCouter-1);
            totalFourthMostProbableCandidatesCounter = totalFourthMostProbableCandidatesCounter + (fourthMostProbableCandidatesCounter-1);
        end
        
    end
    if(imageHavingComponent == 1) % If we got match in the full image dataset then this flag will be on
        bestCandidate = zeros(1,4);
        if(getBestFlag == 0)
            indexOfPage = 1;
            componentIndex = 1;
        end
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
        eachImg bestImageMatchForRefImg imagePathProb refImg nImagesRef storMatchForEachRefImage totalFirstMostProbableCandidatesCounter...
        totalSecondMostProbableCandidatesCounter totalThirdMostProbableCandidatesCounter...
        totalFourthMostProbableCandidatesCounter;
    
    %     nImages = size(obtainedMatchingResultOfEachRefImg,1);
    
    % for 1=1:nImages % for each reference image
    
    % Get referene image
    %     macPath = 'C:\Study Guru\STUDY GURU\Dataset\Dataset_1\Selected Img';
    imageMatchedForTheRefImg = size(obtainedMatchingResultOfEachRefImg{refImg,1},1);
    
    [~, name, ~] = fileparts(obtainedMatchingResultOfEachRefImg{refImg,4}); % The path of the reference image
    pathstr = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/dickDoom/';
    imageFiePath_1 = [pathstr 'Matching Result/'];
    imageFilePath_Full = [imageFiePath_1 name '/'];
    imageFilePath_2 = imageFilePath_Full;%[imageFiePath_1 name 'fullAnnotatedImages/']; % joining the image name with the folder path i.e.
    %     E:\STUDY GURU\Document Dewarping\Perspective_Version1.3\MVM_WordStringMatching\ImageName
    imageFilePath_3 = [imageFilePath_2 '1st TopMost/'];
    imageFilePath_4 = [imageFilePath_2 '2nd TopMost/'];
    imageFilePath_5 = [imageFilePath_2 '3rd TopMost/'];
    imageFilePath_6 = [imageFilePath_2 '4th TopMost/'];
    
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
    
    
    distanceText1 = strcat(imageFilePath_3,'distanceValue.txt');
    fid1 = fopen(distanceText1, 'wt'); %open the file
    
    distanceText2 = strcat(imageFilePath_4,'distanceValue.txt');
    fid2 = fopen(distanceText2, 'wt'); %open the file
    
    distanceText3 = strcat(imageFilePath_5,'distanceValue.txt');
    fid3 = fopen(distanceText3, 'wt'); %open the file
    
    distanceText4 = strcat(imageFilePath_6,'distanceValue.txt');
    fid4 = fopen(distanceText4, 'wt'); %open the file
    m1 = 1;
    m2 = 1;
    m3 = 1;
    m4 = 1;
    
    
    firstDis = zeros(totalFirstMostProbableCandidatesCounter,1);
    secondDis = zeros(totalSecondMostProbableCandidatesCounter,1);
    thirdDis = zeros(totalThirdMostProbableCandidatesCounter,1);
    fourthDis = zeros(totalFourthMostProbableCandidatesCounter,1);
    
    for j = 1:1:imageMatchedForTheRefImg % for each image in the image dataset for matching with the refernce image
        winPath = (obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{6,1});
        %         disp('I am j');
        %         disp(j);
        fullImg = imread(winPath);
        if(size(fullImg,3)==3)
            fullImg = rgb2gray(fullImg);
        end
        fullImg = uint8(fullImg);
        fullImgCopy = fullImg;
        warpingPathOfAllComponentOfParticularImg = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{5,1};
        refinedRefImgForParticularCom =  obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{7,1};
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1},1))
                
                %                 disp('I am m');
                %                 disp(m);
                prominentLevel_1_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,1);
                prominentLevel_1_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,2);
                prominentLevel_1_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,3);
                prominentLevel_1_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,6);
                
                l1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,7);
                l4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,8);
                topLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,9);
                botLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{1,1}(m,10);
                
                croppedComponent = fullImg(prominentLevel_1_Match_2:(prominentLevel_1_Match_4),...
                    prominentLevel_1_Match_1:(prominentLevel_1_Match_3));
                croppedComponent = DrawColorLine(croppedComponent,l1,l4,topLine,botLine);

               
               [nRowsComponent  nColsComponent] = size(croppedComponent);
               
%                 nRowsComponent = nRowsComponent + 1;
%                 nColsComponent = nColsComponent + 1;
                
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                
                if(size(ImageRef,3)==3)
                    ImageRef = rgb2gray(ImageRef);
                end
                
                [nRowsRef nColsRef] = size(ImageRef);
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
                end
                stitchImage(3:4,5:nColsRef+4) = 255;
                stitchImage((nRowsRef+5):(nRowsRef+6),5:nColsRef+4) = 255;
                stitchImage((nRowsRef+80+3):(nRowsRef+80+4),5:nColsComponent+4) = 255;
                stitchImage((nRowsRef+4+80+nRowsComponent+1):(nRowsRef+4+80+nRowsComponent+2),5:nColsComponent+4) = 255;
                
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = croppedComponent;
                    
                
                
                mergedImg = mat2gray(stitchImage);
                figure, imshow(mergedImg);
                set(gcf,'Visible', 'on');
                
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))  % check if nCols in both image are same or not
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5+3;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+80+5-3;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        %                         if(mergedImgTestCol>mergedImgRefCol)
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        %                         else
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        %                         end
                        line(X,Y);
                        hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                
                pause(0.2);
                f = getframe(gcf);
                pause(0.2);
                imFrame = frame2im(f);
                str1 = int2str(m1);
                
                imwrite(imFrame,[imageFilePath_3,str1 '.jpg']);
                hold off
                close;
                firstDis(m1,1) = distValue;
                fprintf(fid1,'The Distance Value of %d component is : %d \n',m1,distValue); %write first value
                m1 = m1+1;
                
                % Drawing permanent rectangle box in the image for the component
                fullImgCopy(prominentLevel_1_Match_2:prominentLevel_1_Match_4,prominentLevel_1_Match_1)=0;
                fullImgCopy(prominentLevel_1_Match_4,prominentLevel_1_Match_1:prominentLevel_1_Match_3)=0;
                fullImgCopy(prominentLevel_1_Match_2:prominentLevel_1_Match_4,prominentLevel_1_Match_3)=0;
                fullImgCopy(prominentLevel_1_Match_2,prominentLevel_1_Match_1:prominentLevel_1_Match_3)=0;
                
                %   clear I;
            end
        end
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1},1))
                prominentLevel_2_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,1);
                prominentLevel_2_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,2);
                prominentLevel_2_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,3);
                prominentLevel_2_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,6);
                
                l1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,7);
                l4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,8);
                topLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,9);
                botLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{2,1}(m,10);
                
                croppedComponent = fullImg(prominentLevel_2_Match_2:(prominentLevel_2_Match_4),...
                    prominentLevel_2_Match_1:(prominentLevel_2_Match_3));
                croppedComponent = DrawColorLine(croppedComponent,l1,l4,topLine,botLine);

                
               [nRowsComponent  nColsComponent] = size(croppedComponent);
               
%                 nRowsComponent = nRowsComponent + 1;
%                 nColsComponent = nColsComponent + 1;
                
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                [nRowsRef nColsRef] = size(ImageRef);
                if(size(ImageRef,3)==3)
                    ImageRef = rgb2gray(ImageRef);
                end
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
                end
                stitchImage(3:4,5:nColsRef+4) = 255;
                stitchImage((nRowsRef+5):(nRowsRef+6),5:nColsRef+4) = 255;
                stitchImage((nRowsRef+80+3):(nRowsRef+80+4),5:nColsComponent+4) = 255;
                stitchImage((nRowsRef+4+80+nRowsComponent+1):(nRowsRef+4+80+nRowsComponent+2),5:nColsComponent+4) = 255;
                
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = croppedComponent;
                
                mergedImg = mat2gray(stitchImage);
                figure, imshow(mergedImg);
                set(gcf,'Visible', 'on');
                
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5+3;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+80+5-3;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        %                         if(mergedImgTestCol>mergedImgRefCol)
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        %                         else
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        %                         end
                        line(X,Y);
                        hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                pause(0.2);
                f = getframe(gcf);
                pause(0.2);
                imFrame = frame2im(f);
                str1 = int2str(m2);
                %
                imwrite(imFrame,[imageFilePath_4,str1 '.jpg']);
                hold off
                close;
                secondDis(m2,1) = distValue;
                fprintf(fid2,'The Distance Value of %d component is : %d \n',m2,distValue); %write first value
                m2 = m2 +1;
                
                % Drawing permanent rectangle box in the image for the component
                fullImgCopy(prominentLevel_2_Match_2:prominentLevel_2_Match_4,prominentLevel_2_Match_1)=0;
                fullImgCopy(prominentLevel_2_Match_4,prominentLevel_2_Match_1:prominentLevel_2_Match_3)=0;
                fullImgCopy(prominentLevel_2_Match_2:prominentLevel_2_Match_4,prominentLevel_2_Match_3)=0;
                fullImgCopy(prominentLevel_2_Match_2,prominentLevel_2_Match_1:prominentLevel_2_Match_3)=0;
            end
        end
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1},1))
                prominentLevel_3_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,1);
                prominentLevel_3_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,2);
                prominentLevel_3_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,3);
                prominentLevel_3_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,6);
                
                l1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,7);
                l4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,8);
                topLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,9);
                botLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{3,1}(m,10);
                
                croppedComponent = fullImg(prominentLevel_3_Match_2:(prominentLevel_3_Match_4),...
                    prominentLevel_3_Match_1:(prominentLevel_3_Match_3));
                croppedComponent = DrawColorLine(croppedComponent,l1,l4,topLine,botLine);

                [nRowsComponent  nColsComponent] = size(croppedComponent);
                
%                 nRowsComponent = nRowsComponent + 1;
%                 nColsComponent = nColsComponent + 1;
                
                if(refImg == 4)
                    disp('get me');
                end
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                [nRowsRef nColsRef] = size(ImageRef);
                if(size(ImageRef,3)==3)
                    ImageRef = rgb2gray(ImageRef);
                end
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
                end
                stitchImage(3:4,5:nColsRef+4) = 255;
                stitchImage((nRowsRef+5):(nRowsRef+6),5:nColsRef+4) = 255;
                stitchImage((nRowsRef+80+3):(nRowsRef+80+4),5:nColsComponent+4) = 255;
                stitchImage((nRowsRef+4+80+nRowsComponent+1):(nRowsRef+4+80+nRowsComponent+2),5:nColsComponent+4) = 255;
                
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = croppedComponent;
                
                
                mergedImg = mat2gray(stitchImage);
                figure, imshow(mergedImg);
                set(gcf,'Visible', 'on');
                
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5+3;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+80+5-3;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        %                         if(mergedImgTestCol>mergedImgRefCol)
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        %                         else
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        %                         end
                        line(X,Y);
                        hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                pause(0.2);
                f = getframe(gcf);
                pause(0.2);
                imFrame = frame2im(f);
                str1 = int2str(m3);
                
                imwrite(imFrame,[imageFilePath_5,str1 '.jpg']);
                hold off
                close;
                thirdDis(m3,1) = distValue;
                fprintf(fid3,'The Distance Value of %d component is : %d \n',m3,distValue); %write first value
                
                m3 = m3+1;
                %   clear I;
                
                %  Drawing permanent rectangle box in the image for the component
                fullImgCopy(prominentLevel_3_Match_2:prominentLevel_3_Match_4,prominentLevel_3_Match_1)=0;
                fullImgCopy(prominentLevel_3_Match_4,prominentLevel_3_Match_1:prominentLevel_3_Match_3)=0;
                fullImgCopy(prominentLevel_3_Match_2:prominentLevel_3_Match_4,prominentLevel_3_Match_3)=0;
                fullImgCopy(prominentLevel_3_Match_2,prominentLevel_3_Match_1:prominentLevel_3_Match_3)=0;
            end
        end
        
        if(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1},1) > 1) % checking if any First most probable candidate exists or not
            for m = 1:1:(size(obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1},1))
                prominentLevel_4_Match_1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,1);
                prominentLevel_4_Match_2 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,2);
                prominentLevel_4_Match_3 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,3);
                prominentLevel_4_Match_4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,4);
                
                distValue = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,5);
                indexOfWarpingPath = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,6);
                
                
                l1 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,7);
                l4 = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,8);
                topLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,9);
                botLine = obtainedMatchingResultOfEachRefImg{refImg,1}{j,1}{4,1}(m,10);
                
                croppedComponent = fullImg(prominentLevel_4_Match_2:(prominentLevel_4_Match_4),...
                    prominentLevel_4_Match_1:(prominentLevel_4_Match_3));
                croppedComponent = DrawColorLine(croppedComponent,l1,l4,topLine,botLine);
                
                [nRowsComponent  nColsComponent] = size(croppedComponent);
                
%                 nRowsComponent = nRowsComponent +1;
%                 nColsComponent = nColsComponent +1;
                
                ImageRef = refinedRefImgForParticularCom{indexOfWarpingPath,1};
                [nRowsRef nColsRef] = size(ImageRef);
                if(size(ImageRef,3)==3)
                    ImageRef = rgb2gray(ImageRef);
                end
                
                if(nColsComponent > nColsRef)
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
                else
                    stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
                end
                stitchImage(3:4,5:nColsRef+4) = 255;
                stitchImage((nRowsRef+5):(nRowsRef+6),5:nColsRef+4) = 255;
                stitchImage((nRowsRef+80+3):(nRowsRef+80+4),5:nColsComponent+4) = 255;
                stitchImage((nRowsRef+4+80+nRowsComponent+1):(nRowsRef+4+80+nRowsComponent+2),5:nColsComponent+4) = 255;
                
                stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
                stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = croppedComponent;
                
                mergedImg = mat2gray(stitchImage);
                figure, imshow(mergedImg);
                set(gcf,'Visible', 'on');
                
                warpingPathOfThisComponent = warpingPathOfAllComponentOfParticularImg{indexOfWarpingPath,1};
                
                
                
                if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                    for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                        refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                        testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                        
                        mergedImgRefRw = nRowsRef + 5+3;
                        mergedImgRefCol = 4+refWordColNo;
                        
                        mergedImgTestRw = nRowsRef+80+5-3;
                        mergedImgTestCol = 4+testWordColNo;
                        
                        % As row index in image is considered as Y axis in polar
                        % coordinate in matlab and vice versa
                        
                        X = [mergedImgRefCol mergedImgTestCol];
                        Y = [mergedImgRefRw mergedImgTestRw];
                        %                         if(mergedImgTestCol>mergedImgRefCol)
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgRefCol:mergedImgTestCol) = 79;
                        %                         else
                        %                             mergedImg(mergedImgRefRw:mergedImgTestRw,mergedImgTestCol:mergedImgRefCol) = 79;
                        %                         end
                        line(X,Y);
                        hold on
                    end
                else
                    error ('The size of warping path for this component is not same')
                end
                
                pause(0.2);
                f = getframe(gcf);
                pause(0.2);
                imFrame = frame2im(f);
                str1 = int2str(m4);
                
                imwrite(imFrame,[imageFilePath_6,str1 '.jpg']);
                hold off
                close;
                fourthDis(m4,1) = distValue;
                fprintf(fid4,'The Distance Value of %d component is : %d \n',m4,distValue); %write first value
                m4 = m4 +1;
                
                % Drawing permanent rectangle box in the image for the component
                fullImgCopy(prominentLevel_4_Match_2:prominentLevel_4_Match_4,prominentLevel_4_Match_1)=0;
                fullImgCopy(prominentLevel_4_Match_4,prominentLevel_4_Match_1:prominentLevel_4_Match_3)=0;
                fullImgCopy(prominentLevel_4_Match_2:prominentLevel_4_Match_4,prominentLevel_4_Match_3)=0;
                fullImgCopy(prominentLevel_4_Match_2,prominentLevel_4_Match_1:prominentLevel_4_Match_3)=0;
            end
        end
        %         fclose(fid4); %close the file
        newStr = int2str(j);
        imwrite(fullImgCopy,[imageFilePath_2, 'FULL_IMAGE',newStr,'.jpg']);
    end
    imageFilePath_3Nw = [imageFilePath_3 'updated/'];
    imageFilePath_4Nw = [imageFilePath_4 'updated/'];
    imageFilePath_5Nw = [imageFilePath_5 'updated/'];
    imageFilePath_6Nw = [imageFilePath_6 'updated/'];
    
    if((exist(imageFilePath_3Nw,'dir'))==0)
        mkdir(imageFilePath_3Nw);
    end
    if((exist(imageFilePath_4Nw,'dir'))==0)
        mkdir(imageFilePath_4Nw);
    end
    if((exist(imageFilePath_5Nw,'dir'))==0)
        mkdir(imageFilePath_5Nw);
    end
    if((exist(imageFilePath_6Nw,'dir'))==0)
        mkdir(imageFilePath_6Nw);
    end
    
    distanceText1New = strcat(imageFilePath_3Nw,'distanceValue.txt');
    fid1Nw = fopen(distanceText1New, 'wt');
    [~,~,firstDis] = find(firstDis);
    [~,~,secondDis] = find(secondDis);
    [~,~,thirdDis] = find(thirdDis);
    [~,~,fourthDis] = find(fourthDis);
    
    [~,sortedIndex1] = sort(firstDis);
    %     [~,R,sortedIndex1] = arrangeImages(distanceText1);
    for sr1 = 1:1:(size(sortedIndex1,1))
        v1 = sortedIndex1(sr1,1);
        distVal = firstDis(v1,1);
        str1 = int2str(v1);
        imagePath = [imageFilePath_3 str1 '.jpg'];
        im = imread(imagePath);
        str2 = int2str(sr1);
        imwrite(im,[imageFilePath_3Nw,str2 '.jpg']);
        fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
        
    end
    fclose(fid1Nw);
    
    distanceText1New = strcat(imageFilePath_4Nw,'distanceValue.txt');
    fid1Nw = fopen(distanceText1New, 'wt');
    
    [~,sortedIndex1] = sort(secondDis);
    %     [~,R,sortedIndex1] = arrangeImages(distanceText2);
    for sr1 = 1:1:(size(sortedIndex1,1))
        v1 = sortedIndex1(sr1,1);
        distVal = secondDis(v1,1);
        str1 = int2str(v1);
        imagePath = [imageFilePath_4 str1 '.jpg'];
        im = imread(imagePath);
        str2 = int2str(sr1);
        imwrite(im,[imageFilePath_4Nw,str2 '.jpg']);
        fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
        
    end
    fclose(fid1Nw);
    
    distanceText1New = strcat(imageFilePath_5Nw,'distanceValue.txt');
    fid1Nw = fopen(distanceText1New, 'wt');
    
    [~,sortedIndex1] = sort(thirdDis);
    %     [~,R,sortedIndex1] = arrangeImages(distanceText3);
    for sr1 = 1:1:(size(sortedIndex1,1))
        v1 = sortedIndex1(sr1,1);
        distVal = thirdDis(v1,1);
        str1 = int2str(v1);
        imagePath = [imageFilePath_5 str1 '.jpg'];
        im = imread(imagePath);
        str2 = int2str(sr1);
        imwrite(im,[imageFilePath_5Nw,str2 '.jpg']);
        fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
        
    end
    fclose(fid1Nw);
    
    distanceText1New = strcat(imageFilePath_6Nw,'distanceValue.txt');
    fid1Nw = fopen(distanceText1New, 'wt');
    
    [~,sortedIndex1] = sort(fourthDis);
    %     [~,R,sortedIndex1] = arrangeImages(distanceText4);
    for sr1 = 1:1:(size(sortedIndex1,1))
        v1 = sortedIndex1(sr1,1);
        distVal = fourthDis(v1,1);
        str1 = int2str(v1);
        imagePath = [imageFilePath_6 str1 '.jpg'];
        im = imread(imagePath);
        str2 = int2str(sr1);
        imwrite(im,[imageFilePath_6Nw,str2 '.jpg']);
        fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
        
    end
    fclose(fid1Nw);
    
    
    fclose(fid1); %close the file
    fclose(fid2); %close the file
    fclose(fid3); %close the file
    fclose(fid4); %close the file
    
    bestMatchVal1 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,1);
    bestMatchVal2 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,2);
    bestMatchVal3 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,3);
    bestMatchVal4 = obtainedMatchingResultOfEachRefImg{refImg,2}(1,4);
    imagePathBest = bestImageMatchForRefImg;%obtainedMatchingResultOfEachRefImg{i,1}{2,1}(1,5);
    
    %     [~, winNameBest, winExtBest] = fileparts(imagePathBest);
    %     macPath_2 = [macPath winNameBest winExtBest];
    
    
    bestMatchedImg = imread(imagePathBest);
    
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
end




