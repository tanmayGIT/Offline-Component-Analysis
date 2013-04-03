function decision = callPrunningCopy(refImgRead,imageFolder_1,testImg)

% global dividedFeatureMat;
% global dividedPathMat;
% 
% 
% imagePathProb = dividedPathMat;
% segmentedDocImageSequence = dividedFeatureMat;





refImg = refImgRead;
level = graythresh(refImg);
Img1 = im2bw(refImg,level);
Img1 = imcomplement(Img1);
afterBinarizedRef = ApplyMorphology(Img1,false);

[rwRef colRef] = size(refImg);
diff1 = 0;
diff2 = 0;
topLineRef = 1;
bottomLineRef = rwRef;
horiHistMatRef = zeros(rwRef,1);

for p1 = 1:(size(afterBinarizedRef,1))
    indexes = find(afterBinarizedRef(p1,:));
    if((length(indexes)) >= 1)
        horiHistMatRef(p1,1) = (length(indexes));
    end
end
for t1 = 1:1:rwRef
    if((t1<(rwRef/2))&&(t1>1))
        if(horiHistMatRef(t1-1,1)>0)
            calDiff = sqrt((horiHistMatRef(t1,1)-horiHistMatRef(t1-1,1))^2);
            if(calDiff > diff1)
                diff1 = calDiff;
                topLineRef = t1;
            end
        end
    end
    if((t1>(rwRef/2))&&(t1<rwRef))
        calDiff = sqrt((horiHistMatRef(t1,1)-horiHistMatRef(t1+1,1))^2);
        if(horiHistMatRef(t1+1,1)>0)
            if(calDiff > diff2)
                diff2 = calDiff;
                bottomLineRef = t1;
            end
        end
    end
end


refFlag = 0;
totalComponentRef = 0;
if((rwRef - bottomLineRef) > 5)
    decenderRef = afterBinarizedRef(bottomLineRef:end,1:end);
    CCRef = bwconncomp(decenderRef);
    LRef = labelmatrix(CCRef);
    totalComponentRef = max(max(LRef));
    refFlag = 1; % if refFlag is 1 then decender is present otherwise not present
end

eachImg = 13;
% 
% for eachImg = 1:size(segmentedDocImageSequence,1)
%     if(~(isempty(segmentedDocImageSequence{eachImg,1}{1,3})))
%         testImg = imread(imagePathProb{eachImg,1});
        decision = performPrunning(refImgRead,testImg,2,1.5,imageFolder_1,refFlag,totalComponentRef,eachImg);
%     end
% end