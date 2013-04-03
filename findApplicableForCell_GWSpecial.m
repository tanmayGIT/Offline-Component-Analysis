function [storIndexRowOfNonzeroElement,col,refinedStorNonzeroElement,nwIndexArr] = findApplicableForCell_GWSpecial(cellArr,indexArr)
storIndexRowOfNonzeroElement = zeros((size(cellArr,1)),(size(cellArr,2)));
nwIndexArr = zeros(length(indexArr),1);
storNonzeroElement = cell((size(cellArr,1)),(size(cellArr,2)));
cnt = 1;
cnt2 = 1;
for i=1:1:(size(cellArr,1))
    
    if(~isempty(cellArr{i,1}))
        if(~isempty(find(indexArr == i)))
           nwIndexArr(cnt2,1) = cnt; 
           cnt2 = cnt2 +1;
        end
        storIndexRowOfNonzeroElement(cnt,1) = i;
        for j=1:1:(size(cellArr,2))
            storNonzeroElement{cnt,j} = cellArr{i,j};
        end
        cnt = cnt+1;
    end
    
end
storIndexRowOfNonzeroElement = storIndexRowOfNonzeroElement((1:cnt-1),1);
refinedStorNonzeroElement = cell((cnt-1),(size(cellArr,2)));
for p = 1:1:(cnt-1)
    for j=1:1:(size(cellArr,2))
        refinedStorNonzeroElement{p,j} = storNonzeroElement{p,j};
    end
end
col = 1;

return
end