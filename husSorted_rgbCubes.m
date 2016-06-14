function [hueSorted_res_rgbC,rgbCMat] = husSorted_rgbCubes()
%this is sorting HSV, first H, then S, then V. All ascending.
res_rgbC = load('reshaped_rgbColorCubes.mat');
res_rgbC = res_rgbC.res_rgbC;
rgbCMat = zeros(512,3);

for i = 1:512
    rgbCMat(i,1) = res_rgbC(i).R;
    rgbCMat(i,2) = res_rgbC(i).G;
    rgbCMat(i,3) = res_rgbC(i).B;
end
maxVal = max(max(rgbCMat));

artIm = uint8(zeros(512,200,3));
for i = 1:512
    for j = 1:200
        artIm(i,j,1) = rgbCMat(i,1);
        artIm(i,j,2) = rgbCMat(i,2);
        artIm(i,j,3) = rgbCMat(i,3);
    end
end
% figure
% imshow(artIm);

hsvMat = rgb2hsv(rgbCMat/maxVal);

hsvMatSorted = hsvMat;
hsvMatSorted = sortHSV(hsvMatSorted,1);
%hsvMatSorted = sortrows(hsvMatSorted,1);


hueSorted_res_rgbC = uint8(hsv2rgb(hsvMatSorted)*maxVal);

artIm = uint8(zeros(512,200,3));
for i = 1:512
    for j = 1:200
        artIm(i,j,1) = hueSorted_res_rgbC(i,1);
        artIm(i,j,2) = hueSorted_res_rgbC(i,2);
        artIm(i,j,3) = hueSorted_res_rgbC(i,3);
    end
end
% figure
% imshow(artIm)

% im = imread('./Results/myLDA_Colors_nd_Words_512/k_1.png');
% hsvIm = rgb2hsv(double(im)/240);
% hsvIm = sortrows(hsvIm(:,:,1),3);
% hsvIm = sortrows(hsvIm,2);
% hsvIm = sortrows(hsvIm,1);
% im = uint8(hsvIm*240);
% imshow(im)
save 'hueSorted_res_rgbC';
%mapRGBcube2SortedHSVcube();
end

function hsvMatSorted = sortHSV(mat,col)

hsvMatSorted = sortrows(mat,col);
[ux,ix] = unique(hsvMatSorted(:,col));
for i= 1:numel(ux)-1
   tempMat = hsvMatSorted(ix(i):ix(i+1)-1,:);
   tempMat = sortrows(tempMat,(col+1));
   
   [ux2,ix2] = unique(tempMat(:,col+1));
   for j= 1:numel(ux2)-1
        tempMat2 = tempMat(ix2(j):ix2(j+1)-1,:);
        tempMat(ix2(j):ix2(j+1)-1,:) = sortrows(tempMat2,col+2); 
    end
   hsvMatSorted(ix(i):ix(i+1)-1,:) = tempMat;
end

end
