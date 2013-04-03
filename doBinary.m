function [binaryImg] = doBinary(Img)


level = graythresh(Img);

Img1 = im2bw(Img,level);





binaryImg = ApplyMorphology(Img1,false);





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