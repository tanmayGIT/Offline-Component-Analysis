function [pathCost,distVal,getIntoCell] = stringMatchingWithMVM(refWordMat,testWordMat,realIndexRef,realIndexTest) % refCharWord is
% to which we are matching and testCharWord is with which we are matching
getIntoCell = cell(1,2);

if((size(refWordMat,1)) < (size(testWordMat,1)))
    straight = 1;
    [pathCost,~,indexCol,indexRow,distVal] = MinimalVarianceMatching(refWordMat,testWordMat,straight);
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
else
%     just reversing the logic to handle the problem, if reference word is bigger than the test word
     straight = 2;
    [pathCost,~,indexCol,indexRow,distVal] = MinimalVarianceMatching(testWordMat,refWordMat,straight);
%     so for this case indexRow will orginally will refer to the test word and indexCol is to the reference word
%     so we will just swap the two array
    tempIndexRow = indexRow;
    indexRow = indexCol;
    indexCol = tempIndexRow;
    
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
    
end

return;
end