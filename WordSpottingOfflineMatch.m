%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function Name : Word Spotting                                          %
%  Author : Tanmay                                                        %
%  Date : 08/09/2012                                                      %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function WordSpottingOfflineMatch()

dirOutput = uigetdir('/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/Dataset_1/','Select a folder');
files = dir(fullfile(dirOutput, '*.jpg'));
fileNames = {files.name}';
% imageFilePath = ['E:\STUDY GURU\Document Dewarping\Perspective_Version1.3\MVM_WordStringMatching\bg1\garamont\' fileNames{3}];
% I = imread(imageFilePath);
% imshow(I);
nImages = (length(fileNames));
matlabpool open;
[imagePath,segmentedDocImageSequence] = batchProcessDocuments(dirOutput,fileNames,@wordSpottingBatchOperationOffline);

[nRowsRef nColsRef] = size(ImageRef);


for i=1:nImages
    I = imread(imagePath{i,1});
    if(size(I,3)==3)
        I = rgb2gray(I);
    end
    I = uint8(I);
    figure,imshow(I),hold on;
%     set(gcf,'Visible', 'on'); 
    
    
    [~, name, ~] = fileparts(imagePath{i,1});
    pathstr = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/Dataset_1/';
    imageFiePath_1 = [pathstr 'result/'];
    imageFilePath_2 = [imageFiePath_1 name '/']; % joining the image name with the folder path i.e.
    %     E:\STUDY GURU\Document Dewarping\Perspective_Version1.3\MVM_WordStringMatching\ImageName
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
    
    bestMatchVal1 = segmentedDocImageSequence{i,1}{1,1}(1,1);
    bestMatchVal2 = segmentedDocImageSequence{i,1}{1,1}(1,2);
    bestMatchVal3 = segmentedDocImageSequence{i,1}{1,1}(1,3);
    bestMatchVal4 = segmentedDocImageSequence{i,1}{1,1}(1,4);
    % for each image we will get a array of warping path, where each cell
    % will contain the warping path coordinate of each component
    warpingPathOfAllComponent = segmentedDocImageSequence{i,1}{6,1};
    
    rectangle('Position',[(bestMatchVal1),(bestMatchVal2),(bestMatchVal3),(bestMatchVal4)],'LineWidth',3,'LineStyle','--','EdgeColor','c');
    distanceText = strcat(imageFilePath_3,'distanceValue.txt');
    fid = fopen(distanceText, 'wt'); %open the file
    if(segmentedDocImageSequence{i,1}{2,2} > 1)
        for m = 1:1:(size(segmentedDocImageSequence{i,1}{2,1},1))
            prominentLevel_1_Match_1 = segmentedDocImageSequence{i,1}{2,1}(m,1);
            prominentLevel_1_Match_2 = segmentedDocImageSequence{i,1}{2,1}(m,2);
            prominentLevel_1_Match_3 = segmentedDocImageSequence{i,1}{2,1}(m,3);
            prominentLevel_1_Match_4 = segmentedDocImageSequence{i,1}{2,1}(m,4);
            
            distValue = segmentedDocImageSequence{i,1}{2,1}(m,5);
            indexOfWarpingPath = segmentedDocImageSequence{i,1}{2,1}(m,6);
            
            rectangle('Position',[(prominentLevel_1_Match_1),(prominentLevel_1_Match_2),(prominentLevel_1_Match_3),(prominentLevel_1_Match_4)],'LineWidth',1,'LineStyle','--','EdgeColor','g');hold on
            
            nColsComponent = prominentLevel_1_Match_3 +1;
            nRowsComponent = prominentLevel_1_Match_4 + 1;
            
            if(nColsComponent > nColsRef)
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
            else
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
            end
            stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
            stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                I((prominentLevel_1_Match_2:(prominentLevel_1_Match_2+prominentLevel_1_Match_4)),...
                (prominentLevel_1_Match_1:(prominentLevel_1_Match_1+prominentLevel_1_Match_3)));
            
            
            mergedImg = mat2gray(stitchImage);
            figure, imshow(mergedImg);
            set(gcf,'Visible', 'on'); 
            
            warpingPathOfThisComponent = warpingPathOfAllComponent{indexOfWarpingPath,1};
            if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                    refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                    testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                    
                  
                    
                    mergedImgRefRw = 5;
                    mergedImgRefCol = 4+refWordColNo;
                    
                    mergedImgTestRw = nRowsRef+8+5;
                    mergedImgTestCol = 4+testWordColNo;
                    
                    % As row index in image is considered as Y axis in polar
                    % coordinate in matlab and vice versa
                    
                    X = [mergedImgRefCol mergedImgTestCol];
                    Y = [mergedImgRefRw mergedImgTestRw];
                    line(X,Y);
                    hold on
                end
            else
                error ('The size of warping path for this component is not same')
            end
            
            
            
            f = getframe(gcf);
            imFrame = frame2im(f);
            str1 = int2str(m);
            %         str2 = '+';
            %         str3 = int2str((rand(1,1))); % just to avoid two same image name
            %         strCombined = strcat(imageFiePath_1);
            %     pathname = imageFilePath;
            imwrite(imFrame,[imageFilePath_3,str1 '.jpg']);
            hold off
            close;
            fprintf(fid,'The Distance Value of %dth component is : %d \n',m,distValue); %write first value
            
            
            %   clear I;
        end
    end
    fclose(fid); %close the file
    distanceText = strcat(imageFilePath_4,'distanceValue.txt');
    fid = fopen(distanceText, 'wt'); %open the file
    if(segmentedDocImageSequence{i,1}{3,2} > 1)
        for n = 1:1:(size(segmentedDocImageSequence{i,1}{3,1},1))
            prominentLevel_2_Match_1 = segmentedDocImageSequence{i,1}{3,1}(n,1);
            prominentLevel_2_Match_2 = segmentedDocImageSequence{i,1}{3,1}(n,2);
            prominentLevel_2_Match_3 = segmentedDocImageSequence{i,1}{3,1}(n,3);
            prominentLevel_2_Match_4 = segmentedDocImageSequence{i,1}{3,1}(n,4);
            distValue = segmentedDocImageSequence{i,1}{3,1}(n,5);
            indexOfWarpingPath = segmentedDocImageSequence{i,1}{3,1}(n,6);
            
            rectangle('Position',[(prominentLevel_2_Match_1),(prominentLevel_2_Match_2),(prominentLevel_2_Match_3),(prominentLevel_2_Match_4)],'LineWidth',1,'LineStyle','--','EdgeColor','b');hold on
            nColsComponent = prominentLevel_2_Match_3 +1;
            nRowsComponent = prominentLevel_2_Match_4 + 1;
            if(nColsComponent > nColsRef)
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
            else
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
            end
            stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
            stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                I((prominentLevel_2_Match_2:(prominentLevel_2_Match_2+prominentLevel_2_Match_4)),...
                (prominentLevel_2_Match_1:(prominentLevel_2_Match_1+prominentLevel_2_Match_3)));
            
            
            mergedImg = mat2gray(stitchImage);
            figure, imshow(mergedImg);hold on
            set(gcf,'Visible', 'on'); 
            
            
            warpingPathOfThisComponent = warpingPathOfAllComponent{indexOfWarpingPath,1};
            if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                    refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                    testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                    
                
                    
                    mergedImgRefRw = 5;
                    mergedImgRefCol = 4+refWordColNo;
                    
                    mergedImgTestRw = nRowsRef+8+5;
                    mergedImgTestCol = 4+testWordColNo;
                    
                    % As row index in image is considered as Y axis in polar
                    % coordinate in matlab and vice versa
                    
                    X = [mergedImgRefCol mergedImgTestCol];
                    Y = [mergedImgRefRw mergedImgTestRw];
                    line(X,Y);
                    hold on
                end
            else
                error ('The size of warping path for this component is not same')
            end
            
            
            f = getframe(gcf);
            imFrame = frame2im(f);
            str1 = int2str(n);
            %         str2 = '+';
            %         str3 = int2str((rand(1,1))); % just to avoid two same image name
            %         strCombined = strcat(str1,str2,str3);
            %     pathname = imageFilePath;
            imwrite(imFrame,[imageFilePath_4,str1 '.jpg']);
            hold off
            close;
            fprintf(fid,'The Distance Value of %dth component is : %d \n',n,distValue); %write first value
            
        end
    end
    fclose(fid); %close the file
    distanceText = strcat(imageFilePath_5,'distanceValue.txt');
    fid = fopen(distanceText, 'wt'); %open the file
    if(segmentedDocImageSequence{i,1}{4,2} > 1)
        for p = 1:1:(size(segmentedDocImageSequence{i,1}{4,1},1))
            prominentLevel_3_Match_1 = segmentedDocImageSequence{i,1}{4,1}(p,1);
            prominentLevel_3_Match_2 = segmentedDocImageSequence{i,1}{4,1}(p,2);
            prominentLevel_3_Match_3 = segmentedDocImageSequence{i,1}{4,1}(p,3);
            prominentLevel_3_Match_4 = segmentedDocImageSequence{i,1}{4,1}(p,4);
            distValue = segmentedDocImageSequence{i,1}{4,1}(p,5);
            indexOfWarpingPath = segmentedDocImageSequence{i,1}{4,1}(p,6);
            
            rectangle('Position',[(prominentLevel_3_Match_1),(prominentLevel_3_Match_2),(prominentLevel_3_Match_3),(prominentLevel_3_Match_4)],'LineWidth',1,'LineStyle','--','EdgeColor','m');hold on
            nColsComponent = prominentLevel_3_Match_3 +1;
            nRowsComponent = prominentLevel_3_Match_4 + 1;
            if(nColsComponent > nColsRef)
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
            else
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
            end
            stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
            stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                I((prominentLevel_3_Match_2:(prominentLevel_3_Match_2+prominentLevel_3_Match_4)),...
                (prominentLevel_3_Match_1:(prominentLevel_3_Match_1+prominentLevel_3_Match_3)));
            
            
            mergedImg = mat2gray(stitchImage);
            figure, imshow(mergedImg);hold on
            set(gcf,'Visible', 'on'); 
            
            warpingPathOfThisComponent = warpingPathOfAllComponent{indexOfWarpingPath,1};
            if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                    refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                    testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                    
                   
                    mergedImgRefRw = 5;
                    mergedImgRefCol = 4+refWordColNo;
                    
                    mergedImgTestRw = nRowsRef+8+5;
                    mergedImgTestCol = 4+testWordColNo;
                    
                    % As row index in image is considered as Y axis in polar
                    % coordinate in matlab and vice versa
                    
                    X = [mergedImgRefCol mergedImgTestCol];
                    Y = [mergedImgRefRw mergedImgTestRw];
                    line(X,Y);
                    hold on
                end
            else
                error ('The size of warping path for this component is not same')
            end
            
            f = getframe(gcf);
            imFrame = frame2im(f);
            str1 = int2str(p);
            %         str2 = '+';
            %         str3 = int2str((rand(1,1))); % just to avoid two same image name
            %         strCombined = strcat(str1,str2,str3);
            %     pathname = imageFilePath;
            imwrite(imFrame,[imageFilePath_5,str1 '.jpg']);
            hold off
            close;
            fprintf(fid,'The Distance Value of %dth component is : %d \n',p,distValue); %write first value
        end
    end
    fclose(fid); %close the file
    distanceText = strcat(imageFilePath_6,'distanceValue.txt');
    fid = fopen(distanceText, 'wt'); %open the file
    if(segmentedDocImageSequence{i,1}{5,2} > 1)
        for q = 1:1:(size(segmentedDocImageSequence{i,1}{5,1},1))
            prominentLevel_4_Match_1 = segmentedDocImageSequence{i,1}{5,1}(q,1);
            prominentLevel_4_Match_2 = segmentedDocImageSequence{i,1}{5,1}(q,2);
            prominentLevel_4_Match_3 = segmentedDocImageSequence{i,1}{5,1}(q,3);
            prominentLevel_4_Match_4 = segmentedDocImageSequence{i,1}{5,1}(q,4);
            distValue = segmentedDocImageSequence{i,1}{5,1}(q,5);
            indexOfWarpingPath = segmentedDocImageSequence{i,1}{5,1}(q,6);
            
            rectangle('Position',[(prominentLevel_4_Match_1),(prominentLevel_4_Match_2),(prominentLevel_4_Match_3),(prominentLevel_4_Match_4)],'LineWidth',1,'LineStyle','--','EdgeColor','r');hold on
            nColsComponent = prominentLevel_4_Match_3 + 1;
            nRowsComponent = prominentLevel_4_Match_4 + 1;
            if(nColsComponent > nColsRef)
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsComponent+20));
            else
                stitchImage = zeros((nRowsRef+nRowsComponent+20),(nColsRef+20));
            end
            stitchImage(5:(nRowsRef+4),5:(nColsRef+4)) = ImageRef(1:nRowsRef,1:nColsRef);
            stitchImage((nRowsRef+8+5):(nRowsRef+4+8+nRowsComponent),(5):(nColsComponent+4)) = ...
                I((prominentLevel_4_Match_2:(prominentLevel_4_Match_2+prominentLevel_4_Match_4)),...
                (prominentLevel_4_Match_1:(prominentLevel_4_Match_1+prominentLevel_4_Match_3)));
            mergedImg = mat2gray(stitchImage);
            figure, imshow(mergedImg);hold on
            set(gcf,'Visible', 'on'); 
            
            
            warpingPathOfThisComponent = warpingPathOfAllComponent{indexOfWarpingPath,1};
            if((size(warpingPathOfThisComponent{1,1},1)) == (size(warpingPathOfThisComponent{1,2},1)))
                for element = 1:1:(size(warpingPathOfThisComponent{1,1},1))
                    refWordColNo = warpingPathOfThisComponent{1,1}(element,1);
                    testWordColNo = warpingPathOfThisComponent{1,2}(element,1);
                    
                   
                    mergedImgRefRw = 5;
                    mergedImgRefCol = 4+refWordColNo;
                    
                    mergedImgTestRw = nRowsRef+8+5;
                    mergedImgTestCol = 4+testWordColNo;
                    
                    % As row index in image is considered as Y axis in polar
                    % coordinate in matlab and vice versa
                    
                    X = [mergedImgRefCol mergedImgTestCol];
                    Y = [mergedImgRefRw mergedImgTestRw];
                    line(X,Y);
                    hold on
                end
            else
                error ('The size of warping path for this component is not same')
            end
            
            f = getframe(gcf);
            imFrame = frame2im(f);
            str1 = int2str(q);
            %         str2 = '+';
            %         str3 = int2str((rand(1,1))); % just to avoid two same image name
            %         strCombined = strcat(str1,str2,str3);
            %     pathname = imageFilePath;
            imwrite(imFrame,[imageFilePath_6,str1 '.jpg']);
            hold off
            close;
            fprintf(fid,'The Distance Value of %dth component is : %d \n',q,distValue); %write first value
        end
        fclose(fid); %close the file
    end
    f = getframe(gca);
    imFrame = frame2im(f);
    %     pathname = imageFilePath;
    
    imwrite(imFrame,[imageFilePath_2, 'FULL_IMAGE','.jpg']);
   
    close;
    %     clear I;
end

matlabpool close;
return;
end



