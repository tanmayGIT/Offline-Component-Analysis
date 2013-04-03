function [FilteredConnectedCom] = AnalyzeRefWord(l1Ref,l4Ref,topLineRef,baseLineRef,componentImg,ImgRef,accumulatedCell)
% [~, nColRef] = size(beforeRLSARef);
l1Test = accumulatedCell(1,1);
l4Test = accumulatedCell(1,2);
topLineTest = accumulatedCell(1,3);
baseLineTest = accumulatedCell(1,4);


[~,nCol] = size(ImgRef);



% aspectRatio = nRw/nCol;
% changedWidth = ceil(hghtTestComponent/aspectRatio);
% ImgRefNw = imresize(ImgRef,[hghtTestComponent changedWidth]);
% componentImgNw = imresize(componentImg,[hghtTestComponent changedWidth]);


aspectRatio = (abs(baseLineRef - topLineRef))/nCol; % The aspect ratio of the ref word, by considering only the base lines or body of word
changedWidth = ceil((abs(baseLineTest - topLineTest))/aspectRatio); % changed width of the ref word

ImgRefNwBody = imresize(ImgRef(topLineRef:baseLineRef,:),[(abs(baseLineTest - topLineTest)) changedWidth]);
componentImgNwBody = imresize(componentImg(topLineRef:baseLineRef,:),[(abs(baseLineTest - topLineTest)) changedWidth]);

if((l1Ref ~= topLineRef)&& (l4Ref ~= baseLineRef))
    
    changedHghtTop = round(((abs(baseLineTest - topLineTest))*(abs(l1Ref - topLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwTop = imresize(ImgRef(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    componentImgNwTop = imresize(componentImg(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    
    changedHghtBottom = round(((abs(baseLineTest - topLineTest))*(abs(l4Ref - baseLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwBottom = imresize(ImgRef(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    componentImgNwBottom = imresize(componentImg(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    
    changedImg = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImg(1:changedHghtTop,:) = ImgRefNwTop(:,:);
    changedImg(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = ImgRefNwBody(:,:);
    changedImg(((changedHghtTop+(abs(baseLineTest - topLineTest)))+1):...
        ((changedHghtTop+(abs(baseLineTest - topLineTest))))+changedHghtBottom,:) = ImgRefNwBottom(:,:);
    
    changedImgBin = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImgBin(1:changedHghtTop,:) = componentImgNwTop(:,:);
    changedImgBin(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = componentImgNwBody(:,:);
    changedImgBin(((changedHghtTop+(abs(baseLineTest - topLineTest)))+1):...
        ((changedHghtTop+(abs(baseLineTest - topLineTest))))+changedHghtBottom,:) = componentImgNwBottom(:,:);
    l1 = 1;
    l4 = (changedHghtTop+(abs(baseLineTest - topLineTest))+changedHghtBottom);
    topLin = changedHghtTop+1;
    botLin = ((changedHghtTop+(abs(baseLineTest - topLineTest)))+1);
elseif((l1Ref == topLineRef)&& (l4Ref ~= baseLineRef))
    
    
    changedHghtBottom = round(((abs(baseLineTest - topLineTest))*(abs(l4Ref - baseLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwBottom = imresize(ImgRef(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    componentImgNwBottom = imresize(componentImg(baseLineRef:l4Ref,:),[changedHghtBottom changedWidth]);
    
    changedImg = zeros(((abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImg(topLineTest:baseLineTest,:) = ImgRefNwBody(:,:);
    
    changedImg((baseLineTest+1):(baseLineTest + changedHghtBottom),:) = ImgRefNwBottom(:,:);
    
    changedImgBin = zeros(((abs(baseLineTest - topLineTest))+changedHghtBottom),changedWidth);
    changedImgBin(topLineTest:baseLineTest,:) = componentImgNwBody(:,:);
    
    changedImgBin((baseLineTest+1):(baseLineTest + changedHghtBottom),:) = componentImgNwBottom(:,:);
    
    l1 = 1;
    topLin = 1;
    l4 = ((abs(baseLineTest - topLineTest))+changedHghtBottom);
    botLin = (baseLineTest+1);
elseif((l1Ref ~= topLineRef)&& (l4Ref == baseLineRef))
    
    changedHghtTop = round(((abs(baseLineTest - topLineTest))*(abs(l1Ref - topLineRef)))/(abs(baseLineRef - topLineRef)));
    ImgRefNwTop = imresize(ImgRef(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    componentImgNwTop = imresize(componentImg(l1Ref:topLineRef,:),[changedHghtTop changedWidth]);
    
    
    
    changedImg = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))),changedWidth);
    changedImg(1:changedHghtTop,:) = ImgRefNwTop(:,:);
    changedImg(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = ImgRefNwBody(:,:);
    
    
    changedImgBin = zeros((changedHghtTop+(abs(baseLineTest - topLineTest))),changedWidth);
    changedImgBin(1:changedHghtTop,:) = componentImgNwTop(:,:);
    changedImgBin(changedHghtTop+1:(changedHghtTop+(abs(baseLineTest - topLineTest))),:) = componentImgNwBody(:,:);
    
    l1  = 1;
    l4 = (changedHghtTop+(abs(baseLineTest - topLineTest)));
    topLin = changedHghtTop+1;
    botLin = l4;
    
elseif((l1Ref == topLineRef)&& (l4Ref == baseLineRef))
    changedImg = zeros((abs(baseLineTest - topLineTest)),changedWidth);
    changedImg(:,:) = ImgRefNwBody(:,:);
    
    
    changedImgBin = zeros((abs(baseLineTest - topLineTest)),changedWidth);
    changedImgBin(:,:) = componentImgNwBody(:,:);
    
    l1 = 1;
    topLin = 1;
    l4 = abs(baseLineTest - topLineTest);
    botLin = l4;
end
%        componentWdth = ComponentHghtWdth(Chk,2);
[featureMat,lukUpTableForRealIndex] = GetFeatureOfComponentUpdated_2Exp(changedImgBin,changedImg);

% [~, nCol] = size(changedImg);
% the folloing line is required for converting 2D image into 3D image, so that
% we can draw the color line in it.

% if numberOfColorChannels == 1
%     % It's monochrome, so convert to color.
%     afterGrayTest = cat(3, changedImg, changedImg, changedImg);
% end

 changedImg(l1,:) = 1;
 changedImg(l4,:) = 1;
 changedImg(topLin,:) = 1;
 changedImg(botLin,:) = 1;

% for pt =1:1:nCol   
%     changedImg(l1Ref,pt) = 1;
% %     afterGrayTest(l1Ref,pt) = 255; % CYAN COLOR
% %     afterGrayTest(l1Ref,pt) = 255;
%     
%     changedImg(l4Ref,pt) = 1;
% %     afterGrayTest(l4Ref,pt) = 255; % YELLOW COLOR
% %     afterGrayTest(l4Ref,pt) = 0;
%     changedImg(baseLineRef,pt) = 0;
% %     afterGrayTest(baseLineRef,pt) = 0; % RED COLOR
% %     afterGrayTest(baseLineRef,pt) = 0;
%     
%     changedImg(topLineRef,pt) = 0;
% %     afterGrayTest(topLineRef,pt) = 255; % GREEN COLOR
% %     afterGrayTest(topLineRef,pt) = 0;
% end


%  figure,imshow(changedImg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HAVING THE SCOPE OF IMPROVEMENT AS THERE IS NO NEED TO STORE ALL THE CELL
% VALUE AS ALL THE VALUES ARE NOT USEFUL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FilteredConnectedCom{1,1} = 0;%HoldConnecComMoreRefined{Chk,1};
FilteredConnectedCom{1,2} = changedImg; % Storing by cutting with the proper boundary of the Component image
FilteredConnectedCom{1,3} = featureMat;
FilteredConnectedCom{1,4} = lukUpTableForRealIndex;

return;
end

