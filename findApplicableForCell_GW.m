function [storIndexRowOfNonzeroElement,col,refinedStorNonzeroElement] = findApplicableForCell_GW(cellArr)
storIndexRowOfNonzeroElement = zeros((size(cellArr,1)),(size(cellArr,2)));

storNonzeroElement = cell((size(cellArr,1)),(size(cellArr,2)));
cnt = 1;
for i=1:1:(size(cellArr,1))
    
    if(~isempty(cellArr{i,1}))
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