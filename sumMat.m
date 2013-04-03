function [summedMat] = sumMat(mat)
summedArr = zeros(1,(size(mat,2)));
for i=1:1:(size(mat,2))
    summedArr(1,i) = sum(mat(:,i));
    
end
summedMat = sum(summedArr);
return;
end