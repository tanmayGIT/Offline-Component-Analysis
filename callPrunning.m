function callPrunning(refImgRead,imageFolder_1,sameImgNameMat)

global dividedFeatureMat;
global dividedPathMat;


imagePathProb = dividedPathMat;
segmentedDocImageSequence = dividedFeatureMat;





refImg = refImgRead;
% level = graythresh(refImg);
% Img1 = im2bw(refImg,level);
% Img1 = imcomplement(Img1);
% afterBinarizedRef = ApplyMorphology(Img1,false);
% 
% [rwRef colRef] = size(refImg);
% diff1 = 0;
% diff2 = 0;
% topLineRef = 1;
% bottomLineRef = rwRef;
% horiHistMatRef = zeros(rwRef,1);
% 
% for p1 = 1:(size(afterBinarizedRef,1))
%     indexes = find(afterBinarizedRef(p1,:));
%     if((length(indexes)) >= 1)
%         horiHistMatRef(p1,1) = (length(indexes));
%     end
% end
% for t1 = 1:1:rwRef
%     if((t1<(rwRef/2))&&(t1>1))
%         if(horiHistMatRef(t1-1,1)>0)
%             calDiff = sqrt((horiHistMatRef(t1,1)-horiHistMatRef(t1-1,1))^2);
%             if(calDiff > diff1)
%                 diff1 = calDiff;
%                 topLineRef = t1;
%             end
%         end
%     end
%     if((t1>(rwRef/2))&&(t1<rwRef))
%         calDiff = sqrt((horiHistMatRef(t1,1)-horiHistMatRef(t1+1,1))^2);
%         if(horiHistMatRef(t1+1,1)>0)
%             if(calDiff > diff2)
%                 diff2 = calDiff;
%                 bottomLineRef = t1;
%             end
%         end
%     end
% end
% 
% 
% refFlag = 0;
% totalComponentRef = 0;
% if((rwRef - bottomLineRef) > 5)
%     decenderRef = afterBinarizedRef(bottomLineRef:end,1:end);
%     CCRef = bwconncomp(decenderRef);
%     LRef = labelmatrix(CCRef);
%     totalComponentRef = max(max(LRef));
%     refFlag = 1; % if refFlag is 1 then decender is present otherwise not present
% end

% eachImg = 13;
countEqual = 1;
equalFlag = 0;
prunnedFeatureMat = cell((size(segmentedDocImageSequence,1)),(size(segmentedDocImageSequence,2)));
prunnedImgPath = cell((size(segmentedDocImageSequence,1)),1);
normatCnt = 1;

getSameImdex = zeros((size(sameImgNameMat,1)),1);
for eachImg = 1:size(segmentedDocImageSequence,1)
    if(~(isempty(segmentedDocImageSequence{eachImg,1}{1,3})))
        testImg = imread(imagePathProb{eachImg,1});
%          decision = performPrunning(refImgRead,testImg,2,1.5,imageFolder_1,refFlag,totalComponentRef,eachImg);
          decision = performPrunning(refImgRead,testImg,1.5,2,imageFolder_1,eachImg);
        if(decision == 1)
             [~, nameTest, ~] = fileparts(imagePathProb{eachImg,1});
            prunnedFeatureMat{normatCnt,:} = segmentedDocImageSequence{eachImg,:};
            prunnedImgPath{normatCnt,1} = imagePathProb{eachImg,1};
             for t = 1:1:(size(sameImgNameMat,1))
                 [~, nameSame, ~] = fileparts(sameImgNameMat{t,1});
                 if(strcmp(nameTest,nameSame))
                     getSameImdex(countEqual,1) = normatCnt; % this indexes holding the same image
                     countEqual = countEqual +1;
                 end
             end
            if(countEqual == (size(sameImgNameMat,1)) )
%                 disp('I have full match');
                equalFlag = 1;
%             else
%                 disp('I do not have full match');
            end
            normatCnt = normatCnt+1;
        end
    end
end
[~,~,prunnedFeatureMat] = findApplicableForCell_GW(prunnedFeatureMat);
[~,~,prunnedImgPath] = findApplicableForCell_GW(prunnedImgPath);
dividedFeatureMat = prunnedFeatureMat;
dividedPathMat = prunnedImgPath;
performOfflineTest_GW(refImg,imageFolder_1,getSameImdex);

if(equalFlag == 1)
   disp('I have full match'); 

elseif(equalFlag == 0)
    disp(imageFolder_1);
    disp('I do not have full match');
end