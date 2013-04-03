% function [decision] = performPrunning(refImg,testImg,beta,delta,imageFilePath_3,refFlag,totalComponentRef,cnt)
 function  [decision] = performPrunning(refImg,testImg,beta,delta,imageFilePath_3,cnt)
% decision = 0;
path = [imageFilePath_3 'prunned' '/'];
if((exist(path,'dir'))==0)
    mkdir(path);
end
[rwRef colRef] = size(refImg);
[rwTest colTest] = size(testImg);

refArea = rwRef * colRef;
testArea = rwTest * colTest;

refAspect = rwRef/colRef;
testAspect = rwTest/colTest;

decision = 0;
% if(((1/alfa)<(colRef/colTest)<alfa)||(colRef == alfa))
 if((((ceil(colRef*70)/100)) <= colTest)||(((colRef+(ceil(colRef*55)/100)) >= colTest)&&(colTest>colRef)))
% if (  ( (1/beta)<=(refArea/testArea)  ) && ( (refArea/testArea)<=(beta) )  )
%     if (   (  (1/delta)<=(refAspect/testAspect)  ) &&  ( (refAspect/testAspect)<=(delta) ) )
        
            
%             level = graythresh(testImg);
%             Img1 = im2bw(testImg,level);
%             Img1 = imcomplement(Img1);
%             afterBinarizedTest = ApplyMorphology(Img1,false);
%             horiHistMatTest = zeros(rwTest,colTest);
%             
%             for p2 = 1:(size(afterBinarizedTest,1))
%                 indexes = find(afterBinarizedTest(p2,:));
%                 if((length(indexes)) >= 1)
%                     horiHistMatTest(p2,1) = (length(indexes));
%                 end
%             end
%             
%             %             midRef = ceil((topLineRef + bottomLineRef)/2);
%             
%             
%             diff1Test = 0;
%             diff2Test = 0;
%             topLineTest = 1;
%             bottomLineTest = rwTest;
%             
%             for t1 = 1:1:rwTest
%                 if((t1<(rwTest/2))&&(t1>1))
%                     if(horiHistMatTest(t1-1,1)>0)
%                         calDiff = sqrt((horiHistMatTest(t1,1)-horiHistMatTest(t1-1,1))^2);
%                         if(calDiff > diff1Test)
%                             diff1Test = calDiff;
%                             topLineTest = t1;
%                         end
%                     end
%                 end
%                 if((t1>(rwTest/2))&&(t1<rwTest))
%                     calDiff = sqrt((horiHistMatTest(t1,1)-horiHistMatTest(t1+1,1))^2);
%                     if(horiHistMatTest(t1+1,1)>0)
%                         if(calDiff > diff2Test)
%                             diff2Test = calDiff;
%                             bottomLineTest = t1;
%                         end
%                     end
%                 end
%             end
%             testFlag = 0;
%             if((rwTest - bottomLineTest) > 5)
%                 decenderTest = afterBinarizedTest(bottomLineTest:end,1:end);
%                 CCTest = bwconncomp(decenderTest);
%                 LTest = labelmatrix(CCTest);
%                 totalComponentTest = max(max(LTest));
%                 testFlag = 1;
%             end
%          if((refFlag == 1)&&(totalComponentRef > 0))%refernce having decender   
%             if(testFlag == 1)% decender is present in both word
%                 if((totalComponentTest > totalComponentRef)||(totalComponentTest == totalComponentRef)||(totalComponentTest < totalComponentRef))
%                     decision = 1;
%                     imwrite(testImg,[path, (int2str(cnt)) '.jpg']);
%                 end
%             end
%             
            %             midTest = ceil((topLineTest + bottomLineTest)/2);
            %             centralLineTest = ceil(nRowTest/2);
            %
            %             midRef = ceil((topLineRef + bottomLineRef)/2);
            %             centralLineRef = ceil(nRowRef/2);
            
            %             vTest_1 = afterBinarizedTest(topLineTest,1:end);
            %             nTransTest1 = calculateTrans(vTest_1);
            %             vTest_2 = afterBinarizedTest(centralLineTest,1:end);
            %             nTransTest2 = calculateTrans(vTest_2);
            %             vTest_3 = afterBinarizedTest(midTest,1:end);
            %             nTransTest3 = calculateTrans(vTest_3);
            %             vTest_4 = afterBinarizedTest(bottomLineTest,1:end);
            %             nTransTest4 = calculateTrans(vTest_4);
            %
            %             vRef_1 = afterBinarizedRef(topLineRef,1:end);
            %             nTransRef1 = calculateTrans(vRef_1);
            %             vRef_2 = afterBinarizedRef(centralLineRef,1:end);
            %             nTransRef2 = calculateTrans(vRef_2);
            %             vRef_3 = afterBinarizedRef(midRef,1:end);
            %             nTransRef3 = calculateTrans(vRef_3);
            %             vRef_4 = afterBinarizedRef(bottomLineRef,1:end);
            %             nTransRef4 = calculateTrans(vRef_4);
            
%          elseif(testFlag == 0) % reference image do not have decenders and test image do not have desenders
             decision = 1;
%             imwrite(testImg,[path, (int2str(cnt)) '.jpg']);
%          elseif (testFlag == 1)% reference image do not have decenders and test image have desenders
%              decision = 0;
%         end
    end
end
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
