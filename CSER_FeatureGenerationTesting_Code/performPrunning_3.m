function  [l1,l4,alfaU,alfaV,alternativeTopPt,alternativeBottomPt] = performPrunning_3(testImg)

[rwTest, colTest] = size(testImg);
% level = graythresh(testImg);
% Img1 = im2bw(testImg,level);
% Img1 = imcomplement(Img1);
Img1 = testImg;
afterBinarizedTest = ApplyMorphology(Img1,false);
horiHistMatTest = zeros(rwTest,colTest);
% horiHistMatTestCopy = zeros(rwTest,colTest);
S0Y = zeros(rwTest,1);
for p2 = 1:(size(afterBinarizedTest,1))
    indexes = find(afterBinarizedTest(p2,:));
    if((length(indexes)) >= 1)
        horiHistMatTest(p2,1:(length(indexes))) = 1;
        S0Y(p2,1) = (length(indexes));
    end
end
[indx] = find(S0Y(1:rwTest,1)); % getting rows which is having the value greater then 0
l1 = min(indx); % normally l1 will be the top row among them
[indx] = find(S0Y(1:rwTest,1));% getting rows which is having the value greater than 0
l4 = max(indx); % normally l4 will be the bottom most row among them
% l4 = l4 + ceil(rwTest/2);

avgForeGrndPixels = sum(S0Y(:,1))/size(indx,1);

% finding the peak point of histogram
[~, peakPt] = max(S0Y);



%finding the valley in between peakPt & l4
% the row containing minimum number of foreground pixels is l3
[row, ~, val] = find( S0Y(peakPt:l4,1) );
[~,indx] = min(val);
l3 = (peakPt-1) + row(indx,1);



%finding the valley in between l1 & peakPt
[row, ~, val] = find(S0Y(l1:peakPt,1));
[~, indx] = min(val);
l2 = (l1-1) + row(indx,1);
alternativeTopPt = 1; 
alternativeBottomPt  = 1;

minPixY =  l3;
for pt = l2:1:peakPt
    if((S0Y(pt,1) > avgForeGrndPixels)||(S0Y(pt,1) == avgForeGrndPixels))
        alternativeTopPt = pt;
        break;
    end
end
for pt = l3:-1:peakPt
    if((S0Y(pt,1) > avgForeGrndPixels)||(S0Y(pt,1) == avgForeGrndPixels))
        alternativeBottomPt = pt;
        break;
    end
end
avgPixY = alternativeBottomPt;
if((abs(minPixY - avgPixY))< (abs(avgPixY - alternativeTopPt)))
    alternativeBottomPt = minPixY;
else 
    alternativeBottomPt = avgPixY;
end

% dy = 4;
% if l1 and l2 is very close to each other
% if(((abs(l1-l2))<dy)&&((abs(l1-l2)) > -1)) % As the difference can be 0 also
%     l1 = l2 - max((l4-l3),(l3-l2));
%     if(l1<1)
%         l1 = 1;
%     end
% end
% % if l3 and l4 is very close to each other
% if(((abs(l3-l4))<dy) && ((abs(l3-l4))>-1)) % As the difference can be 0 also
%     l4 = l3 - max((l2-l1),(l3-l2));
%     if(l4>rwTest)
%         l4 = rwTest;
%     end
% end

diff1Test = 0;
diff2Test = 0;
topLineTest = 1;
bottomLineTest = rwTest;
delS = 1;
rotationAngle = 1;
FuAlfa = zeros((rotationAngle*2),1);
FvAlfa = zeros((rotationAngle*2),1);
cnt1 = 1;
cnt2 = 1;

% Finding for l2
% Finding for l3

% for rot = -rotationAngle:1:rotationAngle
%     rotatedImg = imrotate(afterBinarizedTest,rot);
%     [S0Y_U] = getHistogram(afterBinarizedTest);
    %     [rotRw rotCol] = size(rotatedImg);
    
    topLineArr = zeros((ceil(rwTest/1.5)),2);
    cnt1 = 1;
    for i = l1:1:(ceil(l2+((l3-l2)/2))) %ceil(rwTest/1.5)
        %         indexes1 = find(rotatedImg(i-1,:));
        %         if((S0Y_U(i-1,1)) > 0)
        % if(S0Y(t1-1,1)>0)
        %             indexes2 = find(rotatedImg(i,:));
        if((i>1) && (i<  (size(S0Y,1))  ))
            calDiff = sqrt((S0Y(i-1,1)-S0Y(i,1))^2);
%             if(calDiff > diff1Test)
%                 diff1Test = calDiff;
                topLineArr(cnt1,1) = calDiff;
                topLineArr(cnt1,2) = i;
%             end
            %         end
            cnt1 = cnt1 + 1;
        end
    end
    
    [~,indx] = sort(topLineArr(:,1),'descend');
    topLineArr = topLineArr(indx,:); 
%     FuAlfa(cnt1,1) = topLineTest;
    bottomLineArr = zeros((l4 - (ceil(rwTest/2))),2);
    cnt2 = 1;
    for j = (ceil(l2+((l3-l2)/2)))+1:1:l4
        %         indexes1 = find(S0Y_V(i-1,:));
        %         if((length(indexes1)) > 0)
        % if(S0Y(t1-1,1)>0)
        %             indexes2 = find(S0Y_V(i,:));
        if((j>1)&& (j<  (size(S0Y,1))  ))
            calDiff = sqrt((S0Y(j-1,1)-S0Y(j,1))^2);
%             if(calDiff > diff2Test)
                bottomLineArr(cnt2,1) = calDiff;
                bottomLineArr(cnt2,2) = j;
%             end
        end
        cnt2 = cnt2+1;
        %         end
    end
    [~,indx1] = sort(bottomLineArr(:,1),'descend');
    bottomLineArr = bottomLineArr(indx1,:); 
%     FvAlfa(cnt1,1) = bottomLineTest;
%     cnt1 = cnt1+1;
%     cnt2 = cnt2+1;
% disp(rot);
% end
distInitial = rwTest;
distBelow = rwTest;
myBottom = 1;
myTop = 1;
for u = 1:1:3
    dist1 = abs(topLineArr(u,2) - (ceil(rwTest/2)));
    dist2 = abs(bottomLineArr(u,1) - rwTest);
    if(dist1 < distInitial)
        distInitial = dist1;
        myTop = u;
    end
    if(dist2 < distBelow)
        distBelow = dist1;
        myBottom = u;
    end
end


% for rot = -rotationAngle:1:rotationAngle
%     rotatedImg = imrotate(afterBinarizedTest,rot);
%     [S0Y_V] = getHistogram(rotatedImg);
%     %     [rotRw rotCol] = size(rotatedImg);
%     for i = (ceil(l2+((l3-l2)/2))):1:l4
%         %         indexes1 = find(S0Y_V(i-1,:));
%         %         if((length(indexes1)) > 0)
%         % if(S0Y(t1-1,1)>0)
%         %             indexes2 = find(S0Y_V(i,:));
%         if(i>1)
%             calDiff = sqrt((S0Y_V(i-1,1)-S0Y_V(i,1))^2);
%             if(calDiff > diff1Test)
%                 diff1Test = calDiff;
%                 bottomLineTest = i;
%             end
%         end
%         %         end
%     end
%     FvAlfa(cnt2,1) = bottomLineTest;
%     cnt2 = cnt2+1;
% end
alfaU = topLineArr(myTop,2);%max(FuAlfa);
alfaV = bottomLineArr(myBottom,2);%max(FvAlfa);
end

function [S0Y] = getHistogram(binImg)
[rwTest ~] = size(binImg);
% horiHistMatTest = zeros(rwTest,colTest);
% horiHistMatTestCopy = zeros(rwTest,colTest);
S0Y = zeros(rwTest,1);
for p2 = 1:(size(binImg,1))
    indexes = find(binImg(p2,:));
    if((length(indexes)) >= 1)
        % horiHistMatTest(p2,1:(length(indexes))) = 1;
        S0Y(p2,1) = (length(indexes));
    end
end
return
end
