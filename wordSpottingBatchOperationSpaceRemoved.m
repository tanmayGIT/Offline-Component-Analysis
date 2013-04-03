function [candidatePositionHolder] =  wordSpottingBatchOperationSpaceRemoved(Img,refComponentMat,rowRef)
% global beforeRLSA;
% global refComponentMat;
[beforeRLSA,afterRLSA] = wordSpottingBasicOperation(Img); % for full image
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
                HoldConnecCom{s,1}(1,2) = ConnComY;
            else
                HoldConnecCom{s,1}(end+1,1) = ConnComX;
                HoldConnecCom{s,1}(end,2) = ConnComY;
            end
        end
    end
end

p=1;
ComponentHeightHist = zeros(totalComponent,1);
ComponentAreaHist = zeros(totalComponent,1);
ComponentHghtWdth = nan(totalComponent,2);
%HoldConnecCom1  = nan{Mx, 1};
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
        
        Y = [HoldConnecComRefined{p,1}(1,3) HoldConnecComRefined{p,1}(2,3)];
        X = [HoldConnecComRefined{p,1}(1,4) HoldConnecComRefined{p,1}(2,4)];
%         line(X,Y);
        
        Wdth = sqrt(((Y(2)-Y(1))^2)+ ((X(2)-X(1))^2));
        
%         X = [HoldConnecComRefined{p,1}(1,4) HoldConnecComRefined{p,1}(3,4)];
%         Y = [HoldConnecComRefined{p,1}(1,3) HoldConnecComRefined{p,1}(3,3)];
%         line(X,Y);
        
%         Y = [HoldConnecComRefined{p,1}(3,3) HoldConnecComRefined{p,1}(4,3)];
%         X = [HoldConnecComRefined{p,1}(3,4) HoldConnecComRefined{p,1}(4,4)];
%         line(X,Y);
        
        Y = [HoldConnecComRefined{p,1}(4,3) HoldConnecComRefined{p,1}(2,3)];
        X = [HoldConnecComRefined{p,1}(4,4) HoldConnecComRefined{p,1}(2,4)];
%         line(X,Y);
        
        % Calculating the height of the component
        Hght = sqrt(((Y(2)-Y(1))^2)+ ((X(2)-X(1))^2));
        if ((Hght>0)&&(Wdth>0))
            [r,~] = find((ComponentHeightHist(:,1))==Hght);
            
            % for eliminating those component whose height & width don't overcome
            % the threshold parameter.
            ComponentHghtWdth(p,1) = Hght; % storing component height
            ComponentHghtWdth(p,2) = Wdth; % storing component width
            ComponentHghtWdth(p,3) = Wdth*Hght;% storing component area
            % ComponentHeightHist storing the height and corrosponding no. of
            % component with that height. It is basically calculating histogram
            % with the heights of all detected component
            [rArea,~] = find((ComponentAreaHist(:,1))==(Hght*Wdth));
            if(isempty(rArea))
                ComponentAreaHist(p,1) = (Hght*Wdth);
                ComponentAreaHist(p,2) = 1;
            else
                ComponentAreaHist(rArea,2) = ComponentAreaHist(rArea,2)+1;
            end
            if(isempty(r))
                ComponentHeightHist(p,1) = Hght;
                ComponentHeightHist(p,2) = 1;
            else
                ComponentHeightHist(r,2) = ComponentHeightHist(r,2)+1;
            end
            p = p+1;
        end
    end
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

ComponentHghtWdth = ComponentHghtWdth(~isnan(ComponentHghtWdth(:,2)),:);
%HoldConnecCom1 = HoldConnecCom1(~isZero(HoldConnecCom1(:,1)),:);

% The maximum value of the histogram, the length which is the height of maximum no.
% of words, taken as the height of the component maximally occured
[~,posHght] = max(ComponentHeightHist(:,2));
[~,posArea] = max(ComponentAreaHist(:,2));
 avgHght = ComponentHeightHist(posHght,1);
% avgArea = ComponentAreaHist(posArea,1);

%%

% where FilteredConnectedCom will satisfy the above given condition

OsbTestVal = zeros((size(ComponentHghtWdth,1)),1);
storWarpingPath = cell((size(ComponentHghtWdth,1)),1);
% Cnt = 1;
% FilteredConnectedCom = cell((size(HoldConnecComMoreRefined,1)), 1);

fullImg = Img;
refComponentSize = (size(refComponentMat{1,2},2));
refMatForMatch = (refComponentMat{1,3}); % getting the number of columns of the image 
realIndexRef = (refComponentMat{1,4});

parfor Chk = 1:size(ComponentHghtWdth,1)
     if((ComponentHghtWdth(Chk,1)<(2*avgHght))&&(ComponentHghtWdth(Chk,1)>(avgHght/2)))
        componentImg = beforeRLSA(((HoldConnecComMoreRefined{Chk,1}(1,3)):(HoldConnecComMoreRefined{Chk,1}(4,3))),...
            ((HoldConnecComMoreRefined{Chk,1}(1,4)):(HoldConnecComMoreRefined{Chk,1}(4,4))));
        componentImg = imresize(componentImg, [rowRef (size(componentImg,2))]);
        componentWdth = ComponentHghtWdth(Chk,2);
        if((refComponentSize/2)<=(componentWdth)) % If the size of the chracter is more than the reference char
            [featureMat,realIndexTest] = GetFeatureOfComponentUpdated_2(componentImg,(HoldConnecComMoreRefined{Chk,1}(1,3)),...
                (HoldConnecComMoreRefined{Chk,1}(1,4)),HoldConnecComMoreRefined{Chk,1}(4,3),fullImg);
            [~,distVal,getIndexes] = stringMatchingWithMVM(refMatForMatch,featureMat,realIndexRef,realIndexTest);
            storWarpingPath{Chk,1} = getIndexes;
            OsbTestVal(Chk) = distVal;
%             disp(Chk);
        end
     end
 
end

candidatePositionHolder = cell(6,2);
[indexOfVal,~,nonZeroDistVal] = find(OsbTestVal(:,1));
bestCandidate = zeros(1,4);
nonZeroDistVal = sort(nonZeroDistVal,1);
meanDistVal = nanmedian(nonZeroDistVal);
prominentLevel1 = ((meanDistVal*33.3333)/100);
prominentLevel2 = ((meanDistVal*(33.3333+33.3333))/100);
prominentLevel3 = meanDistVal;

firstMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);
secondMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);
thirdMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);
fourthMostProbableCandidates = zeros((size(nonZeroDistVal,1)),6);

firstMostProbableCandidatesCounter = 1;
secondMostProbableCandidatesCounter = 1;
thirdMostProbableCandidatesCouter = 1;
fourthMostProbableCandidatesCounter = 1;
minDist = OsbTestVal(1,1);
minDistIndex = 1;
for i=1:1:size(nonZeroDistVal,1)
    index = indexOfVal(i,1);
    distVal = OsbTestVal(index,1);
    Chk = index;
    if(minDist>distVal)
        minDistIndex = index;
    end
    if((0< distVal)&&(distVal <= prominentLevel1))
        firstMostProbableCandidates(firstMostProbableCandidatesCounter,1) = (HoldConnecComMoreRefined{Chk,1}(1,4));
        firstMostProbableCandidates(firstMostProbableCandidatesCounter,2) = (HoldConnecComMoreRefined{Chk,1}(1,3));
        firstMostProbableCandidates(firstMostProbableCandidatesCounter,3) = ((HoldConnecComMoreRefined{Chk,1}(4,4))...
            -(HoldConnecComMoreRefined{Chk,1}(1,4)));
        firstMostProbableCandidates(firstMostProbableCandidatesCounter,4) = ((HoldConnecComMoreRefined{Chk,1}(4,3))...
            -(HoldConnecComMoreRefined{Chk,1}(1,3)));
        firstMostProbableCandidates(firstMostProbableCandidatesCounter,5) = distVal; % storing the distance value
        firstMostProbableCandidates(firstMostProbableCandidatesCounter,6) = Chk; % storing the index to retrieve the warping path
        
        firstMostProbableCandidatesCounter = firstMostProbableCandidatesCounter +1;
        %         rectangle('Position',[(HoldConnecComMoreRefined{Chk,1}(1,4)),(HoldConnecComMoreRefined{Chk,1}(1,3))...
        %             ,((HoldConnecComMoreRefined{Chk,1}(4,4))-(HoldConnecComMoreRefined{Chk,1}(1,4))),...
        %             ((HoldConnecComMoreRefined{Chk,1}(4,3))-(HoldConnecComMoreRefined{Chk,1}(1,3)))],'LineWidth',1,'LineStyle','--',...
        %             'EdgeColor','g');
        
    elseif ((prominentLevel1 < distVal)&&(distVal <= prominentLevel2)) % more prominent match
        secondMostProbableCandidates(secondMostProbableCandidatesCounter,1) = (HoldConnecComMoreRefined{Chk,1}(1,4));
        secondMostProbableCandidates(secondMostProbableCandidatesCounter,2) = (HoldConnecComMoreRefined{Chk,1}(1,3));
        secondMostProbableCandidates(secondMostProbableCandidatesCounter,3) = ((HoldConnecComMoreRefined{Chk,1}(4,4))...
            -(HoldConnecComMoreRefined{Chk,1}(1,4)));
        secondMostProbableCandidates(secondMostProbableCandidatesCounter,4) = ((HoldConnecComMoreRefined{Chk,1}(4,3))...
            -(HoldConnecComMoreRefined{Chk,1}(1,3)));
        secondMostProbableCandidates(secondMostProbableCandidatesCounter,5) = distVal;
        secondMostProbableCandidates(secondMostProbableCandidatesCounter,6) = Chk;
        secondMostProbableCandidatesCounter = secondMostProbableCandidatesCounter +1;
        %         rectangle('Position',[(HoldConnecComMoreRefined{Chk,1}(1,4)),(HoldConnecComMoreRefined{Chk,1}(1,3))...
        %             ,((HoldConnecComMoreRefined{Chk,1}(4,4))-(HoldConnecComMoreRefined{Chk,1}(1,4))),...
        %             ((HoldConnecComMoreRefined{Chk,1}(4,3))-(HoldConnecComMoreRefined{Chk,1}(1,3)))],'LineWidth',1,'LineStyle','--',...
        %             'EdgeColor','y');
        
        
    elseif ((prominentLevel2 < distVal)&& (distVal <= prominentLevel3)) % more prominent match
        thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,1) = (HoldConnecComMoreRefined{Chk,1}(1,4));
        thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,2) = (HoldConnecComMoreRefined{Chk,1}(1,3));
        thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,3) = ((HoldConnecComMoreRefined{Chk,1}(4,4))...
            -(HoldConnecComMoreRefined{Chk,1}(1,4)));
        thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,4) = ((HoldConnecComMoreRefined{Chk,1}(4,3))...
            -(HoldConnecComMoreRefined{Chk,1}(1,3)));
        thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,5) = distVal;
        thirdMostProbableCandidates(thirdMostProbableCandidatesCouter,6) = Chk;
        thirdMostProbableCandidatesCouter = thirdMostProbableCandidatesCouter +1;
        %         rectangle('Position',[(HoldConnecComMoreRefined{Chk,1}(1,4)),(HoldConnecComMoreRefined{Chk,1}(1,3))...
        %             ,((HoldConnecComMoreRefined{Chk,1}(4,4))-(HoldConnecComMoreRefined{Chk,1}(1,4))),...
        %             ((HoldConnecComMoreRefined{Chk,1}(4,3))-(HoldConnecComMoreRefined{Chk,1}(1,3)))],'LineWidth',1,'LineStyle','--',...
        %             'EdgeColor','m');
        
        
        
    elseif (prominentLevel3 < distVal ) % more prominent match
        fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,1) = (HoldConnecComMoreRefined{Chk,1}(1,4));
        fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,2) = (HoldConnecComMoreRefined{Chk,1}(1,3));
        fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,3) = ((HoldConnecComMoreRefined{Chk,1}(4,4))...
            -(HoldConnecComMoreRefined{Chk,1}(1,4)));
        fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,4) = ((HoldConnecComMoreRefined{Chk,1}(4,3))...
            -(HoldConnecComMoreRefined{Chk,1}(1,3)));
        fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,5) = distVal;
        fourthMostProbableCandidates(fourthMostProbableCandidatesCounter,6) = Chk;
        fourthMostProbableCandidatesCounter = fourthMostProbableCandidatesCounter +1;
        %         rectangle('Position',[(HoldConnecComMoreRefined{Chk,1}(1,4)),(HoldConnecComMoreRefined{Chk,1}(1,3))...
        %             ,((HoldConnecComMoreRefined{Chk,1}(4,4))-(HoldConnecComMoreRefined{Chk,1}(1,4))),...
        %             ((HoldConnecComMoreRefined{Chk,1}(4,3))-(HoldConnecComMoreRefined{Chk,1}(1,3)))],'LineWidth',1,'LineStyle','--',...
        %             'EdgeColor','r');
    else
        fprintf('Dont know why it cannot find any match \n ');
    end
end

bestCandidate(1,1) = HoldConnecComMoreRefined{minDistIndex,1}(1,4);
bestCandidate(1,2) = HoldConnecComMoreRefined{minDistIndex,1}(1,3);
bestCandidate(1,3) = HoldConnecComMoreRefined{minDistIndex,1}(4,4) - HoldConnecComMoreRefined{minDistIndex,1}(1,4);
bestCandidate(1,4) = HoldConnecComMoreRefined{minDistIndex,1}(4,3)- HoldConnecComMoreRefined{minDistIndex,1}(1,3);

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

candidatePositionHolder{1,1} = bestCandidate;

candidatePositionHolder{2,1} = firstMostProbableCandidates;
candidatePositionHolder{2,2} = firstMostProbableCandidatesCounter;

candidatePositionHolder{3,1} = secondMostProbableCandidates;
candidatePositionHolder{3,2} = secondMostProbableCandidatesCounter;

candidatePositionHolder{4,1} = thirdMostProbableCandidates;
candidatePositionHolder{4,2} = thirdMostProbableCandidatesCouter;

candidatePositionHolder{5,1} = fourthMostProbableCandidates;
candidatePositionHolder{5,2} = fourthMostProbableCandidatesCounter;

candidatePositionHolder{6,1} = storWarpingPath;

return;
end