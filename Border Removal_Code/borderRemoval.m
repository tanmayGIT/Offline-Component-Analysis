function [beforeRLSA,afterVerticalRLSA,startText,horiRLSAThresh,verRLSAThresh] = borderRemoval(Img)


level = graythresh(Img);
%level = 0.6500;
Img1 = im2bw(Img,level);
% imwrite(Img1, 'E:\otsuImage.png');

% ImgNiBlack = niblack(Img);
% imwrite(ImgNiBlack, 'E:\niBlackImage.png');
% figure, imshow(Img1);


%% For Horizontal RLSA
% Inverting the image
Img1 = imcomplement(Img1);

beforeRLSA = ApplyMorphology(Img1,false);
[getAvgHeight,getAvgWidth]  = AnalyzeCharacterComponent(beforeRLSA);
horiRLSAThresh = ceil((getAvgHeight*50)/100);
verRLSAThresh = ceil((getAvgHeight*10)/100);

% generating histogram matrix
[nRw nCol] = size(Img1);
L_1 = ceil((nRw*2)/3);
L_2 = ceil((nRw*1)/50);
L_3 = ceil((nRw*1)/20);

nColOfKernel = 5;

histMat = zeros(nRw,nCol);
conditionFlagOfX0 = 0;

collectX0 = zeros((ceil(nCol/5)),1);
X0 = -1;
cnt = 1;
for j = 1:1:nCol % iterate for each column
    indexes = find(Img1(:,j));
    
    
    if((length(indexes)) > 1)
        nForeGrndPixels = length(indexes);
        histMat((nRw-(nForeGrndPixels-1)):nRw,j) = 1;
        
        if( ((j<=(ceil(nCol/5)))&&(nForeGrndPixels > L_3)) || ((j<=(ceil(nCol/5)))&&(nForeGrndPixels < L_2)) )
            
            collectX0(cnt,1) = j;
            conditionFlagOfX0 = 1;
            cnt = cnt +1;
        end
    end
end
if(conditionFlagOfX0 == 1) % if there is some unwanted tezt/portion at the left of the page then it will be detected.
    [~,~,nonZeroVal]= find(collectX0);
    X0 = min(nonZeroVal);
end

%% For getting the starting of the text in the image
if(conditionFlagOfX0 == 0)
    X0 = -1;
    X1 = -1;
    X2 = -1;
end

conditionFlagOfX1 = 0;
if(conditionFlagOfX0 ~= 0)
    for j = 1:1:(ceil(nCol/3)) % iterate for each column
        tempMat = histMat((nRw-(L_2-1)):nRw,j:(j+(nColOfKernel-1)));
        
        % checking if all the element in the first col of tempMat is 1 or not
        nElement_1st = find(tempMat(:,1));
        if(length(nElement_1st) == L_2)
            nElement_2nd = find(tempMat(:,2));
            nElement_3rd = find(tempMat(:,3));
            nElement_4th = find(tempMat(:,4));
            nElement_5th = find(tempMat(:,5));
            if(((isempty(nElement_2nd))||(length(nElement_2nd) < L_2))&&((isempty(nElement_3rd))||(length(nElement_3rd) < L_2))...
                    &&((isempty(nElement_4th))||(length(nElement_4th) < L_2))&&((isempty(nElement_5th))||(length(nElement_5th) < L_2)))
                if(j > X0)
                    X1 = j;
                    conditionFlagOfX1 = 1;
                    break;
                end
            end
        end
    end
end
if(conditionFlagOfX1 == 0)
    X0 = -1;
    X1 = -1;
    X2 = -1;
end

X2 = -1;
if(conditionFlagOfX1 ~= 0)
    for j = X1:1:(ceil(nCol/3)) % iterate for each column
        tempMat = histMat((nRw-(L_2-1)):nRw,j:(j+nColOfKernel-1));
        nElement_5th = find(tempMat(:,nColOfKernel));
        if(length(nElement_5th) == L_2)
            nElement_2nd = find(tempMat(:,2));
            nElement_3rd = find(tempMat(:,3));
            nElement_4th = find(tempMat(:,4));
            nElement_1st = find(tempMat(:,1));
            
            if(((isempty(nElement_2nd))||(length(nElement_2nd) < L_2))&&((isempty(nElement_3rd))||(length(nElement_3rd) < L_2))...
                    &&((isempty(nElement_4th))||(length(nElement_4th) < L_2))&&((isempty(nElement_1st))||(length(nElement_1st) < L_2)))
                
                if(j>X1)
                    X2 = j;
                    break;
                end
            end
        end
    end
end
startText = 1;
if(X0 == -1)
    startText = 1;
    
elseif(X2 == -1)
    startText = X0 + (ceil((X1 - X0)/2));
    
elseif(X2 ~= -1)
    startText = X1 + (ceil((X2 - X1)/2));
end

%% For getting the end of the text in the page
conditionFlagOfX3 = 0;
for j = ((ceil(nCol/2))+(ceil(nCol/4))):1:(nCol-(nColOfKernel-1)) % iterate for each column
    tempMatEnd = histMat((nRw-(L_2-1)):nRw,j:(j+nColOfKernel-1));
    
    % checking if all the element in the first col of tempMat is 1 or not
    nElement_1st = find(tempMatEnd(:,1));
    if(length(nElement_1st) == L_2)
        nElement_2nd = find(tempMatEnd(:,2));
        nElement_3rd = find(tempMatEnd(:,3));
        nElement_4th = find(tempMatEnd(:,4));
        nElement_5th = find(tempMatEnd(:,5));
        if(((isempty(nElement_2nd))||(length(nElement_2nd) < L_2))&&((isempty(nElement_3rd))||(length(nElement_3rd) < L_2))...
                &&((isempty(nElement_4th))||(length(nElement_4th) < L_2))&&((isempty(nElement_5th))||(length(nElement_5th) < L_2)))
            
            X3 = j;
            conditionFlagOfX3 = 1;
            break;
        end
    end
end
% endText = 0;
if(conditionFlagOfX3 == 1)
    endText = X3;
else
    endText = nCol;
end



%%
if(((size(Img1,2)) - endText) > 10)
    Img1 = Img1(:,startText:endText+10); % just to give some relaxation
else
    Img1 = Img1(:,startText:endText);
end

[nRwRefined nColRefined] = size(Img1);
horiHistMat = zeros(nRwRefined,nColRefined);

blackPixelMat = zeros((size(Img1,1)),1);
for p = 1:(size(Img1,1))
    indexes = find(Img1(p,:));
    blackPixelMat(p,1) = (length(indexes));
    if((length(indexes)) >= 1)
        nForeGrndPixels = length(indexes);
        horiHistMat(p,1:nForeGrndPixels) = 1;
        
    end
end
return;
end


function[BW2] =  ApplyMorphology(BW2,applyFlag)
% SE = strel('square', 3); % generating a structuring element of 3*3 square
% BW2 = bwmorph(BW2,'bridge');
% BW2 = bwmorph(BW2,'fill');
% BW2 = bwmorph(BW2,'majority');
BW2 = bwmorph(BW2,'clean');
% BW2 = bwmorph(BW2,'spur');

% if(applyFlag)
%     se = strel('line',6,90);
%     BW2 = imdilate(BW2,se);
% end
% BW2 = bwmorph(BW2,'majority');
BW2 = bwmorph(BW2,'clean');
% BW2 = bwmorph(BW2,'spur');
return;
end
% As in the undilated image, the same word can be conisdered as two seperate words in CC labelling
% so dilation is required, here we don't want to dilate original image,
% so we made a copy, CC labelling algo will run on the dilated image
% bwDilate = BW2;
% bwDilate = imclose(bwDilate,SE);  % Dilating with the structuring element
% figure,imshow(bwDilate);