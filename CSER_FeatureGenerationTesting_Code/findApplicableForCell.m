function [storIndexRowOfNonzeroElement,col,refinedStorNonzeroElement] = findApplicableForCell(cellArr)
storIndexRowOfNonzeroElement = zeros((size(cellArr,1)),1);

storNonzeroElement = cell((size(cellArr,1)),1);
cnt = 1;
for i=1:1:(size(cellArr,1))
    
    if(~isempty(cellArr{i,1}))
        storIndexRowOfNonzeroElement(cnt,1) = i;
        storNonzeroElement{cnt,1} = cellArr{i,1};
        cnt = cnt+1;
    end
    
end
storIndexRowOfNonzeroElement = storIndexRowOfNonzeroElement((1:cnt-1),1);
refinedStorNonzeroElement = cell((cnt-1),1);
for p = 1:1:(cnt-1)
    refinedStorNonzeroElement{p,1} = storNonzeroElement{p,1};
end
col = 1;

return
end