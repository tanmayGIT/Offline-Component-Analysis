function [FilteredConnectedCom] = AnalyzeComponentRefWordForWordLevel(beforeRLSARef, afterRLSARef,ImgRef,hghtTestComponent,accumulatedCell)
% [~, nColRef] = size(beforeRLSARef);
l1Test = accumulatedCell(1,1);
l4Test = accumulatedCell(1,2);
topLineTest = accumulatedCell(1,3);
baseLineTest = accumulatedCell(1,4);

binarisedImg = afterRLSARef;
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
% ComponentHeightHist = zeros(totalComponent,1);
% ComponentAreaHist = zeros(totalComponent,1);
ComponentHghtWdth = zeros(totalComponent,1);
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
        
        Y = [HoldConnecComRefined{p,1}(1,3) HoldConnecComRefined{p,1}(3,3)];
        X = [HoldConnecComRefined{p,1}(1,4) HoldConnecComRefined{p,1}(2,4)];
        
        
        Wdth = X(2)-X(1);
        Hght = Y(2)-Y(1);
        if ((Hght>0)&&(Wdth>0))
            %             [r,~] = find((ComponentHeightHist(:,1))==Hght);
            
            % for eliminating those component whose height & width don't overcome
            % the threshold parameter.
            ComponentHghtWdth(p,1) = Hght; % storing component height
            p = p+1;
        end
    end
end

[~,~,ComponentHghtWdth] = find(ComponentHghtWdth);




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



%%Step4: Remove nontext component and noise with height>3H/ <H/4/
%width<H/4; where H = AvgHght
% global Img;
% fullImg = ImgRef;
Cnt = 1;
FilteredConnectedCom = cell(1, 4);
% where FilteredConnectedCom will satisfy the above given condition
comSz = zeros((size(ComponentHghtWdth,1)),1);
for Chk = 1:1:size(ComponentHghtWdth,1)
    comSz(Chk,1) = size((HoldConnecComMoreRefined{Chk,1}),1);
end
[~,maxIndx] = max(comSz);
%     if((ComponentHghtWdth(Chk,1)<(4*avgHght))&&...
%             (ComponentHghtWdth(Chk,1)>(avgHght/4)))
Chk = maxIndx;
componentImg = beforeRLSARef((HoldConnecComMoreRefined{Chk,1}(1,3)):(HoldConnecComMoreRefined{Chk,1}(4,3)),...
    (HoldConnecComMoreRefined{Chk,1}(1,4)):(HoldConnecComMoreRefined{Chk,1}(4,4)));

[l1Ref,l4Ref,topLineRef,baseLineRef] = testAscenderDescenderFunc(componentImg);
ImgRef = ImgRef((HoldConnecComMoreRefined{Chk,1}(1,3)):(HoldConnecComMoreRefined{Chk,1}(4,3)),...
    (HoldConnecComMoreRefined{Chk,1}(1,4)):(HoldConnecComMoreRefined{Chk,1}(4,4)));
[~,nCol] = size(ImgRef);



% aspectRatio = nRw/nCol;
% changedWidth = ceil(hghtTestComponent/aspectRatio);
% ImgRefNw = imresize(ImgRef,[hghtTestComponent changedWidth]);
% componentImgNw = imresize(componentImg,[hghtTestComponent changedWidth]);


aspectRatio = (abs(baseLineRef - topLineRef))/nCol; % The aspect ratio of the ref word, by considering only the base lines or body of word
changedWidth = ceil((abs(baseLineTest - topLineTest))/aspectRatio); % changed width of the ref word

ImgRefNwBody = imresize(ImgRef(topLineRef:baseLineRef,:),[(abs(baseLineTest - topLineTest)) changedWidth]);
componentImgNwBody = imresize(componentImg(topLineRef:baseLineRef,:),[(abs(baseLineTest - topLineTest)) changedWidth]);

if((l1Ref ~= topLineRef)&& (l4Ref ~= baseLineRef))
    
    changedHghtTop = round(((abs(baseLineTest - topLineTest))*(abs(l1Ref - topLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwTop = imresize(ImgRef(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    componentImgNwTop = imresize(componentImg(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    
    changedHghtBottom = round(((abs(baseLineTest - topLineTest))*(abs(l4Ref - baseLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwBottom = imresize(ImgRef(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    componentImgNwBottom = imresize(componentImg(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    
    changedImg = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImg(1:changedHghtTop,:) = ImgRefNwTop(:,:);
    changedImg(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = ImgRefNwBody(:,:);
    changedImg(((changedHghtTop+(abs(baseLineTest - topLineTest)))+1):...
        ((changedHghtTop+(abs(baseLineTest - topLineTest))))+changedHghtBottom,:) = ImgRefNwBottom(:,:);
    
    changedImgBin = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImgBin(1:changedHghtTop,:) = componentImgNwTop(:,:);
    changedImgBin(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = componentImgNwBody(:,:);
    changedImgBin(((changedHghtTop+(abs(baseLineTest - topLineTest)))+1):...
        ((changedHghtTop+(abs(baseLineTest - topLineTest))))+changedHghtBottom,:) = componentImgNwBottom(:,:);
elseif((l1Ref == topLineRef)&& (l4Ref ~= baseLineRef))

    
    changedHghtBottom = round(((abs(baseLineTest - topLineTest))*(abs(l4Ref - baseLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwBottom = imresize(ImgRef(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    componentImgNwBottom = imresize(componentImg(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    
    changedImg = zeros(((abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImg(topLineTest:baseLineTest,:) = ImgRefNwBody(:,:);

    changedImg((baseLineTest+1):(baseLineTest + changedHghtBottom),:) = ImgRefNwBottom(:,:);
    
    changedImgBin = zeros(((abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImgBin(topLineTest:baseLineTest,:) = componentImgNwBody(:,:);

    changedImgBin((baseLineTest+1):(baseLineTest + changedHghtBottom),:) = componentImgNwBottom(:,:);
    
elseif((l1Ref ~= topLineRef)&& (l4Ref == baseLineRef))
    
    changedHghtTop = round(((abs(baseLineTest - topLineTest))*(abs(l1Ref - topLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwTop = imresize(ImgRef(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    componentImgNwTop = imresize(componentImg(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    

    
    changedImg = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))),changedWidth);
    changedImg(1:changedHghtTop,:) = ImgRefNwTop(:,:);
    changedImg(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = ImgRefNwBody(:,:);

    
    changedImgBin = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))),changedWidth);
    changedImgBin(1:changedHghtTop,:) = componentImgNwTop(:,:);
    changedImgBin(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = componentImgNwBody(:,:);

elseif((l1Ref == topLineRef)&& (l4Ref == baseLineRef))
    changedImg = zeros((abs(baseLineTest - topLineTest)),changedWidth);
    changedImg(:,:) = ImgRefNwBody(:,:);

    
    changedImgBin = zeros((abs(baseLineTest - topLineTest)),changedWidth);
    changedImgBin(:,:) = componentImgNwBody(:,:);

end
%        componentWdth = ComponentHghtWdth(Chk,2);
[featureMat,lukUpTableForRealIndex] = GetFeatureOfComponentUpdated_2Exp(changedImgBin,changedImg);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HAVING THE SCOPE OF IMPROVEMENT AS THERE IS NO NEED TO STORE ALL THE CELL
% VALUE AS ALL THE VALUES ARE NOT USEFUL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FilteredConnectedCom{Cnt,1} = HoldConnecComMoreRefined{Chk,1};
FilteredConnectedCom{Cnt,2} = changedImg; % Storing by cutting with the proper boundary of the Component image
FilteredConnectedCom{Cnt,3} = featureMat;
FilteredConnectedCom{Cnt,4} = lukUpTableForRealIndex;

return;
end

