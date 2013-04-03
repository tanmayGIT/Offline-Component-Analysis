function [beforeRLSA,afterVerticalRLSA] = wordSpottingBasicOperationRef(Img,horiRLSAThresh,verRLSAThresh)


level = graythresh(Img);
%level = 0.6500;
Img1 = im2bw(Img,level);
% imwrite(Img1, 'E:\otsuImage.png');

% ImgNiBlack = niblack(Img);
% imwrite(ImgNiBlack, 'E:\niBlackImage.png');
% figure, imshow(Img1);


%% For Horizontal RLSA
% Inverting the image
Img1 = imcomplement(Img1);

beforeRLSA = ApplyMorphology(Img1,false);
% getAvgHeight = AnalyzeCharacterComponent(beforeRLSA);
% horiRLSAThresh = ceil((getAvgHeight*50)/100);
% verRLSAThresh = ceil((getAvgHeight*10)/100);


parfor p=1:(size(Img1,1))
    Img1(p,:) = RLSATest(Img1(p,:),horiRLSAThresh);
end

% % For Vertical RLSA
% % Inverting the image
Img2 = Img1; % after horizontal RLSA

clear Img1;
parfor io=1:(size(Img2,2))
    RLSAmat = RLSATest((Img2(:,io))',verRLSAThresh);
    Img2(:,io) = RLSAmat';
end
beforeRLSA = imcomplement(beforeRLSA);
afterVerticalRLSA = ApplyMorphology(Img2,true);
return;
end
function[BW2] =  ApplyMorphology(BW2,applyFlag)
% SE = strel('square', 3); % generating a structuring element of 3*3 square
% BW2 = bwmorph(BW2,'bridge');
% BW2 = bwmorph(BW2,'fill');
% BW2 = bwmorph(BW2,'majority');
BW2 = bwmorph(BW2,'clean');
% BW2 = bwmorph(BW2,'spur');

% if(applyFlag)
%     se = strel('line',6,90);
%     BW2 = imdilate(BW2,se);
% end
% BW2 = bwmorph(BW2,'majority');
BW2 = bwmorph(BW2,'clean');
% BW2 = bwmorph(BW2,'spur');
return;
end
% As in the undilated image, the same word can be conisdered as two seperate words in CC labelling
% so dilation is required, here we don't want to dilate original image,
% so we made a copy, CC labelling algo will run on the dilated image
% bwDilate = BW2;
% bwDilate = imclose(bwDilate,SE);  % Dilating with the structuring element
% figure,imshow(bwDilate);