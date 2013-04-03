%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is for drawing the acsender and descender on each segmented out
% word images kept in a folder and save it in a seperate folder.

% Input Argument: User have to select the folder having the component image

% Output Argument : The seperate folder will be created containing the drawn
% ascender and descender on the image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

dirOutput = uigetdir('/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/dickDoom/ComponentsImage/','Select a folder');
files = dir(fullfile(dirOutput, '*.jpg'));
fileNamesRef = {files.name}';
imgPathRef = strcat(dirOutput,'/');
nImagesRef = (length(fileNamesRef));

imageFilePath_3 = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/dickDoom/AllComponents/Francois/';
path = [imageFilePath_3 'prunned' '/'];
if((exist(path,'dir'))==0)
    mkdir(path);
end


for goEachRefImg = 1:1:nImagesRef
    imageFilePathRef = [imgPathRef,fileNamesRef{goEachRefImg}];
    [~, refName, refExt] = fileparts(imageFilePathRef);
    
    ImgRef = imread(imageFilePathRef);
    if(size(ImgRef,3)==3)
        ImgRef = rgb2gray(ImgRef);
    end
    
    ImgRef = uint8(ImgRef);
    [nRow nCol] = size(ImgRef);
    
    % As the average character width is seen to be 30, if we can find it we
    % will use it
    
    afterBinarizedTest = zeros(nRow,nCol);
    if(nCol > (3*30))
        nParts = ceil((nCol/(3*30)));
        eachPartWidth = ceil(nCol/nParts);
        storTopBot = zeros(nParts,6);
        for part = 1:1:nParts
            if(part == 1)
                ImgRef_1 = ImgRef(:,1:eachPartWidth);
            elseif(part == nParts)
                ImgRef_1 = ImgRef(:,((part-1)*eachPartWidth)+1:nCol);
            else
                ImgRef_1 = ImgRef(:,((part-1)*eachPartWidth)+1:(part*eachPartWidth));
            end
            [l1_1,l4_1,topLineTest1,bottomLineTest1,alternativeTopPt,alternativeBottomPt] = performPrunning_3(ImgRef_1);
            storTopBot(part,1) = topLineTest1;
            storTopBot(part,2) = bottomLineTest1;
            storTopBot(part,3) = l1_1;
            storTopBot(part,4) = l4_1;
            storTopBot(part,5) = alternativeTopPt;
            storTopBot(part,6) = alternativeBottomPt;
        end
        %     ImgRef_1 = ImgRef(:,1:ceil(nCol/3));
        %     ImgRef_2 = ImgRef(:,(ceil(nCol/3)+1):((ceil(nCol/3))*2));
        %     ImgRef_3 = ImgRef(:,((ceil(nCol/3))*2)+1:nCol);
        
        %     if(goEachRefImg == 810)
        %         disp(23)
        %     end
        %     [l1_1,l4_1,topLineTest1,bottomLineTest1] = performPrunning_1(ImgRef_1);
        %     [l1_2,l4_2,topLineTest2,bottomLineTest2] = performPrunning_1(ImgRef_2);
        %     [l1_3,l4_3,topLineTest3,bottomLineTest3] = performPrunning_1(ImgRef_3);
        %
        %     afterBinarizedTest(:,1:ceil(nCol/3)) = ImgRef_1;
        %     afterBinarizedTest(:,(ceil(nCol/3)+1):((ceil(nCol/3))*2)) = ImgRef_2;
        %     afterBinarizedTest(:,((ceil(nCol/3))*2)+1:nCol) = ImgRef_3;
        
        %     storTopBot(1,1) = topLineTest1;
        %     storTopBot(1,2) = bottomLineTest1;
        %     storTopBot(1,3) = l1_1;
        %     storTopBot(1,4) = l4_1;
        %
        %     storTopBot(2,1) = topLineTest2;
        %     storTopBot(2,2) = bottomLineTest2;
        %     storTopBot(2,3) = l1_2;
        %     storTopBot(2,4) = l4_2;
        %
        %     storTopBot(3,1) = topLineTest3;
        %     storTopBot(3,2) = bottomLineTest3;
        %     storTopBot(3,3) = l1_3;
        %     storTopBot(3,4) = l4_3;
        
        topLineTest = min(storTopBot(:,1));
        bottomLineTest = max(storTopBot(:,2));
        l1 = min(storTopBot(:,3));
        l4 = max(storTopBot(:,4));
        alternativeTopPt = min(storTopBot(:,5));
        alternativeBottomPt = max(storTopBot(:,6));
        
        forTopLine = (((abs((l4-l1)/2))*30)/100);
        forBottomLine = (((abs((l4-l1)/2))*20)/100);
        
        
        %         if(abs(alternativeTopPt - topLineTest) < (((abs((l4-l1)/2))*55)/100))
        if(((abs(forTopLine - alternativeTopPt))<(abs(forTopLine -topLineTest)))||...
                ((abs(forTopLine - alternativeTopPt))<(abs(forTopLine -topLineTest))))
            topLineTest = alternativeTopPt;
        elseif((abs(forTopLine -topLineTest)) < (abs(forTopLine - alternativeTopPt)))
            alternativeTopPt = topLineTest;
        end
        %         end
        %         if(abs(alternativeBottomPt - bottomLineTest) < (((abs((l4-l1)/2))*40)/100))
        if(((abs(forBottomLine - alternativeBottomPt))<(abs(forBottomLine -topLineTest)))||...
                ((abs(forBottomLine - alternativeBottomPt))<(abs(forBottomLine -topLineTest))))
            bottomLineTest = alternativeBottomPt;
        elseif((abs(forBottomLine -topLineTest)) < (abs(forBottomLine - alternativeBottomPt)))
            alternativeBottomPt = bottomLineTest;
        end
        %         end
        
        %         if((abs(topLineTest -bottomLineTest))<((nRow*30)/100))
        %             topLineTest = l1;
        %         end
        if((((abs(topLineTest - bottomLineTest))*45)/100)>(abs(topLineTest - l1)))
            topLineTest = l1;
            alternativeTopPt = l1;
        end
        if((((abs(topLineTest - bottomLineTest))*30)/100)>(abs(bottomLineTest - l4)))
            bottomLineTest = l4;
            alternativeBottomPt = l4;
            
        end
        
        
        [~, nCol, numberOfColorChannels] = size(ImgRef);
        
        
     % the folloing line is required for converting 2D image into 3D image, so that
     % we can draw the color line in it.
        
        if numberOfColorChannels == 1
            % It's monochrome, so convert to color.
            afterBinarizedTest = cat(3, ImgRef, ImgRef, ImgRef);
        end
        
        
        
        
        for pt =1:1:nCol
            afterBinarizedTest(bottomLineTest,pt,1) = 255;
            afterBinarizedTest(bottomLineTest,pt,2) = 0; % RED COLOR
            afterBinarizedTest(bottomLineTest,pt,3) = 0;
            
            afterBinarizedTest(topLineTest,pt,1) = 0;
            afterBinarizedTest(topLineTest,pt,2) = 255; % GREEN COLOR
            afterBinarizedTest(topLineTest,pt,3) = 0;
            
            afterBinarizedTest(l1,pt,1) = 0;
            afterBinarizedTest(l1,pt,2) = 255; % CYAN COLOR
            afterBinarizedTest(l1,pt,3) = 255;
            
            afterBinarizedTest(l4,pt,1) = 255;
            afterBinarizedTest(l4,pt,2) = 255; % YELLOW COLOR
            afterBinarizedTest(l4,pt,3) = 0;
            
            afterBinarizedTest(alternativeTopPt,pt,1) = 255;
            afterBinarizedTest(alternativeTopPt,pt,2) = 0;   % magenta
            afterBinarizedTest(alternativeTopPt,pt,3) = 255;
            
            afterBinarizedTest(alternativeBottomPt,pt,1) = 0;
            afterBinarizedTest(alternativeBottomPt,pt,2) = 0;
            afterBinarizedTest(alternativeBottomPt,pt,3) = 255; % bLUE COLOR
        end
        %     wordSpottingBasicOperation(ImgRef);
        imwrite(afterBinarizedTest,[path, refName '.jpg']);
        %     disp(goEachRefImg);
    end
    
end