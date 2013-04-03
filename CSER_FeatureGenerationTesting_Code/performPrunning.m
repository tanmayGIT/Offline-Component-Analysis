function  [topLineTest,bottomLineTest] = performPrunning(testImg,cnt)
% imageFilePath_3 = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/dickDoom/AllComponents/Francois/';
% path = [imageFilePath_3 'prunned' '/'];
% if((exist(path,'dir'))==0)
%     mkdir(path);
% end
% decision = 0;
[rwTest, colTest] = size(testImg);
level = graythresh(testImg);
Img1 = im2bw(testImg,level);
Img1 = imcomplement(Img1);
afterBinarizedTest = ApplyMorphology(Img1,false);
horiHistMatTest = zeros(rwTest,colTest);

for p2 = 1:(size(afterBinarizedTest,1))
    indexes = find(afterBinarizedTest(p2,:));
    if((length(indexes)) >= 1)
        horiHistMatTest(p2,1) = (length(indexes));
    end
end

%             midRef = ceil((topLineRef + bottomLineRef)/2);


diff1Test = 0;
diff2Test = 0;
topLineTest = 1;
bottomLineTest = rwTest;

for t1 = 1:1:rwTest
    if((t1<(rwTest/2))&&(t1>3))
        if(horiHistMatTest(t1-1,1)>0)
            calDiff = sqrt((horiHistMatTest(t1,1)-horiHistMatTest(t1-1,1))^2);
            if(calDiff > diff1Test)
                diff1Test = calDiff;
                topLineTest = t1;
            end
        end
    end
    if((t1>(rwTest/2))&&(t1<rwTest-2))
        calDiff = sqrt((horiHistMatTest(t1,1)-horiHistMatTest(t1+1,1))^2);
        if(horiHistMatTest(t1+1,1)>0)
            if(calDiff > diff2Test)
                diff2Test = calDiff;
                bottomLineTest = t1;
            end
        end
    end
end
% testFlag = 0;
% if(((rwTest - bottomLineTest) > 5)&&(topLineTest > 2)) % if the bottomLineTest is atleast a bit less than total number of col

%     CCTest = bwconncomp(decenderTest);
%     LTest = labelmatrix(CCTest);
%     totalComponentTest = max(max(LTest));
%     testFlag = 1;
% end

% [~, nCol, numberOfColorChannels] = size(afterBinarizedTest);
% if numberOfColorChannels == 1
%     % It's monochrome, so convert to color.
%     afterBinarizedTest = cat(3, afterBinarizedTest, afterBinarizedTest, afterBinarizedTest);
% end
% for pt =1:1:nCol
%     afterBinarizedTest(bottomLineTest,pt,1) = 255;
%     afterBinarizedTest(bottomLineTest,pt,2) = 0;
%     afterBinarizedTest(bottomLineTest,pt,3) = 0;
%     afterBinarizedTest(topLineTest,pt,1) = 0;
%     afterBinarizedTest(topLineTest,pt,2) = 255;
%     afterBinarizedTest(topLineTest,pt,3) = 0;
% end


% imwrite(afterBinarizedTest,[path, (int2str(cnt)) '.jpg']);




% if((refFlag == 1)&&(totalComponentRef > 0))% refernce having decender
%     if(testFlag == 1)% decender is present in both word
%         if((totalComponentTest > totalComponentRef)||(totalComponentTest == totalComponentRef)||(totalComponentTest < totalComponentRef))
%             decision = 1;
%             imwrite(testImg,[path, (int2str(cnt)) '.jpg']);
%         end
%     end
%
%     midTest = ceil((topLineTest + bottomLineTest)/2);
%     centralLineTest = ceil(nRowTest/2);
%
%     midRef = ceil((topLineRef + bottomLineRef)/2);
%     centralLineRef = ceil(nRowRef/2);

%     vTest_1 = afterBinarizedTest(topLineTest,1:end);
%     nTransTest1 = calculateTrans(vTest_1); % calculate number of transition at accender
%     vTest_2 = afterBinarizedTest(centralLineTest,1:end);
%     nTransTest2 = calculateTrans(vTest_2); % calculate number of transition at middle row of test image
%     vTest_3 = afterBinarizedTest(midTest,1:end);
%     nTransTest3 = calculateTrans(vTest_3);  % calculate number of transition at middle row of ref image
%     vTest_4 = afterBinarizedTest(bottomLineTest,1:end);
%     nTransTest4 = calculateTrans(vTest_4);
%
%     vRef_1 = afterBinarizedRef(topLineRef,1:end);
%     nTransRef1 = calculateTrans(vRef_1);
%     vRef_2 = afterBinarizedRef(centralLineRef,1:end);
%     nTransRef2 = calculateTrans(vRef_2);
%     vRef_3 = afterBinarizedRef(midRef,1:end);
%     nTransRef3 = calculateTrans(vRef_3);
%     vRef_4 = afterBinarizedRef(bottomLineRef,1:end);
%     nTransRef4 = calculateTrans(vRef_4);

% elseif(testFlag == 0) % reference image do not have decenders and test image do not have desenders
%     decision = 1;
%     imwrite(testImg,[path, (int2str(cnt)) '.jpg']);
% elseif (testFlag == 1)% reference image do not have decenders and test image have desenders
%     decision = 0;
% end

% end
% end
% function nTrans = calculateTrans(vect)
% nTrans = 0;
% for k = 1:1:(length(vect))-1
%     if(((vect(1,k)==0)&&(vect(1,k) == 1))||((vect(1,k)==1)&&(vect(1,k) == 0)))
%         nTrans = nTrans +1;
%     end
% end
% end
