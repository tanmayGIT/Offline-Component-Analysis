% Thsis function will calculate the features for the columns having forground pixels and it will skip the columns
% which does not have any forground pixel

% GetFeatureOfComponentUpdated_2 is different from
% GetFeatureOfComponentUpdated_1, as here the mid row feature is replaced
% by C.G of each col

function [refinedStorFearureMat,lukUpTableForRealIndex] = GetFeatureOfComponentUpdated_2(componentImg,fullImg)
% global Img;
[nRows,nCols] = size(componentImg);
storFeatureMat = zeros(nCols,14);
storTopIndex = Inf(nCols,3);
storBottomIndex = Inf(nCols,3);

storForeGroundCGforCol = zeros(nCols,2);
if(~isempty(componentImg))
    colIndexStorer = zeros(nCols,1);
    foreGroundColCnt = 0;
    
    for getCol = 1:1:nCols
        
        calTransition = 0;
        nEdgePixels = 0;
        pixelFlag = 0;
        sumEdgePixels = zeros(nRows,1);
        storRwColOfEdgePixels = zeros(nRows,2);
        for getRwPixels = 1:1:nRows % starting from minimum row to maximum row, sum all pixels in between them
            
            if((componentImg(getRwPixels,getCol)) == 0)
                
                if(pixelFlag == 0)
                    storTopIndex(getCol,1) = (getRwPixels); % storing the row
                    storTopIndex(getCol,2) = (getCol); % storing the col
                    storTopIndex(getCol,3) = (getRwPixels-1)^2; % as it is on the same col, so cols are not participated in disance calculation
                    pixelFlag = 1;
                    
                elseif(pixelFlag == 1)
                    storBottomIndex(getCol,1) = (getRwPixels); % storing the row
                    storBottomIndex(getCol,2) = (getCol); % storing the col
                    storBottomIndex(getCol,3) = (getRwPixels-nRows)^2;
                    
                end
                sumEdgePixels(getRwPixels,1) = (255 -  (fullImg(getRwPixels, getCol))); % for edge pixels only
                nEdgePixels = nEdgePixels + 1;
                storRwColOfEdgePixels(nEdgePixels,1) = getRwPixels;
                storRwColOfEdgePixels(nEdgePixels,2) = getCol;
                
                
            end
            
            
            if(getRwPixels> 1)
                if ((((componentImg((getRwPixels),(getCol))==0))&&...
                        ((componentImg(((getRwPixels)-1),(getCol))==1))))%||... AS WE WANT ONLY BACK GROUND TO INK TRANSITION
                    
                    calTransition = calTransition+1;
                end
            end
            
        end
        
        if(nEdgePixels > 0)
            storRwColOfEdgePixels = storRwColOfEdgePixels(1:(nEdgePixels),:);
            cgOfRw = (sum(storRwColOfEdgePixels(:,1))) /(size(storRwColOfEdgePixels,1));
            cgOfCol = (sum(storRwColOfEdgePixels(:,2))) /(size(storRwColOfEdgePixels,1));
            storForeGroundCGforCol(getCol,1) = round(cgOfRw);
            storForeGroundCGforCol(getCol,2) = round(cgOfCol);
        end
        
        if(nEdgePixels == 1) % If only one pixel exists in the col, then bottom pixel will also be same as top pixel
            storBottomIndex(getCol,1) = storTopIndex(getCol,1);
            storBottomIndex(getCol,2) = storTopIndex(getCol,2);
            storBottomIndex(getCol,3) = (getRwPixels-nRows)^2;
        end
      
        
        
        
        
    % the below if loop will only execute if there exists any fore ground pixel in the column    
        colVect = componentImg( 1:nRows, (getCol) ); % taking the particular column
        existanceOf_1 = find(colVect == 0);
        allRows = 1:nRows;
        if((size(existanceOf_1,1)) > 0) % if row pixels exists
            % as we only want to avoid the spacing between chracters
            foreGroundColCnt = foreGroundColCnt +1;
            
            myNume =  (sum (int32(255 - (fullImg(1:nRows, ( getCol))))));
            myDenom = max (int32(255 - (fullImg(1:nRows, ( getCol)))));
            sumAllPixels = (double(myNume)/double(myDenom));
            
            
            
            
            
            
            denomForNormalization = sum(int32(allRows));
            pixelsStat = (fullImg(1:nRows, getCol));
            colIndexStorer(foreGroundColCnt,1) = getCol;
            
            storFeatureMat(getCol,1) = sum(sumEdgePixels)/max(sumEdgePixels); % Sum of the intensity value of the edge pixels only in the particula col
            storFeatureMat(getCol,2) = sumAllPixels; % sum of the intensity value of all the pixels in a particular col
            storFeatureMat(getCol,3) = nEdgePixels; % Number of edge pixes present in the particular column
            storFeatureMat(getCol,6) = calTransition / 10; % storing the transition at each column;
            
            storFeatureMat(getCol,8) = std(double(pixelsStat));
         
            storFeatureMat(getCol,9) = skewness(double(pixelsStat));
      
            storFeatureMat(getCol,10) = kurtosis(double(pixelsStat));
     
            
            
            
            A = fullImg(1:nRows, getCol);
            [moo,mo1,n_pq] = cent_moment(0,2,A);
            
            
            sumEdgeVal_1stOrder = moo;
            sumEdgeVal_2ndOrder = mo1;
            
            
            storFeatureMat(getCol,11) = double( sumEdgeVal_1stOrder/denomForNormalization);
        
            storFeatureMat(getCol,12) = double( sumEdgeVal_2ndOrder/denomForNormalization);
  
            storFeatureMat(getCol,13) = n_pq; % central moments

        end
        
    end
    
    storForeGroundCGforCol = storForeGroundCGforCol(1:foreGroundColCnt,:);
    [nonZeroRw,~,~]  = find(storForeGroundCGforCol(:,1));
    for i=1:1:size(nonZeroRw,1)
        storFeatureMat((nonZeroRw(i,1)),7) = storForeGroundCGforCol((nonZeroRw(i,1)),1); % storing the C G for the each foreground column
        
        if(i > 1)
            cgIndex1 = (nonZeroRw(i,1));
            cgIndex2 = (nonZeroRw(i-1,1));
            if(((componentImg((storForeGroundCGforCol(cgIndex1,1)),(storForeGroundCGforCol(cgIndex1,2))) == 0) &&...
                    (componentImg((storForeGroundCGforCol(cgIndex2,1)),(storForeGroundCGforCol(cgIndex2,2))) == 1)) ||...
                    ((componentImg((storForeGroundCGforCol(cgIndex1,1)),(storForeGroundCGforCol(cgIndex1,2))) == 1) &&...
                    (componentImg((storForeGroundCGforCol(cgIndex2,1)),(storForeGroundCGforCol(cgIndex2,2))) == 0)))
                storFeatureMat(cgIndex1,14) = 1; % stroing the transition of the CG of each forground pixels in the column
            end
        end
    end
    
    
    storFeatureMat(:,4) = storTopIndex(:,3);% storing the upper profile; as we are calculating the
    storFeatureMat(:,4) = storFeatureMat(:,4)./(size(componentImg,1)); % for normalization dividing by height of the component                                                            % feature on component Image not on full image
    storFeatureMat(:,5) = storBottomIndex(:,3); % storing the lower profile;as we are calculating the
    storFeatureMat(:,5) = storFeatureMat(:,5)./(size(componentImg,1));% feature on component Image not on full image
    colIndexStorer = colIndexStorer(1:foreGroundColCnt,1);
    colIndexStorer = sort(colIndexStorer);
    noOfNonZeroCol = size(colIndexStorer,1);
    refinedStorFearureMat = zeros(noOfNonZeroCol,14);
    lukUpTableForRealIndex = zeros(noOfNonZeroCol,1);
    for h = 1:1:noOfNonZeroCol
        index = colIndexStorer(h,1);
        refinedStorFearureMat(h,:) = storFeatureMat(index,:);
        lukUpTableForRealIndex(h,1) = index;
        %          disp('I should be here');
        
    end
    for h = 1:1:noOfNonZeroCol
        for gh = 1:1:14
            val = refinedStorFearureMat(h,gh);
            if(isnan(val))
%                 disp('I should not be here');
                refinedStorFearureMat(h,gh) = 0;
            end
        end
    end
    
end
return;
end