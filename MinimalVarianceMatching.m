function [pathCost,path,indxcol,indxrow,distSum] = MinimalVarianceMatching(refSample,testSample,straight)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used for calculating Dynamic Time Warping between two
% sets of vectors. Each set can be thought of in a form of matrix where the
% rows of the matrix represents each seperate samples and cols represents
% the features extracted from each sample. So each row can be considered as
% seperate vector.

% Exam. below depicts exam. of samples & extracted features frm each sample

%-----------------------------------------  refSample  -----------------------------------------------
%            Feature1  Feature2    Feature3    Feature4    Feature5    Feature6    Feature7    Feature8
% Sample_1 -> 218.763   1383.23     2814.63     3698.46     283.366     398.209     554.283     344.022
% Sample_2 -> 1211.34   2271.84     3175.66     3887.79     688.329     394.739     438.149     548.188
% Sample_3 -> 944.728   2135.56     2698.35     3641.12     525.242     760.779     485.149     520.193
% Sample_4 -> 213.91    1280.9      2201.54     4396.4      580.349     571.959     589.167     516.748
% Sample_5 -> 782.347   1578.81     2562.91     3965.88     862.244     613.181     362.169     995.676
% Sample_6 -> 1177.65   2179.5      2787.38     4360.61     308.567     364.734     591.679     458.492
% Sample_7 -> 878.674   2224.2      2844.5      4427.47     708.421     241.865     357.375     242.539
% Sample_8 -> 625.975   2222.71     2971.39     4279.88     304.251     303.16      440.516     325.867
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------  testSample  -------------------------------------------------

%            Feature1  Feature2    Feature3    Feature4    Feature5    Feature6    Feature7    Feature8
% Sample_1 -> 288.813   2382.73     2694.47     3974.36     152.68      282.199     434.053     421.237
% Sample_2 -> 264.133   2290.89     2700.63     3919.16     131.615     839.425     222.812     508.723
% Sample_3 -> 264.274   2304.16     2707.82     3914.13     156.721     915.116     297.805     495.989
% Sample_4 -> 249.604   2188.2      2777.91     3882.64     124.841     776.532     163.761     405.021
% Sample_5 -> 242.457   2232.08     2763.96     3875.29     125.288     965.51      204.148     435.093
% Sample_6 -> 229.916   2300.28     2888.61     3930.54     139.239     545.863     589.41      872.219
% Sample_7 -> 216.683   2235.82     2819.21     4175.41     121.877     529.907     283.876     456.535
% Sample_8 -> 270.242   2312.01     2775.75     4016.54     203.384     623.547     251.015     352.289


%                -----------> Test sample 
% 
% Ref Sample |
%            |
%           \|/


[noOfSamplesInRefSample,N] =size(refSample);
[noOfSamplesInTestSample,M]=size(testSample);

if(noOfSamplesInRefSample == 0)
    disp('This is unwanted/unknown error');
end

if(N == M) % each set containing same no. of feature
    Dist = zeros(noOfSamplesInRefSample,noOfSamplesInTestSample); % Initializing the array
    pathCost = inf(noOfSamplesInRefSample,noOfSamplesInTestSample);
    path = zeros(noOfSamplesInRefSample,noOfSamplesInTestSample);
    for i=1:noOfSamplesInRefSample % xSize
        for j=1:noOfSamplesInTestSample %ySize
            total = zeros(N,1);
            for goFeature=1:N %or M as N & M are same
                total(goFeature,1) = (double((refSample(i,goFeature)-testSample(j,goFeature))^2));
            end
            
            Dist(i,j) = sqrt(sum(total));
        end
    end
    elasticity = (noOfSamplesInTestSample-noOfSamplesInRefSample); % noOfSamplesInTestSample is the number of
    % chracter in the test sample, which is always more than or equal to the number of
    % chracters in  the reference sample (noOfSamplesInRefSample)
    if(noOfSamplesInTestSample >= noOfSamplesInRefSample) % this condition k is satisfied only when the above statement
        % is satisfied
        for ji=1:1:(elasticity + 1)
            pathCost(1,ji) = ((Dist(1,ji)) * (Dist(1,ji)));
        end
        for i = 2:1:noOfSamplesInRefSample
            stopk = min((i-1+(elasticity)),noOfSamplesInTestSample);
            for k = i-1:1:stopk
                stopj = min(((k+1+elasticity)),noOfSamplesInTestSample);
                for j = (k+1):1:stopj
                    if ((pathCost(i,j)) > (pathCost(i-1,k) + ((Dist(i,j))^2)))
                        pathCost(i,j) = pathCost(i-1,k) + ((Dist(i,j))^2);
                        path(i,j) = k;
                    end
                end
            end
        end
    end
end

% collecting the indices of points on the cheapest path

minrow = noOfSamplesInRefSample;
% Since we are loking for the shortest path ending at some node in the last
% row r(m,j) = (j = m,....n). We just need to check th corresponding value in the pathcost, 
% the minimum value in this limited band is the particular matched column 
[~,indices] = min(pathCost(noOfSamplesInRefSample,noOfSamplesInRefSample:noOfSamplesInTestSample));
mincol = (noOfSamplesInRefSample-1)+indices;

indxcol = zeros(noOfSamplesInTestSample,1);
indxrow = zeros(noOfSamplesInRefSample,1);
cnt = 1;
while (minrow>1 && mincol>1)
    indxcol(cnt,1) = mincol;
    indxrow(cnt,1) = minrow;
   
    mincol = path(minrow,mincol);
    minrow = minrow-1; % as simply the row is decreasing and indicating the match 
    
    cnt = cnt + 1;
end

if(straight == 1) % reference word is smaller than the test word
end
if(straight == 2) % test word is smaller than the reference word
end
indxcol(cnt,1) = mincol;
indxrow(cnt,1) = minrow;
indxcol = indxcol(1:cnt);
indxrow = indxrow(1:cnt);

indxcol = flipdim(indxcol,1);
indxrow = flipdim(indxrow,1);

% distSum = 0;
% for pathSz=1:1:(size(indxcol,1))
%     distR = indxrow(pathSz,1);
%     distC = indxcol(pathSz,1);
%     distSum = distSum + Dist(distR,distC);
% end
distSum = pathCost(noOfSamplesInRefSample,((noOfSamplesInRefSample-1)+indices));
distSum = sqrt(distSum);
return
end