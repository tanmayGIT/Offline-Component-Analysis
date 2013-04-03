function [FilteredConnectedCom] = simpleAnalyzeComponent(binarisedImg)
% binarisedImg = afterRLSARef;
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

holdMinColArr = zeros(totalComponent,2);
cnt = 1;
for AccesEachCell = 1:1:totalComponent
    if (size((HoldConnecCom{AccesEachCell,1}),1)>=30) % for ignoring the unnecessary component
        HoldConnecComRefined{cnt,1} = HoldConnecCom{AccesEachCell,1};
        % from the next statement we are getting the minimum row, i.e
        % minimum at the Y direction
        [minRow] = min(HoldConnecComRefined{cnt,1}(:,1));
        % now we will find out the minimum Col, i.e. in the X direction
        [minCol] = min(HoldConnecComRefined{cnt,1}(:,2));
        
        % for the top left most corner
        HoldConnecComRefined{cnt,1}(1,3) = minRow;%holding the min row; i.e. minimum at the Y direction
        HoldConnecComRefined{cnt,1}(1,4) = minCol;%holding the min value col; i.e. minimum at the X direction
        
        % for the top right most corner
        [maxCol] = max(HoldConnecComRefined{cnt,1}(:,2));
        % for the top right most corner
        HoldConnecComRefined{cnt,1}(2,3) = minRow;%holding the min value of row; i.e. minimum at the Y direction
        HoldConnecComRefined{cnt,1}(2,4) = maxCol;%holding the max value of col; i.e. minimum at the X direction
        
        %for the bottom left most corner from next statement we are getting the
        %maximum of row; i.e in the Y direction
        [maxRow] = max(HoldConnecComRefined{cnt,1}(:,1));
        
        HoldConnecComRefined{cnt,1}(3,3) = maxRow;%holding the max of row; i.e. in the Y direction
        HoldConnecComRefined{cnt,1}(3,4) = minCol;%holding the min of Col i.e. in the X direction
        
        %for the bottom right most corner
        HoldConnecComRefined{cnt,1}(4,3) = maxRow;%holding the max value of X coordinate
        HoldConnecComRefined{cnt,1}(4,4) = maxCol;%holding the max value of the Y coordinate
        
        holdMinColArr(cnt,1) = minCol;%keeping the minimum column
        holdMinColArr(cnt,2) = cnt; % keeping the index
        cnt = cnt+1;
          
    end
end

% for sorting the array from left to right

holdMinColArr = holdMinColArr(1:(cnt-1),:);% removing the zeros
[~,Index] = sort(holdMinColArr(:,1)); % sorting the array
holdMinColArr = holdMinColArr(Index,:);

if((cnt-1)<= (size(holdMinColArr,1)))       % p-1 bcoz of the last increment bfore leaving the loop
    HoldConnecComMoreRefined = cell((size(holdMinColArr,1)), 1);
    for getCell = 1:1:(size(holdMinColArr,1))
        sortedIndex = holdMinColArr(getCell,2); % getting the index
        HoldConnecComMoreRefined{getCell,1} = HoldConnecComRefined{sortedIndex,1};
    end
else
    HoldConnecComMoreRefined = HoldConnecComRefined;
end
clear HoldConnecComRefined;

FilteredConnectedCom = HoldConnecComMoreRefined;

return;
end

