tic;
clear all;
close all;
clc;
ImgTest = imread('206167_507353405982640_1828631233_n.jpg');
if(size(ImgTest,3)==3)
    ImgTest = rgb2gray(ImgTest);
end
ImgTest = uint8(ImgTest);
figure,imshow(ImgTest);



%% Wiener Filtering of the image
imgPadded = padarray(ImgTest,[1 1],'symmetric','both');
[nRows nCols] = size(imgPadded);
varianceMat = zeros(nRows,nCols);
meanMat = zeros(nRows,nCols);
whalf = 1;

for j = 2:1:nCols-1
    for i = 2:1:nRows-1
        sum = 0;
        for m = -whalf:whalf
            for n = -whalf:whalf
                sum = (sum + double(imgPadded(i+m,j+n)));
            end
        end
        meanVal = double (sum/9);
        meanMat(i,j) = meanVal;
        varianceVal = 0;
        if((j==3)&&(i==241))
            disp('want to see u');
        end
        for m = -whalf:whalf
            for n = -whalf:whalf
                dick = ((imgPadded(i+m,j+n) - meanVal)^2);
                %                 disp((imgPadded(j+n,i+m)));
                %                 disp(meanVal);
                %                 disp(dick);
                %                 disp(((imgPadded(i+m,j+n) - meanVal)));
                varianceVal =  (varianceVal + double ((imgPadded(i+m,j+n) - meanVal)^2)) ;
            end
        end
        varianceVal = double(varianceVal / 9);
        varianceMat(i,j) = varianceVal;
    end
end

meanMat = meanMat(2:nRows-1,2:nCols-1);
varianceMat = varianceMat(2:nRows-1,2:nCols-1);

meanMat = padarray(meanMat,[1 1],'symmetric','both');
varianceMat = padarray(varianceMat,[1 1],'symmetric','both');
global wienerFilteredMat;
wienerFilteredMat = zeros(nRows,nCols);
for i = 2:1:nRows-1
    for j = 2:1:nCols-1
        meanVariance = 0;
        for m = -whalf:whalf
            for n = -whalf:whalf
                meanVariance =  (meanVariance + double(varianceMat(i+m,j+n)));
            end
        end
        meanVariance = double(meanVariance / 9);
%         if((varianceMat(i,j)) == 0)
%             disp('wanna see u');
%         end
        wienerFilteredMat(i,j) = (meanMat(i,j) + double((  ((varianceMat(i,j)) - meanVariance) * (imgPadded(i,j)-(meanMat(i,j))) )/ (varianceMat(i,j))  ));
    end
end

wienerFilteredMat = wienerFilteredMat(2:nRows-1,2:nCols-1);
wienerFilteredMat = mat2gray(wienerFilteredMat);
figure,imshow(wienerFilteredMat);
%%





%% Sauvola's Adaptive Thresholding Techniques
[nRows nCols] = size(wienerFilteredMat);
singleMeanVal = mean(wienerFilteredMat(:));
singleStandardDeviation = std(wienerFilteredMat(:));
k = 0.2; % The manual parameter
value = singleMeanVal*(1+ (k * (singleStandardDeviation/((nRows+nCols)-1))));
thresholdedImg = zeros(nRows,nCols);




for p = 1:1:nRows
    for q = 1:1:nCols
        
        if(wienerFilteredMat(p,q) > value)
            thresholdedImg(p,q) = 1;
        else
            thresholdedImg(p,q) = 0;
        end
        
    end
end
figure,imshow(thresholdedImg);

rwBW = 24;
colBW = 36;
[beforePadRw beforePadCol] = size(wienerFilteredMat);
% backGrSurface = wienerFilteredMat;
% backGrSurface = padarray(backGrSurface,[(round(rwBW/2)) (round(colBW/2))],'symmetric','both');
thresholdedImgPadded = padarray(thresholdedImg,[(round(rwBW/2)) (round(colBW/2))],'symmetric','both');
wienerFilteredMatPadded = padarray(wienerFilteredMat,[(round(rwBW/2)) (round(colBW/2))],'symmetric','both');
[nRows nCols] = size(thresholdedImgPadded);
backGrSurface = zeros(nRows,nCols);
% backGrSurface(((round(rwBW/2))+1):(nRows-(round(rwBW/2))),(round(colBW/2)+1):(nCols-(round(colBW/2)))) = zeroMat;

for p = ((round(rwBW/2))+1):1:(nRows-(round(rwBW/2)))
    for q = (round(colBW/2)+1):1:(nCols-(round(colBW/2)))
        
        if(thresholdedImgPadded(p,q) == 1)
            numerator = 0;
            denom = 0;
            for m = -(round(rwBW/2)):(round(rwBW/2))
                for n = -(round(colBW/2)):(round(colBW/2))
                    numerator = numerator + double(wienerFilteredMatPadded(p+m,q+n)*(1-thresholdedImgPadded(p+m,q+n)));
                    denom = denom + double(1-thresholdedImgPadded(p+m,q+n));
                end
            end
            
            if(isnan((numerator/denom)))
                backGrSurface(p,q) =  0;
            else
                backGrSurface(p,q) =  double(numerator/denom);
            end
            
        elseif(thresholdedImgPadded(p,q) == 0)
            backGrSurface(p,q) = 0;
        end
    end
end
backGrSurface = backGrSurface(((round(rwBW/2))+1):(nRows-(round(rwBW/2))),(round(colBW/2)+1):(nCols-(round(colBW/2))));
figure,imshow(backGrSurface);
delNumerator = (backGrSurface - wienerFilteredMat);
del = sumMat(delNumerator)/sumMat(thresholdedImg);
onesMat = ones(beforePadRw,beforePadCol);
numerator_1 = (onesMat - thresholdedImg);
numerator_2 = backGrSurface.*numerator_1;
b = sumMat(numerator_2)/sumMat(numerator_1);
q = 0.6;
p1 = 0.5;
p2 = 0.8;

finalThresholdedImg = zeros(beforePadRw,beforePadCol);
dB = zeros(beforePadRw,beforePadCol);
for rw = 1:1:beforePadRw
    for col = 1:1:beforePadCol
        dB(rw,col) = (q*del)*(((1-p2)/( 1+(exp(   ((-4*backGrSurface(rw,col))   /   (b*(1-p1)))    +...
            (  (2*(1+p1))  /  (1-p1)  ) ) ) )) + p2);
        
        if((backGrSurface(rw,col) - wienerFilteredMat(rw,col)) > (dB(rw,col) ) )
            finalThresholdedImg(rw,col) = 1;
        else
            finalThresholdedImg(rw,col) = 0;
        end
    end
end

figure,imshow(finalThresholdedImg);

M = 2; % The scaling factor

T = zeros((beforePadRw*2),(beforePadCol*2));
IU = zeros((beforePadRw*2),(beforePadCol*2));
[scaledRw scaledCol] = size(T);
for xDash = 3:1:scaledRw-2
    for yDash = 3:1:scaledCol-2
        x = ceil(xDash/M);
        y = ceil(yDash/M);
        b = (yDash/M)-y;
        val = ((-b*(1-(b^2)))*calculateF(xDash,x,y-1,M))+((1-(2*(b^2))+(b^3))*(calculateF(xDash,x,y,M)))...
            +((b*(1+b-b^2))*(calculateF(xDash,x,y+1,M))) - (((b^2)*(1-b))*(calculateF(xDash,x,y+2,M)));
        IU(xDash,yDash) = val;
    end
end


toc;


