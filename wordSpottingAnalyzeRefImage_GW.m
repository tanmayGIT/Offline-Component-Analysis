function [FilteredConnectedCom] =  wordSpottingAnalyzeRefImage_GW(Img,testImgHght)

level = graythresh(Img);
Img1 = im2bw(Img,level);
Img1 = imcomplement(Img1);
afterBinarized = ApplyMorphology(Img1,false);

CC = bwconncomp(afterBinarized);
L = labelmatrix(CC);


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

ComponentHghtWdth = zeros(totalComponent,1);
%HoldConnecCom1  = nan{Mx, 1};
progressbar([],[],0)

globalMinRow = size(Img,1);
globalMinCol = size(Img,2);
globalMaxRow = 0;
globalMaxCol = 0;

for AccesEachCell = 1:1:totalComponent
    if (size((HoldConnecCom{AccesEachCell,1}),1)>=15) % for ignoring the unnecessary component
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
        
        if(minRow <globalMinRow)
            globalMinRow = minRow;
        end
        if(minCol <globalMinCol)
            globalMinCol = minCol;
        end
        if(maxRow >globalMaxRow)
            globalMaxRow = maxRow;
        end
        if(maxCol >globalMaxCol)
            globalMaxCol = maxCol;
        end
        % Calculating the height of the component
        Hght = Y(2)-Y(1);
        if ((Hght>0)&&(Wdth>0))
            
            % for eliminating those component whose height & width don't overcome
            % the threshold parameter.
            ComponentHghtWdth(p,1) = Hght; % storing component height
            
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


% fullImg = Img;


Cnt = 1;
FilteredConnectedCom = cell(1, 4);
% where FilteredConnectedCom will satisfy the above given condition
comSz = zeros((size(ComponentHghtWdth,1)),1);
for Chk = 1:1:size(ComponentHghtWdth,1)
    comSz(Chk,1) = size((HoldConnecComMoreRefined{Chk,1}),1);
end
[~,maxIndx] = max(comSz);

Chk = maxIndx;

componentImg = afterBinarized(globalMinRow:globalMaxRow,globalMinCol:globalMaxCol);

ImgRef = Img(globalMinRow:globalMaxRow,globalMinCol:globalMaxCol);

[nRw nCol] = size(ImgRef);
aspectRatio = nRw/nCol;
% nwWidth = testImgHght/aspectRatio;
% nwImgRef = imresize(ImgRef, [testImgHght nwWidth],'bilinear');
% nwComponentImg = imresize(componentImg, [testImgHght nwWidth],'bilinear');
[featureMat,lukUpTableForRealIndex] = GetFeatureOfComponentUpdated_2Exp(componentImg,ImgRef);


FilteredConnectedCom{Cnt,1} = HoldConnecComMoreRefined{Chk,1};
FilteredConnectedCom{Cnt,2} = ImgRef; % Storing by cutting with the proper boundary of the Component image
FilteredConnectedCom{Cnt,3} = featureMat;
FilteredConnectedCom{Cnt,4} = lukUpTableForRealIndex;


return;
end


function[BW2] =  ApplyMorphology(BW2,applyFlag)
% SE = strel('square', 3); % generating a structuring element of 3*3 square
% BW2 = bwmorph(BW2,'bridge');
% BW2 = bwmorph(BW2,'fill');
BW2 = bwmorph(BW2,'majority');
BW2 = bwmorph(BW2,'clean');
BW2 = bwmorph(BW2,'spur');

% if(applyFlag)
%     se = strel('line',6,90);
%     BW2 = imdilate(BW2,se);
% end
BW2 = bwmorph(BW2,'majority');
BW2 = bwmorph(BW2,'clean');
BW2 = bwmorph(BW2,'spur');
return;
end