function [mergeAllTogether] =  wordSpottingBatchOperationOfflineMode(Img)
% global beforeRLSA;
% global refComponentMat;
% global imageFilePath_4;
% global str1;

[beforeRLSA,afterRLSA,startText,horiRLSAThresh,verRLSAThresh] = wordSpottingBasicOperation(Img); % for full image
% figure, imshow(beforeRLSA), hold on;
binarisedImg = afterRLSA;
CC = bwconncomp(binarisedImg);
L = labelmatrix(CC);

% RGB2 = label2rgb(L, 'lines', 'c', 'shuffle');

%% now we will pick up the coordinates of the connected component's pixels
% locations and store them in respective array,
totalComponent = max(max(L)); % number of connected component present in the image
% Initialising the matrix
HoldConnecCom  = cell(totalComponent, 1);
HoldConnecComRefined = cell(totalComponent, 1);
for Ini = 1:totalComponent
    HoldConnecCom{Ini,1}(1,1) = 0;
    HoldConnecCom{Ini,1}(1,2) = 0;
    
    HoldConnecComRefined{Ini,1}(1,1) = 0;
    HoldConnecComRefined{Ini,1}(1,2) = 0;
    
end

for ConnComX = 1:1:size(L,1)
    for ConnComY = 1:1:size(L,2)
        if (L(ConnComX,ConnComY)~=0)
            s = L(ConnComX,ConnComY);
            if(HoldConnecCom{s,1}(1,1)==0)
                HoldConnecCom{s,1}(1,1) = ConnComX;
                HoldConnecCom{s,1}(1,2) = ConnComY+(startText-1);
            else
                HoldConnecCom{s,1}(end+1,1) = ConnComX;
                HoldConnecCom{s,1}(end,2) = ConnComY+(startText-1);
            end
        end
    end
end

p=1;
% ComponentHeightHist = zeros(totalComponent,1);
% ComponentAreaHist = zeros(totalComponent,1);
ComponentHghtWdth = zeros(totalComponent,1);
%HoldConnecCom1  = nan{Mx, 1};
progressbar([],[],0)
for AccesEachCell = 1:1:totalComponent
    if (size((HoldConnecCom{AccesEachCell,1}),1)>=30) % for ignoring the unnecessary component
        HoldConnecComRefined{p,1} = HoldConnecCom{AccesEachCell,1};
        % from the next statement we are getting the minimum row, i.e
        % minimum at the Y direction
        [minRow] = min(HoldConnecComRefined{p,1}(:,1));
        % now we will find out the minimum Col, i.e. in the X direction
        [minCol] = min(HoldConnecComRefined{p,1}(:,2));
        
        % for the top left most corner
        HoldConnecComRefined{p,1}(1,3) = minRow;%holding the min row; i.e. minimum at the Y direction
        HoldConnecComRefined{p,1}(1,4) = minCol;%holding the min value col; i.e. minimum at the X direction
        
        % for the top right most corner
        [maxCol] = max(HoldConnecComRefined{p,1}(:,2));
        % for the top right most corner
        HoldConnecComRefined{p,1}(2,3) = minRow;%holding the min value of row; i.e. minimum at the Y direction
        HoldConnecComRefined{p,1}(2,4) = maxCol;%holding the max value of col; i.e. minimum at the X direction
        
        %for the bottom left most corner from next statement we are getting the
        %maximum of row; i.e in the Y direction
        [maxRow] = max(HoldConnecComRefined{p,1}(:,1));
        
        HoldConnecComRefined{p,1}(3,3) = maxRow;%holding the max of row; i.e. in the Y direction
        HoldConnecComRefined{p,1}(3,4) = minCol;%holding the min of Col i.e. in the X direction
        
        %for the bottom right most corner
        HoldConnecComRefined{p,1}(4,3) = maxRow;%holding the max value of X coordinate
        HoldConnecComRefined{p,1}(4,4) = maxCol;%holding the max value of the Y coordinate
        
        Y = [HoldConnecComRefined{p,1}(1,3) HoldConnecComRefined{p,1}(3,3)];
        X = [HoldConnecComRefined{p,1}(1,4) HoldConnecComRefined{p,1}(2,4)];
        %          line(X,Y);
        
        Wdth = X(2)-X(1);
        
        %         X = [HoldConnecComRefined{p,1}(1,4) HoldConnecComRefined{p,1}(3,4)];
        %         Y = [HoldConnecComRefined{p,1}(1,3) HoldConnecComRefined{p,1}(3,3)];
        %         line(X,Y);
        %
        %         Y = [HoldConnecComRefined{p,1}(3,3) HoldConnecComRefined{p,1}(4,3)];
        %         X = [HoldConnecComRefined{p,1}(3,4) HoldConnecComRefined{p,1}(4,4)];
        %         line(X,Y);
        %
        %         Y = [HoldConnecComRefined{p,1}(4,3) HoldConnecComRefined{p,1}(2,3)];
        %         X = [HoldConnecComRefined{p,1}(4,4) HoldConnecComRefined{p,1}(2,4)];
        %          line(X,Y);
        
        % Calculating the height of the component
        Hght = Y(2)-Y(1);
        if ((Hght>0)&&(Wdth>0))
            %             [r,~] = find((ComponentHeightHist(:,1))==Hght);
            
            % for eliminating those component whose height & width don't overcome
            % the threshold parameter.
            ComponentHghtWdth(p,1) = Hght; % storing component height
            %             ComponentHghtWdth(p,2) = Wdth; % storing component width
            %             ComponentHghtWdth(p,3) = Wdth*Hght;% storing component area
            % ComponentHeightHist storing the height and corrosponding no. of
            % component with that height. It is basically calculating histogram
            % with the heights of all detected component
            %             [rArea,~] = find((ComponentAreaHist(:,1))==(Hght*Wdth));
            %             if(isempty(rArea))
            %                 ComponentAreaHist(p,1) = (Hght*Wdth);
            %                 ComponentAreaHist(p,2) = 1;
            %             else
            %                 ComponentAreaHist(rArea,2) = ComponentAreaHist(rArea,2)+1;
            %             end
            %             if(isempty(r))
            %                 ComponentHeightHist(p,1) = Hght;
            %                 ComponentHeightHist(p,2) = 1;
            %             else
            %                 ComponentHeightHist(r,2) = ComponentHeightHist(r,2)+1;
            %             end
            p = p+1;
        end
    end
    progressbar([],[],AccesEachCell/totalComponent)
end

% As HoldConnecComRefined is the refined version of HoldConnecCom, where the
% component size is more than 30 pixels, so it may be possible that
% HoldConnecComRefined size is not same as HoldConnecCom; it may be less than
% HoldConnecCom. If it is then calculate the difference in length and those
% cell will contain zero. Now if any cell is containing zero then we need
% to remove it
if((p-1) <= totalComponent)       % p-1 bcoz of the last increment bfore leaving the loop
    %cnt = 0;
    HoldConnecComMoreRefined = cell((p-1), 1);
    for getCell = 1:1:(p-1)
        HoldConnecComMoreRefined{getCell,1} = HoldConnecComRefined{getCell,1} ;
        % cnt = cnt+1;
    end
else
    HoldConnecComMoreRefined = HoldConnecComRefined;
end
clear HoldConnecComRefined;

[~,~,ComponentHghtWdth] = find(ComponentHghtWdth);
% ComponentHghtWdth = ComponentHghtWdth(~isnan(ComponentHghtWdth(:,2)),:);
%HoldConnecCom1 = HoldConnecCom1(~isZero(HoldConnecCom1(:,1)),:);
diff = (max(ComponentHghtWdth(:,1)) - min(ComponentHghtWdth(:,1)));
nElement = length(ComponentHghtWdth);
if((diff>(20*4))||(nElement > (20*4)))
    nBins = ceil(diff/4);
elseif(((diff>(20*2))&&(diff<(20*4))) || ((nElement>(20*2))&&(nElement<(20*4))))
    nBins = ceil(diff/3);
elseif(((diff>(10*2))&&(diff<(20*2))) || ((nElement>(10*2))&&(nElement<(20*2))))
    nBins = ceil(diff/2);
elseif((diff<(10*2))||(nElement<(10*2)))
    nBins = nElement;
end
% nBins = ceil((max(ComponentHghtWdth(:,1)) - min(ComponentHghtWdth(:,1)))/4);
storInBin1 = zeros((size(ComponentHghtWdth,1)),1);
storInBin2 = zeros((size(ComponentHghtWdth,1)),1);
storInBin3 = zeros((size(ComponentHghtWdth,1)),1);
storInBin4 = zeros((size(ComponentHghtWdth,1)),1);
% storInBin5 = zeros((size(ComponentHghtWdth,1)),1);

binCnt1 = 1;
binCnt2 = 1;
binCnt3 = 1;
binCnt4 = 1;
% binCnt5 = 1;

for sortBin = 1:1:(size(ComponentHghtWdth,1))
    if(((ComponentHghtWdth(sortBin,1)) >= (min(ComponentHghtWdth(:,1))))&& ...
            ((ComponentHghtWdth(sortBin,1)) <= (nBins)))
        storInBin1(binCnt1,1) = ComponentHghtWdth(sortBin,1);
        binCnt1 = binCnt1+1;
    elseif (((ComponentHghtWdth(sortBin,1)) > (nBins))&& ...
            ((ComponentHghtWdth(sortBin,1)) <= (nBins+nBins)))
        storInBin2(binCnt2,1) = ComponentHghtWdth(sortBin,1);
        binCnt2 = binCnt2+1;
    elseif (((ComponentHghtWdth(sortBin,1)) > (nBins+nBins))&& ...
            ((ComponentHghtWdth(sortBin,1)) <= (nBins+nBins+nBins)))
        storInBin3(binCnt3,1) = ComponentHghtWdth(sortBin,1);
        binCnt3 = binCnt3+1;
    elseif (((ComponentHghtWdth(sortBin,1)) > (nBins+nBins+nBins)))%&&((ComponentHghtWdth(sortBin,1)) <= (nBins+nBins+nBins+nBins)))
        storInBin4(binCnt4,1) = ComponentHghtWdth(sortBin,1);
        binCnt4 = binCnt4+1;
        %     elseif (((ComponentHghtWdth(sortBin,1)) > (nBins+nBins+nBins+nBins))&& ...
        %             ((ComponentHghtWdth(sortBin,1)) <= (max(ComponentHghtWdth(:,1)))))
        %         storInBin5(binCnt5,1) = ComponentHghtWdth(sortBin,1);
        %         binCnt5 = binCnt5+1;
    end
end

[~,~,storInBin1] = find(storInBin1);
[~,~,storInBin2] = find(storInBin2);
[~,~,storInBin3] = find(storInBin3);
[~,~,storInBin4] = find(storInBin4);
% [~,~,storInBin5] = find(storInBin5);

vectForMax = [(binCnt1-1),(binCnt2-1),(binCnt3-1),(binCnt4-1)];%,(binCnt5-1)];
[~,maxIndex] = max(vectForMax);
avgHght = 0;
if(maxIndex == 1)
    avgHght = nanmean(storInBin1(:,1));
elseif(maxIndex == 2)
    avgHght = nanmean(storInBin2(:,1));
elseif(maxIndex == 3)
    avgHght = nanmean(storInBin3(:,1));
elseif(maxIndex == 4)
    avgHght = nanmean(storInBin4(:,1));
    % elseif(maxIndex == 5)
    %     avgHght = nanmean(storInBin5(:,1));
end

if(avgHght<35)
    [~,Index] = sort(vectForMax);
    myIndex = Index(1,2);
    if(myIndex == 1)
        avgHght = nanmean(storInBin1(:,1));
    elseif(myIndex == 2)
        avgHght = nanmean(storInBin2(:,1));
    elseif(myIndex == 3)
        avgHght = nanmean(storInBin3(:,1));
    elseif(myIndex == 4)
        avgHght = nanmean(storInBin4(:,1));
        
    end
end
% The maximum value of the histogram, the length which is the height of maximum no.
% of words, taken as the height of the component maximally occured
% [~,posHght] = max(ComponentHeightHist(:,2));
% [~,posArea] = max(ComponentAreaHist(:,2));
%  avgHght = ComponentHeightHist(posHght,1);
% avgArea = ComponentAreaHist(posArea,1);

fullImg = Img;

prinComponentScore = cell((size(ComponentHghtWdth,1)),1);
prinComponentLatent = cell((size(ComponentHghtWdth,1)),1);
prinComponentFeatureMat = cell((size(ComponentHghtWdth,1)),1);
keepComponentBoundary = cell((size(ComponentHghtWdth,1)),1);
realIndexFeatureMat = cell((size(ComponentHghtWdth,1)),1);
ascenDescenMat = cell((size(ComponentHghtWdth,1)),1);
progressbar([],0)
szReq = size(HoldConnecComMoreRefined,1);
parfor Chk = 1:size(HoldConnecComMoreRefined,1)
    
    if((ComponentHghtWdth(Chk,1)<(4*avgHght))&&(ComponentHghtWdth(Chk,1)>(avgHght/4)))
        %         disp(Chk);
        componentImg = beforeRLSA((HoldConnecComMoreRefined{Chk,1}(1,3)):(HoldConnecComMoreRefined{Chk,1}(4,3)),...
            (HoldConnecComMoreRefined{Chk,1}(1,4)-((startText-1))):(HoldConnecComMoreRefined{Chk,1}(4,4)-((startText-1))));
        
        
        nCol = size(componentImg,2);
        CCcomponent = bwconncomp(componentImg);
        Lcomponent = labelmatrix(CCcomponent);
        nCom = max(max(Lcomponent));
        if((nCom >4) && (nCol > (3*30)))% as we do not want to match the components which even do not have less than 4 components
            orgComponentImg = fullImg((HoldConnecComMoreRefined{Chk,1}(1,3)):(HoldConnecComMoreRefined{Chk,1}(4,3)),...
                (HoldConnecComMoreRefined{Chk,1}(1,4)):(HoldConnecComMoreRefined{Chk,1}(4,4)));
            
            accumulatedInCell = enterInCell((HoldConnecComMoreRefined{Chk,1}(1,3)),(HoldConnecComMoreRefined{Chk,1}(4,3)),...
                (HoldConnecComMoreRefined{Chk,1}(1,4)),(HoldConnecComMoreRefined{Chk,1}(4,4)));
            
            keepComponentBoundary{Chk,1} = accumulatedInCell;
            
            %         figure,imshow(componentImg);
            %         figure,imshow(orgComponentImg);
            %         [~,componentCol ] = size(componentImg);
            
            %         componentImg = imresize(componentImg,[avgHght componentCol]); % resizing the components with the avg height
            %         orgComponentImg = imresize(orgComponentImg,[avgHght componentCol]); % resizing the grey image component with the avg height
            
            [featureMat,realIndexMat] = GetFeatureOfComponentUpdated_2Exp(componentImg,orgComponentImg);
            [l1,l4,topLineTest,bottomLineTest] = testAscenderDescenderFunc(orgComponentImg);
            accumulatedCel = enterInCell(l1,l4,topLineTest,bottomLineTest);
            [~,score,latent,~] = princomp(featureMat);
            prinComponentScore{Chk,1} = score;
            prinComponentLatent{Chk,1} = latent;
            prinComponentFeatureMat{Chk,1} = featureMat; % keeping the original feature mat not the PCA mat
            realIndexFeatureMat{Chk,1} = realIndexMat;
            ascenDescenMat{Chk,1} = accumulatedCel;
            
            %         convertStr = int2str(str1);
            %         imwrite(componentImg,[imageFilePath_4,convertStr '.jpg']);
            %         str1 = str1+1;
            %             signifyImp = cumsum(latent)./sum(latent);
            %             for p = 1:1:(size(signifyImp,1))
            %                 if(signifyImp(p,1) >= 0.95)
            %                     break;
            %                 end
            %             end
            %             hold off
            %             close;
        end
    end
    progressbar([],Chk/szReq)
end
mergeAllTogether = cell(1,9);
mergeAllTogether{1,1} =  prinComponentScore;
mergeAllTogether{1,2} =  prinComponentLatent;
mergeAllTogether{1,3} = keepComponentBoundary;
mergeAllTogether{1,4} = prinComponentFeatureMat;  % keeping the original feature mat not the PCA mat
mergeAllTogether{1,5} = realIndexFeatureMat;
mergeAllTogether{1,6} = ceil(avgHght);
mergeAllTogether{1,7} = horiRLSAThresh;
mergeAllTogether{1,8} = verRLSAThresh;
mergeAllTogether{1,9} = ascenDescenMat;
return;
end