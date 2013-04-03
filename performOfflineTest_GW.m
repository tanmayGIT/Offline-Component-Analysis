%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function Name : Word Spotting                                          %
%  Author : Tanmay                                                        %
%  Date : 08/09/2012                                                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function performOfflineTest_GW(ImgRef,imageFolder_1,getSameImdex)

global dividedFeatureMat;
global dividedPathMat;
getSameImdex = sort(getSameImdex);

imagePathProb = dividedPathMat;
segmentedDocImageSequence = dividedFeatureMat;


dickDoom = cell((size(segmentedDocImageSequence,1)),1);%cell(2,1);
cntdd = 1;
for jick = 1:1:(size(segmentedDocImageSequence,1))
    dickDoom{cntdd,1} = segmentedDocImageSequence{jick,1};
    cntdd = cntdd +1;
end
progressbar(0,0,0) % Init 3 bars



totalImage = size(dickDoom,1);
storInformation = cell(totalImage,5);
storInformation1 = cell(totalImage,1);
storInformation2 = cell(totalImage,1);
storInformation3 = cell(totalImage,1);
storInformation4 = cell(totalImage,1);
storInformation5 = cell(totalImage,1);

parfor eachImg = 1:size(dickDoom,1)
    if(~(isempty(dickDoom{eachImg,1}{1,3})))
        testImg = imread(imagePathProb{eachImg,1});
        
        testMat = (dickDoom{eachImg,1}{1,3});
        minRw = dickDoom{eachImg,1}{1,1}(1,3);
        maxRw = dickDoom{eachImg,1}{1,1}(3,3);
        minCol = dickDoom{eachImg,1}{1,1}(3,4);
        maxCol = dickDoom{eachImg,1}{1,1}(4,4);
        nwTestImg = testImg(minRw:maxRw,minCol:maxCol);
        
        componentHght = (dickDoom{eachImg,1}{1,1}(3,3) - dickDoom{eachImg,1}{1,1}(1,3))+1;
        
        if(componentHght > 15)
            refComponentMat = wordSpottingAnalyzeRefImage_GW(ImgRef,componentHght);
            
            refComponentSize = (size(refComponentMat{1,2},2));
            refMatForMatch = (refComponentMat{1,3});
            realIndexRef = (refComponentMat{1,4});
            if((refComponentSize/3) <= (size(testMat,1)))
                realIndexTest = dickDoom{eachImg,1}{1,4};
                [~,distVal,getIndexes] = stringMatchingWithMVM(refMatForMatch,testMat,realIndexRef,realIndexTest);
                
                storInformation1{eachImg,1} = getIndexes;
                storInformation2{eachImg,1} = distVal;
                storInformation3{eachImg,1} = refComponentMat{1,2};
                storInformation4{eachImg,1} = nwTestImg;
                storInformation5{eachImg,1} = eachImg;
                
            end
        end
    end
    progressbar([],eachImg/totalImage) % Update 3rd bar
end

for dick = 1:1:size(storInformation1,1)
    storInformation{dick,1} = storInformation1{dick,1};
    storInformation{dick,2} = storInformation2{dick,1};
    storInformation{dick,3} = storInformation3{dick,1};
    storInformation{dick,4} = storInformation4{dick,1};
    storInformation{dick,5} = storInformation5{dick,1};
end
clear storInformation1 storInformation2 storInformation3 storInformation4 storInformation5 
% load storInformation;
[~,~,nonZerostorInformation,getSameImdex] = findApplicableForCell_GWSpecial(storInformation,getSameImdex);

mergeDistMat = zeros((size(nonZerostorInformation,1)),1);
for gt = 1:1:(size(nonZerostorInformation,1))
    mergeDistMat(gt,1) = nonZerostorInformation{gt,2};
end
if(~isempty(mergeDistMat))
[mergeDistMat,distIndex] = sort(mergeDistMat);
topEntries_1 = ceil(((size(mergeDistMat,1))*15)/100); % top 15% entries is upto which cell
topEntries_2 = ceil(((size(mergeDistMat,1))*30)/100); % top 30% entries is upto which cell
topEntries_3 = ceil(((size(mergeDistMat,1))*65)/100); % top 65% entries is upto which cell
end

prominentLevel1 = mergeDistMat(topEntries_1,1);
prominentLevel2 = mergeDistMat(topEntries_2,1);
prominentLevel3 = mergeDistMat(topEntries_3,1);




pathstr = imageFolder_1;
imageFiePath_1 = [pathstr 'result/'];
imageFilePath_Full = imageFiePath_1;
imageFilePath_2 = imageFilePath_Full;
imageFilePath_3 = [imageFilePath_2 '1st TopMost/'];
imageFilePath_4 = [imageFilePath_2 '2nd TopMost/'];
imageFilePath_5 = [imageFilePath_2 '3rd TopMost/'];
imageFilePath_6 = [imageFilePath_2 '4th TopMost/'];

if((exist(imageFiePath_1,'dir'))==0)
    mkdir(imageFiePath_1);
end

if((exist(imageFilePath_2,'dir'))==0)
    mkdir(imageFilePath_2);
end

if((exist(imageFilePath_3,'dir'))==0)
    mkdir(imageFilePath_3);
end
if((exist(imageFilePath_4,'dir'))==0)
    mkdir(imageFilePath_4);
end
if((exist(imageFilePath_5,'dir'))==0)
    mkdir(imageFilePath_5);
end
if((exist(imageFilePath_6,'dir'))==0)
    mkdir(imageFilePath_6);
end

distanceText_1 = strcat(imageFilePath_3,'distanceValue.txt');
fid1 = fopen(distanceText_1, 'wt');

distanceText_2 = strcat(imageFilePath_4,'distanceValue.txt');
fid2 = fopen(distanceText_2, 'wt');

distanceText_3 = strcat(imageFilePath_5,'distanceValue.txt');
fid3 = fopen(distanceText_3, 'wt');

distanceText_4 = strcat(imageFilePath_6,'distanceValue.txt');
fid4 = fopen(distanceText_4, 'wt');
cntProm_1 = 1;
cntProm_2 = 1;
cntProm_3 = 1;
cntProm_4 = 1;
firstCandidate = zeros(size(nonZerostorInformation,1),1);
secondCandidate = zeros(size(nonZerostorInformation,1),1);
thirdCandidate = zeros(size(nonZerostorInformation,1),1);
fourthCandidate = zeros(size(nonZerostorInformation,1),1);

distanceText_41 = strcat(imageFilePath_2,'distanceValue12.txt');
fid007 = fopen(distanceText_41, 'wt');

for i1 =1:1:topEntries_1
    myIndex = distIndex(i1,1);
%     myMatch = find(getSameImdex == myIndex);
    
    ImageTest = nonZerostorInformation{myIndex,4};
        [nRowsComponent nColsComponent] = size(ImageTest);
        
        ImageRef = nonZerostorInformation{myIndex,3};
        [nRowsRef nColsRef] = size(ImageRef);
        
        if(nColsComponent > nColsRef)
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
        else
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
        end
        stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
        stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
        
        mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
        
%         warpingPathOfThisComponent = nonZerostorInformation{myIndex,1};
        
        
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
% %                 
% %                 X = [mergedImgRefCol mergedImgTestCol];
% %                 Y = [mergedImgRefRw mergedImgTestRw];
% %                 
% %                 line(X,Y);
% %                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
        str1 = int2str(cntProm_1);
        
        imwrite(mergedImg,[imageFilePath_3,str1 '.jpg']);
%         hold off
%         close;
        myPath = [imageFilePath_3,str1 '.jpg'];
        if(~isempty(find(getSameImdex == myIndex)))
            fprintf(fid007,'The matched image path is : %s \n',myPath); 
        end
        disValToCompare = mergeDistMat(i1,1);
        fprintf(fid1,'The Distance Value of %dth component is : %d \n',cntProm_1,disValToCompare); %write first value
        firstCandidate(cntProm_1,1) = disValToCompare;
        cntProm_1 = cntProm_1 +1;
end
for i2 = topEntries_1+1:1:topEntries_2
    myIndex = distIndex(i2,1);
    allDisVal = myIndex;
    ImageTest = nonZerostorInformation{allDisVal,4};
        [nRowsComponent nColsComponent] = size(ImageTest);
        
        ImageRef = nonZerostorInformation{allDisVal,3};
        [nRowsRef nColsRef] = size(ImageRef);
        
        if(nColsComponent > nColsRef)
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
        else
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
        end
        stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
        stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
        
        mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
        
%         warpingPathOfThisComponent = nonZerostorInformation{allDisVal,1};
%         
%         
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
%                 
%                 X = [mergedImgRefCol mergedImgTestCol];
%                 Y = [mergedImgRefRw mergedImgTestRw];
%                 
%                 line(X,Y);
%                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
        str1 = int2str(cntProm_2);
        
        imwrite(mergedImg,[imageFilePath_4,str1 '.jpg']);
%         hold off
%         close;
        myPath = [imageFilePath_3,str1 '.jpg'];
        if(~isempty(find(getSameImdex == myIndex)))
            fprintf(fid007,'The matched image path is : %s \n',myPath); 
        end
        disValToCompare = mergeDistMat(i2,1);
        fprintf(fid1,'The Distance Value of %dth component is : %d \n',cntProm_2,disValToCompare); %write first value
        secondCandidate(cntProm_2,1) = disValToCompare;
        cntProm_2 = cntProm_2 +1;
end
for i3 = topEntries_2+1:1:topEntries_3
    myIndex = distIndex(i3,1);
    allDisVal = myIndex;
    ImageTest = nonZerostorInformation{allDisVal,4};
        [nRowsComponent nColsComponent] = size(ImageTest);
        
        ImageRef = nonZerostorInformation{allDisVal,3};
        [nRowsRef nColsRef] = size(ImageRef);
        
        if(nColsComponent > nColsRef)
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
        else
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
        end
        stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
        stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
        
        mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
%         
%         warpingPathOfThisComponent = nonZerostorInformation{allDisVal,1};
%         
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
%                 
%                 X = [mergedImgRefCol mergedImgTestCol];
%                 Y = [mergedImgRefRw mergedImgTestRw];
%                 
%                 line(X,Y);
%                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
        str1 = int2str(cntProm_3);
        
        imwrite(mergedImg,[imageFilePath_5,str1 '.jpg']);
%         hold off
%         close;
        myPath = [imageFilePath_3,str1 '.jpg'];
        if(~isempty(find(getSameImdex == myIndex)))
            fprintf(fid007,'The matched image path is : %s \n',myPath); 
        end
        disValToCompare = mergeDistMat(i3,1);
        fprintf(fid3,'The Distance Value of %dth component is : %d \n',cntProm_3,disValToCompare); %write first value
        thirdCandidate(cntProm_3,1) = disValToCompare;
        cntProm_3 = cntProm_3 +1;
end
for i4 = topEntries_3+1:1:(size(nonZerostorInformation,1))
    myIndex = distIndex(i4,1);
    allDisVal = myIndex;
     ImageTest = nonZerostorInformation{allDisVal,4};
        [nRowsComponent nColsComponent] = size(ImageTest);
        
        ImageRef = nonZerostorInformation{allDisVal,3};
        [nRowsRef nColsRef] = size(ImageRef);
        
        if(nColsComponent > nColsRef)
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
        else
            stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
        end
        stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
        stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
        
        mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
%         
%         warpingPathOfThisComponent = nonZerostorInformation{allDisVal,1};
%         
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
%                 
%                 X = [mergedImgRefCol mergedImgTestCol];
%                 Y = [mergedImgRefRw mergedImgTestRw];
%                 
%                 line(X,Y);
%                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
        str1 = int2str(cntProm_4);
        
        imwrite(mergedImg,[imageFilePath_6,str1 '.jpg']);
%         hold off
%         close;
        myPath = [imageFilePath_3,str1 '.jpg'];
        if(~isempty(find(getSameImdex == myIndex)))
            fprintf(fid007,'The matched image path is : %s \n',myPath); 
        end
        disValToCompare = mergeDistMat(i4,1);
        fprintf(fid4,'The Distance Value of %dth component is : %d \n',cntProm_4,disValToCompare); %write first value
        fourthCandidate(cntProm_4,1) = disValToCompare;
        cntProm_4 = cntProm_4 +1;
end
fclose(fid007);
% for allDisVal = 1:1:size(nonZerostorInformation,1)
%     disValToCompare = nonZerostorInformation{allDisVal,2};
%     
%     if((prominentLevel1 > disValToCompare)||( disValToCompare == prominentLevel1 ) )% checking if any First most probable candidate exists or not
%         
%         ImageTest = nonZerostorInformation{allDisVal,4};
%         [nRowsComponent nColsComponent] = size(ImageTest);
%         
%         ImageRef = nonZerostorInformation{allDisVal,3};
%         [nRowsRef nColsRef] = size(ImageRef);
%         
%         if(nColsComponent > nColsRef)
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
%         else
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
%         end
%         stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
%         stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
%         
%         mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
%         
%         warpingPathOfThisComponent = nonZerostorInformation{allDisVal,1};
%         
%         
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
%                 
%                 X = [mergedImgRefCol mergedImgTestCol];
%                 Y = [mergedImgRefRw mergedImgTestRw];
%                 
%                 line(X,Y);
%                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
%         str1 = int2str(cntProm_1);
%         
%         imwrite(imFrame,[imageFilePath_3,str1 '.jpg']);
%         hold off
%         close;
%         fprintf(fid1,'The Distance Value of %dth component is : %d \n',cntProm_1,disValToCompare); %write first value
%         firstCandidate(cntProm_1,1) = disValToCompare;
%         cntProm_1 = cntProm_1 +1;
%     end
%     
%     if((prominentLevel2 > disValToCompare > prominentLevel1)||( disValToCompare == prominentLevel2 ) )% checking if any First most probable candidate exists or not
%         
%         ImageTest = nonZerostorInformation{allDisVal,4};
%         [nRowsComponent nColsComponent] = size(ImageTest);
%         
%         ImageRef = nonZerostorInformation{allDisVal,3};
%         [nRowsRef nColsRef] = size(ImageRef);
%         
%         if(nColsComponent > nColsRef)
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
%         else
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
%         end
%         stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
%         stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
%         
%         mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
%         
%         warpingPathOfThisComponent = nonZerostorInformation{allDisVal,1};
%         
%         
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
%                 
%                 X = [mergedImgRefCol mergedImgTestCol];
%                 Y = [mergedImgRefRw mergedImgTestRw];
%                 
%                 line(X,Y);
%                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
%         str1 = int2str(cntProm_2);
%         
%         imwrite(imFrame,[imageFilePath_4,str1 '.jpg']);
%         hold off
%         close;
%         fprintf(fid1,'The Distance Value of %dth component is : %d \n',cntProm_2,disValToCompare); %write first value
%         secondCandidate(cntProm_2,1) = disValToCompare;
%         cntProm_2 = cntProm_2 +1;
%     end
%     
%     if((prominentLevel3 > disValToCompare > prominentLevel2)||( disValToCompare == prominentLevel3 ) )% checking if any First most probable candidate exists or not
%         
%         ImageTest = nonZerostorInformation{allDisVal,4};
%         [nRowsComponent nColsComponent] = size(ImageTest);
%         
%         ImageRef = nonZerostorInformation{allDisVal,3};
%         [nRowsRef nColsRef] = size(ImageRef);
%         
%         if(nColsComponent > nColsRef)
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
%         else
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
%         end
%         stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
%         stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
%         
%         mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
%         
%         warpingPathOfThisComponent = nonZerostorInformation{allDisVal,1};
%         
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
%                 
%                 X = [mergedImgRefCol mergedImgTestCol];
%                 Y = [mergedImgRefRw mergedImgTestRw];
%                 
%                 line(X,Y);
%                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
%         str1 = int2str(cntProm_3);
%         
%         imwrite(imFrame,[imageFilePath_5,str1 '.jpg']);
%         hold off
%         close;
%         fprintf(fid3,'The Distance Value of %dth component is : %d \n',cntProm_3,disValToCompare); %write first value
%         thirdCandidate(cntProm_3,1) = disValToCompare;
%         cntProm_3 = cntProm_3 +1;
%     end
%     
%     if((disValToCompare > prominentLevel3) )% checking if any First most probable candidate exists or not
%         
%         ImageTest = nonZerostorInformation{allDisVal,4};
%         [nRowsComponent nColsComponent] = size(ImageTest);
%         
%         ImageRef = nonZerostorInformation{allDisVal,3};
%         [nRowsRef nColsRef] = size(ImageRef);
%         
%         if(nColsComponent > nColsRef)
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsComponent+20));
%         else
%             stitchImage = zeros((nRowsRef+nRowsComponent+120),(nColsRef+20));
%         end
%         stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
%         stitchImage((nRowsRef+80+5):(nRowsRef+4+80+nRowsComponent),(5):(nColsComponent+4)) = ImageTest(1:end,1:end);
%         
%         mergedImg = mat2gray(stitchImage);
%         figure, imshow(mergedImg);
%         set(gcf,'Visible', 'on');
%         
%         warpingPathOfThisComponent = nonZerostorInformation{allDisVal,1};
%         
%         if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
%             for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
%                 refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
%                 testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
%                 
%                 mergedImgRefRw = nRowsRef + 5;
%                 mergedImgRefCol = 4+refWordColNo;
%                 
%                 mergedImgTestRw = nRowsRef+80+5;
%                 mergedImgTestCol = 4+testWordColNo;
%                 
%                 X = [mergedImgRefCol mergedImgTestCol];
%                 Y = [mergedImgRefRw mergedImgTestRw];
%                 
%                 line(X,Y);
%                 hold on
%             end
%         else
%             error ('The size of warping path for this component is not same')
%         end
%         pause(0.2);
%         f = getframe(gcf);
%         pause(0.2);
%         imFrame = frame2im(f);
%         str1 = int2str(cntProm_4);
%         
%         imwrite(imFrame,[imageFilePath_6,str1 '.jpg']);
%         hold off
%         close;
%         fprintf(fid4,'The Distance Value of %dth component is : %d \n',cntProm_4,disValToCompare); %write first value
%         fourthCandidate(cntProm_4,1) = disValToCompare;
%         cntProm_4 = cntProm_4 +1;
%     end
% end
fclose(fid1); %close the file
fclose(fid2); %close the file
fclose(fid3); %close the file
fclose(fid4); %close the file

% imageFilePath_3Nw = [imageFilePath_3 'updated/'];
% imageFilePath_4Nw = [imageFilePath_4 'updated/'];
% imageFilePath_5Nw = [imageFilePath_5 'updated/'];
% imageFilePath_6Nw = [imageFilePath_6 'updated/'];
% 
% if((exist(imageFilePath_3Nw,'dir'))==0)
%     mkdir(imageFilePath_3Nw);
% end
% if((exist(imageFilePath_4Nw,'dir'))==0)
%     mkdir(imageFilePath_4Nw);
% end
% if((exist(imageFilePath_5Nw,'dir'))==0)
%     mkdir(imageFilePath_5Nw);
% end
% if((exist(imageFilePath_6Nw,'dir'))==0)
%     mkdir(imageFilePath_6Nw);
% end
% 
% distanceText1New = strcat(imageFilePath_3Nw,'distanceValue.txt');
% fid1Nw = fopen(distanceText1New, 'wt');
% [~,~,firstDis] = find(firstCandidate);
% [~,~,secondDis] = find(secondCandidate);
% [~,~,thirdDis] = find(thirdCandidate);
% [~,~,fourthDis] = find(fourthCandidate);
% 
% [~,sortedIndex1] = sort(firstDis);
% %     [~,R,sortedIndex1] = arrangeImages(distanceText1);
% for sr1 = 1:1:(size(sortedIndex1,1))
%     v1 = sortedIndex1(sr1,1);
%     distVal = firstDis(v1,1);
%     str1 = int2str(v1);
%     imagePath = [imageFilePath_3 str1 '.jpg'];
%     im = imread(imagePath);
%     str2 = int2str(sr1);
%     imwrite(im,[imageFilePath_3Nw,str2 '.jpg']);
%     fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
%     
% end
% fclose(fid1Nw);
% 
% distanceText1New = strcat(imageFilePath_4Nw,'distanceValue.txt');
% fid1Nw = fopen(distanceText1New, 'wt');
% 
% [~,sortedIndex1] = sort(secondDis);
% %     [~,R,sortedIndex1] = arrangeImages(distanceText2);
% for sr1 = 1:1:(size(sortedIndex1,1))
%     v1 = sortedIndex1(sr1,1);
%     distVal = secondDis(v1,1);
%     str1 = int2str(v1);
%     imagePath = [imageFilePath_4 str1 '.jpg'];
%     im = imread(imagePath);
%     str2 = int2str(sr1);
%     imwrite(im,[imageFilePath_4Nw,str2 '.jpg']);
%     fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
%     
% end
% fclose(fid1Nw);
% 
% distanceText1New = strcat(imageFilePath_5Nw,'distanceValue.txt');
% fid1Nw = fopen(distanceText1New, 'wt');
% 
% [~,sortedIndex1] = sort(thirdDis);
% %     [~,R,sortedIndex1] = arrangeImages(distanceText3);
% for sr1 = 1:1:(size(sortedIndex1,1))
%     v1 = sortedIndex1(sr1,1);
%     distVal = thirdDis(v1,1);
%     str1 = int2str(v1);
%     imagePath = [imageFilePath_5 str1 '.jpg'];
%     im = imread(imagePath);
%     str2 = int2str(sr1);
%     imwrite(im,[imageFilePath_5Nw,str2 '.jpg']);
%     fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
%     
% end
% fclose(fid1Nw);
% 
% distanceText1New = strcat(imageFilePath_6Nw,'distanceValue.txt');
% fid1Nw = fopen(distanceText1New, 'wt');
% 
% [~,sortedIndex1] = sort(fourthDis);
% %     [~,R,sortedIndex1] = arrangeImages(distanceText4);
% for sr1 = 1:1:(size(sortedIndex1,1))
%     v1 = sortedIndex1(sr1,1);
%     distVal = fourthDis(v1,1);
%     str1 = int2str(v1);
%     imagePath = [imageFilePath_6 str1 '.jpg'];
%     im = imread(imagePath);
%     str2 = int2str(sr1);
%     imwrite(im,[imageFilePath_6Nw,str2 '.jpg']);
%     fprintf(fid1Nw,'The Distance Value of %dth component is : %d \n',sr1,distVal);
%     
% end
% fclose(fid1Nw);
% else
%     disp('I dont know who u r' );
% end