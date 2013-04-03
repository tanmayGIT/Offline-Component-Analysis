% The code is about testing the OSB algorithm with a series of numbers


close all;
clc;
mat = [1 7 17 5 3 10;2 9 8 0 2 17;5 3 9 1 9 13;11 13 2 2 7 1;26 21 1 2 6 5];
[m n] = size(mat);
matxE = Inf(m+2,n+2);      %we add one row and one column to beginning and end of matx 
                           %to ensure that we can skip the first and last elements
matxE(2:m+1,2:n+1) = mat;
matxE(1,1) = 0;
matxE(m+2,n+2) = 0;
matx = matxE;
warpwin = 3;
queryskip = 3;
targetskip = 3;
[m,n] = size(matx); %this matx=matxE, thus it has one row an column more than the original matx above
weight = Inf(m,n); %the weight of the actually cheapest path
camefromcol = zeros(m,n); %the index of the parent col where the cheapest path came from
camefromrow = zeros(m,n); %the index of the parent row where the cheapest path came from

weight(1,:) = matx(1,:); %initialize first row
weight(:,1) = matx(:,1); %initialize first column

[m,n] = size(matx); 
for i = 1:m-1 %index over rows
    for j = 1:n-1 %index over columns
        if abs(i-j) <= warpwin %difference between i and j must be smaller than warpwin
            
            stoprowjump = min([m, i+queryskip]);
            stopk = min([n, j+targetskip]);
            
            for rowjump = i+1:stoprowjump %second index over rows
                
                for k = j+1:stopk %second index over columns
                    %newweight = ( weight(i,j) +  matx(rowjump,k) + sqrt((rowjump-i-1)^2+(k-j-1)^2)*jumpcost) ;
                    newweight = ( weight(i,j) +  matx(rowjump,k) + ((rowjump-i-1)+(k-j-1))*jumpcost) ; %we favor shorter jumps by multiplying by jummpcost
                    if weight(rowjump,k) > newweight
                        weight(rowjump,k) = newweight;
                        camefromrow(rowjump,k) = i;
                        camefromcol(rowjump,k) = j;
                    end
                end
            end
        end
    end
end

% collecting the indices of points on the cheapest path
pathcost = weight(m,n);   % pathcost: minimal value
mincol = n;
minrow = m;
indxcol = [];
indxrow = [];
while (minrow>1 && mincol>1)
    indxcol = [ mincol indxcol];
    indxrow = [ minrow indxrow];
    mincoltemp = camefromcol(minrow,mincol); % taking the temporary variable mincoltemp bcoz of in the next line we have to use original minrow & mincol
    minrow = camefromrow(minrow,mincol);
    mincol = mincoltemp;
end
indxcol = indxcol(1:end-1);
indxrow = indxrow(1:end-1);
indxcol = indxcol-1;
indxrow = indxrow-1;