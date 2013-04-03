function [beforeRLSA,afterVerticalRLSA,startText,horiRLSAThresh,verRLSAThresh] = wordSpottingBasicOperation(Img)


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
% borderKernel = zeros(L_2,nColOfKernel);

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
            %         if ((j<=(ceil(nCol/5)))&&(nForeGrndPixels > L_2))
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
%         if(j>18)
%             disp('just check');
%         end
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
filteredImg = Img1;
% figure,imshow(Img1),impixelinfo;
% figure,imshow(histMat),impixelinfo;
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

% storLineIndex = zeros((size(blackPixelMat,1)),2); % the second cell will say whether his line is drawn or not
% cnt = 1;
% thresh = find(blackPixelMat<=10); % indexes of values less than 15, cell having 0 will also come
% nonZeroThresh = blackPixelMat(thresh,1); % getting the values at the indexes
% [~,~,nonZeroThresh] = find(nonZeroThresh);% removing zeros from the matrix
% threshVal = ceil(mean(nonZeroThresh)); % obtaining the threshold
% 
% mostProminentLine = zeros(size(blackPixelMat,1),3); % the first cell is the top line and second cell is the bottom line index
% enterFlag = 0;
% counter = 1;
% for p = 1:(size(blackPixelMat,1))
%     
%     
%     if(((blackPixelMat(p,1)) <= threshVal) && ((blackPixelMat(p,1)) >= 1) )
%         storLineIndex(cnt,1) = p;
%         if(cnt == 1)
%              Y = [p p];
%              X = [1 nColRefined];
%              line(X,Y);
%             storLineIndex(cnt,2) = -2; % mean this index is dran as line
%             lastDrawnLine = cnt;
%         end
%         
%         if(cnt > 1) % means alreay first line has been drawn
%             
%             getPreP = storLineIndex(lastDrawnLine,1);
%             
%             if((p - getPreP)>=(ceil((getAvgHeight*90)/100))) % greater than 80 % of average height
%                  Y = [p p];
%                  X = [1 nColRefined];
%                  line(X,Y);
%                 storLineIndex(cnt,2) = -2;% mean this index is dran as line
%                 if((cnt - lastDrawnLine) >= 1 )
%                     if(enterFlag == 0)
%                         mostProminentLine(1,1) = lastDrawnLine; % storing the top line
%                         mostProminentLine(1,2) = cnt; % storing the bottom line
%                         mostProminentLine(1,3) = 1;
%                         enterFlag = 1;
%                         counter = counter+1;
%                     end
%                     % first best segmented line
%                     %                     if((cnt - lastDrawnLine) == 1 )
%                     %                         mostProminentLine(1,1) = lastDrawnLine; % storing the top line
%                     %                         mostProminentLine(1,2) = cnt; % storing the bottom line
%                     %                         mostProminentLine(1,3) = 1;
%                     %                     elseif ((cnt - lastDrawnLine) == 2 )
%                     %                         mostProminentLine(end+1,1) = lastDrawnLine; % storing the top line
%                     %                         mostProminentLine(end+1,2) = cnt; % storing the bottom line
%                     %                         mostProminentLine(end+1,3) = 2;
%                     %                     elseif ((cnt - lastDrawnLine) == 3 )
%                     %                         mostProminentLine(end+1,1) = lastDrawnLine; % storing the top line
%                     %                         mostProminentLine(end+1,2) = cnt; % storing the bottom line
%                     %                         mostProminentLine(end+1,3) = 3;
%                     %                     elseif ((cnt - lastDrawnLine) == 4 )
%                     %                         mostProminentLine(end+1,1) = lastDrawnLine; % storing the top line
%                     %                         mostProminentLine(end+1,2) = cnt; % storing the bottom line
%                     %                         mostProminentLine(end+1,3) = 4;
%                     %                     elseif ((cnt - lastDrawnLine) == 5 )
%                     %                         mostProminentLine(end+1,1) = lastDrawnLine; % storing the top line
%                     %                         mostProminentLine(end+1,2) = cnt; % storing the bottom line
%                     %                         mostProminentLine(end+1,3) = 5;
%                     %                     else
%                     %                         mostProminentLine(end+1,1) = lastDrawnLine; % storing the top line
%                     %                         mostProminentLine(end+1,2) = cnt; % storing the bottom line
%                     %                         mostProminentLine(end+1,3) = (cnt - lastDrawnLine);
%                     %                     end
%                     if(enterFlag == 1)
%                         mostProminentLine(counter,1) = lastDrawnLine; % storing the top line
%                         mostProminentLine(counter,2) = cnt; % storing the bottom line
%                         mostProminentLine(counter,3) = (cnt - lastDrawnLine);
%                         counter = counter + 1;
%                     end
%                 end
%                 lastDrawnLine = cnt;
%                 
%             end
%         end
%         cnt = cnt +1;
%     end
%     
% end
% mostProminentLine = mostProminentLine(1:(counter-1),:);
% [~,Index] = sort(mostProminentLine(:,3));
% mostProminentLine = mostProminentLine(Index,:);
% bestLineIndex = mostProminentLine(1:(ceil(((size(mostProminentLine,1))*30)/100)),:);%taking top 30 % of element
% distHist = zeros(100,1);
% totalNoOfcom = 1;
% % whyDiff = 1;

storLineIndex = zeros((size(blackPixelMat,1)),3); % the second cell will say whether his line is drawn or not
cnt = 1;
thresh = find(blackPixelMat<=10); % indexes of values less than 15, cell having 0 will also come
nonZeroThresh = blackPixelMat(thresh,1); % getting the values at the indexes
[~,~,nonZeroThresh] = find(nonZeroThresh);% removing zeros from the matrix
threshVal = ceil(mean(nonZeroThresh)); % obtaining the threshold

mostProminentLine = zeros(size(blackPixelMat,1),3); % the first cell is the top line and second cell is the bottom line index
enterFlag = 0;
counter = 1;
for p = 1:(size(blackPixelMat,1))
    
    
    if(((blackPixelMat(p,1)) <= threshVal) && ((blackPixelMat(p,1)) >= 1) )
        
        % will enter here for one time only; so we get the first top line
        % index
        if(cnt == 1) % will enter here only when (blackPixelMat(p,1)) <= threshVal)  will satisfy
            storLineIndex(cnt,1) = p;
            storLineIndex(cnt,2) = p;
            storLineIndex(cnt,3) = 1; % mean this index is dran as line
            lastDrawnLine = cnt;
            cnt = cnt+1;      
        elseif(cnt > 1) % means alreay first line has been drawn 
            getPreP = storLineIndex(lastDrawnLine,2);
            if(((p - getPreP)>=(ceil((getAvgHeight*80)/100)))) % greater than 80 % of average height
%                 Y = [p p];
%                 X = [1 nColRefined];
%                 line(X,Y);
                storLineIndex(cnt,1) = getPreP;
                storLineIndex(cnt,2) = p;
                storLineIndex(cnt,3) = (p - getPreP);% mean this index is dran as line
                %                 if((cnt - lastDrawnLine) >= 1 )
                %                     if(enterFlag == 0)
                %                         mostProminentLine(1,1) = lastDrawnLine; % storing the top line
                %                         mostProminentLine(1,2) = cnt; % storing the bottom line
                %                         mostProminentLine(1,3) = 1;
                %                         enterFlag = 1;
                %                         counter = counter+1;
                %                     end
                %
                %                     if(enterFlag == 1)
                %                         mostProminentLine(counter,1) = lastDrawnLine; % storing the top line
                %                         mostProminentLine(counter,2) = cnt; % storing the bottom line
                %                         mostProminentLine(counter,3) = (cnt - lastDrawnLine);
                %                         counter = counter + 1;
                %                     end
                %                 end
                lastDrawnLine = cnt;
                cnt = cnt +1;
                
            end
            
        end
        
    end
    
end

if(~isempty(storLineIndex))
    storLineIndex = storLineIndex(1:(cnt-1),:);
    [~,Index] = sort(storLineIndex(:,3));
    storLineIndex = storLineIndex(Index,:);
    for bestLn = 2:1:size(Index,1) % running for all the lines; 1st row is ignored as it is just the top most line
         top = storLineIndex(bestLn,1);
         bottom = storLineIndex(bestLn,2);
         span = bottom - top;
         nSuchRow = 0;
         for inLine = top:1:bottom
             
             if(blackPixelMat(inLine,1) > getAvgWidth)
                 nSuchRow = nSuchRow +1;
             end
         end
         if(nSuchRow > ((span*80)/100))
             break
         end
    end
end
bestLineIndex = storLineIndex(bestLn,:);
distHist = zeros(100,1);
totalNoOfcom = 1;

for m = 1:1:size(bestLineIndex,1)
    top = bestLineIndex(m,1);
    bottom = bestLineIndex(m,2);
    croppedImg = Img1(top:bottom,1:nColRefined);
%     figure, imshow(croppedImg);
    analyzedCom = simpleAnalyzeComponent(croppedImg);
    %     holdMinCol = zeros((size(analyzedCom,1)),1);
    %     holdMaxCol = zeros((size(analyzedCom,1)),1);
    for n = 1:1:((size(analyzedCom,1))-1) % as we operate on next element also
        %         holdMinCol(n,1) = analyzedCom{n,1}(1,4);
        %         holdMaxCol(n,1) = analyzedCom{n,1}(4,4);
        maxColOfFirst = analyzedCom{n,1}(4,4);
        minColOfSecond = analyzedCom{n+1,1}(1,4);
        if(minColOfSecond > maxColOfFirst )
            dist = ceil(minColOfSecond - maxColOfFirst);
            if(dist <= 100)
                distHist(dist,1) = distHist(dist,1)+1;
                
                %             else
                %                 disp('I dont require you');
            end
            %             whyDiff = whyDiff + 1;
            totalNoOfcom = totalNoOfcom +1;
        end
        
    end
end


reqNoOfComponent = ceil((totalNoOfcom * 55)/100);
[sortedVal,Index] = sort(distHist,1,'descend');
cumuliSum = 0;
threshDist = 0;
for d = 1:1:(size(sortedVal,1))
    cumuliSum = cumuliSum + sortedVal(d,1);
    threshDist = threshDist + Index(d,1);
    if(cumuliSum >= reqNoOfComponent)
        break;
    end
end
RLSAThresh = ceil(threshDist/d);


% figure,imshow(horiHistMat),impixelinfo;


horiRLSAThresh = (horiRLSAThresh + RLSAThresh)/2;


parfor p=1:(size(Img1,1))
    Img1(p,:) = RLSATest(Img1(p,:),horiRLSAThresh);
end

% % For Vertical RLSA
% % Inverting the image
Img2 = Img1; % after horizontal RLSA

clear Img1;
parfor io=1:(size(Img2,2))
    RLSAmat = RLSATest((Img2(:,io))',verRLSAThresh);
    Img2(:,io) = RLSAmat';
end

afterVerticalRLSA = ApplyMorphology(Img2,true);
% afterVerticalRLSA = imcomplement(afterVerticalRLSA);
beforeRLSA = imcomplement(filteredImg);
% figure,imshow(afterVerticalRLSA);
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