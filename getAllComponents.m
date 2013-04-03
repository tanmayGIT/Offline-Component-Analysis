function getAllComponents(segmentedDocImageSequence,imagePath,refName)
for i = 1:1:size(segmentedDocImageSequence,1)
   
    [~,~,imageComponent] = findApplicableForCell(segmentedDocImageSequence{i,1}{1,3});
    imageFilePathRef = imagePath{i,1};
    
    [~, name, ~] = fileparts(imageFilePathRef); % The path of the reference image
    pathstr = '/Users/tanmoymondal/Documents/Study Guru/STUDY GURU/Dataset/dickDoom/AllComponents/';
    pathstr1 = [pathstr refName '/'];
    imageFilePath_Full = [pathstr1 name '/'];
    
    if((exist(imageFilePath_Full,'dir'))==0)
        mkdir(imageFilePath_Full);
    end 
    
    ImgRef = imread(imageFilePathRef);
    if(size(ImgRef,3)==3)
        ImgRef = rgb2gray(ImgRef);
    end
    
    ImgRef = uint8(ImgRef);
    binImg = doBinary(ImgRef);
    binImg = imcomplement(binImg);
    [sz1 sz2] = size(ImgRef);
    filterBinMat = zeros(sz1,sz2);
    for j = 1:1:size(imageComponent,1)
        minRw = imageComponent{j,1}(1,1);
        maxRw = imageComponent{j,1}(1,2);
        minCol = imageComponent{j,1}(1,3);
        maxCol = imageComponent{j,1}(1,4);
        
        ImgRef(minRw,minCol:maxCol)=0;
        ImgRef(minRw:maxRw,minCol)=0;
        ImgRef(maxRw,minCol:maxCol)=0;
        ImgRef(minRw:maxRw,maxCol)=0;
        component = ImgRef(minRw:maxRw,minCol:maxCol);
       
        filterBinMat(minRw:maxRw,minCol:maxCol) = binImg(minRw:maxRw,minCol:maxCol);
        
        filterBinMat(minRw,minCol:maxCol)=1;
        filterBinMat(minRw:maxRw,minCol)=1;
        filterBinMat(maxRw,minCol:maxCol)=1;
        filterBinMat(minRw:maxRw,maxCol)=1;
        
%         if((minRw-2 >1)||(minRw-2 ==1))
%             filterBinMat(minRw-2,minCol:maxCol)=1;
%         else
%             filterBinMat(minRw,minCol:maxCol)=1;
%         end
%         if((minCol-2 > 1)||(minCol-2 == 1))
%             filterBinMat(minRw:maxRw,minCol-2)=1;
%         else
%             filterBinMat(minRw:maxRw,minCol)=1;
%         end
%         if((maxRw+2 < sz1)||(maxRw+2 == sz1))
%             filterBinMat(maxRw+2,minCol:maxCol)=1;
%         else
%             filterBinMat(maxRw,minCol:maxCol)=1;
%         end
%         if((maxCol+2 < sz2)||(maxCol+2 == sz2))
%             filterBinMat(minRw:maxRw,maxCol+2)=1;
%         else
%             filterBinMat(minRw:maxRw,maxCol)=1;
%         end
        str1 = int2str(j);
        
        imwrite(component,[imageFilePath_Full,str1 '.jpg']);
    end
    imwrite(ImgRef,[imageFilePath_Full,'full image' '.jpg']);
    imwrite(filterBinMat,[imageFilePath_Full,'binary image' '.jpg']);
end