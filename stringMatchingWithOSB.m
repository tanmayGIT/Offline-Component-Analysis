function [pathCost,distVal,getIntoCell,indexStorer] = stringMatchingWithOSB(refWordMat,testWordMat,realIndexRef,realIndexTest) % refCharWord is
% to which we are matching and testCharWord is with which we are matching
   getIntoCell = cell(1,2);
%   [distVal,wrappedPath] = DynamicTimeWarping(refWordMat,testWordMat);
%   getIntoCell{1,1} = wrappedPath(:,1); % indexRow;
%   getIntoCell{1,2} = wrappedPath(:,2); % indexCol;
%   pathCost = 0;
   sizeDifference = abs((size(refWordMat,1)) - (size(testWordMat,1)));
   
   warpwin = sizeDifference;
   queryskip = sizeDifference;
   targetskip = sizeDifference;
   
   [pathCost,distVal,indexRow,indexCol,indexStorer] = OSBv5(refWordMat,testWordMat,warpwin,queryskip,targetskip);
   indexRow = indexRow';
   indexCol = indexCol';
   
   updatedIndexRow = zeros((size(indexRow,1)),1);
   updatedIndexCol = zeros((size(indexCol,1)),1);
   for i=1:1:size(indexRow,1)
       val1 = indexRow(i,1);
       val2 = indexCol(i,1);
       updatedIndexRow(i,1) = realIndexRef(val1,1);
       updatedIndexCol(i,1) = realIndexTest(val2,1);
   end
   getIntoCell{1,1} =  updatedIndexRow;
   getIntoCell{1,2} =  updatedIndexCol;
 return;
end