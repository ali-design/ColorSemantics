function [LDA_palettes_512] = generate_image_from_color_topics_512_sortedHue(CP)
%load('./Results/myLDA_Colors_nd_Words_512/myLDA_Colors_nd_Words_512_K12.mat');

res_rgbC = load('./reshaped_rgbColorCubes.mat');
res_rgbC = res_rgbC.res_rgbC;

%first sort res_rgbC based on hue and return the mapping indices
[hueSorted_res_rgbC,rgbCMat] = husSorted_rgbCubes();
hsv2rgbMap = mapRGBcube2SortedHSVcube(hueSorted_res_rgbC,rgbCMat);

% CP a sparse matrix of size W x T, where W is the number of words in the 
% vocabulary and T is the number of topics. 
% CP(i,j) contains the number of times word i has been assigned to topic j. 
CP = bsxfun(@rdivide,CP,sum(CP(1:512,:)));
k = size(CP,2);

imgW = 500;

% 512 colors vs topics
LDA_palettes_512 = double(zeros(size(CP)));
currColor = [255,0,0];
for j = 1:k
    img = uint8(0*ones(100,imgW,3));
    b = 0;   
    for i = 1:512
        numPx = round(imgW*CP(i,j));
        if(numPx ~= 0)
            currColor(1) = res_rgbC(i).R;
            currColor(2) = res_rgbC(i).G;
            currColor(3) = res_rgbC(i).B;
            img(1:100,b+1:b+numPx,1) = currColor(1);
            img(1:100,b+1:b+numPx,2) = currColor(2);
            img(1:100,b+1:b+numPx,3) = currColor(3);
                    
            b = b + numPx; 
        end
        LDA_palettes_512(i,j) = numPx;
    end
    if(b < imgW)
        img(1:100,b+1:imgW,1) = currColor(1);
        img(1:100,b+1:imgW,2) = currColor(2);
        img(1:100,b+1:imgW,3) = currColor(3);
    end
    imwrite(img,['./Results_HSV_Sorted/myLDA_Colors_nd_Words_512/k_',num2str(j),'.png']);
end
LDA_palettes_512 = LDA_palettes_512';
save(['./Results_HSV_Sorted/myLDA_Colors_nd_Words_512/LDA_palettes_512_K_',num2str(k),'.mat'],'LDA_palettes_512');

% sorted rgb order image
[sorted_LDA_palettes_512_sorted,x] = sort(LDA_palettes_512,2);
currColor = [255,0,0];
for j = 1:k
    img = uint8(0*ones(100,imgW,3));
    b = 0;   
    for i = 1:512
        numPx = sorted_LDA_palettes_512_sorted(j,i);
        if(numPx ~= 0)
            currColor(1) = res_rgbC(x(j,i)).R;
            currColor(2) = res_rgbC(x(j,i)).G;
            currColor(3) = res_rgbC(x(j,i)).B;
            img(1:100,b+1:b+numPx,1) = currColor(1);
            img(1:100,b+1:b+numPx,2) = currColor(2);
            img(1:100,b+1:b+numPx,3) = currColor(3);
                    
            b = b + numPx; 
        end
    end
    if(b < imgW)
        img(1:100,b+1:imgW,1) = currColor(1);
        img(1:100,b+1:imgW,2) = currColor(2);
        img(1:100,b+1:imgW,3) = currColor(3);
    end
    imwrite(img,['./Results_HSV_Sorted/myLDA_Colors_nd_Words_512/k_',num2str(j),'_sorted.png']);
end

% sort based on hue
HueCP = zeros(12,512);
for i = 1:k
    for h = 1:512
        HueCP(i,h) = LDA_palettes_512(i,hsv2rgbMap(h));  
    end
end

currColor = [255,0,0];
for j = 1:k
    img = uint8(0*ones(100,imgW,3));
    b = 0;
    for i = 1:512
        numPx = HueCP(j,i);
        if(numPx ~= 0)
            currColor(1) = hueSorted_res_rgbC(i,1);
            currColor(2) = hueSorted_res_rgbC(i,2);
            currColor(3) = hueSorted_res_rgbC(i,3);
            img(1:100,b+1:b+numPx,1) = currColor(1);
            img(1:100,b+1:b+numPx,2) = currColor(2);
            img(1:100,b+1:b+numPx,3) = currColor(3);
                    
            b = b + numPx; 
        end
    end
    if(b < imgW)
        img(1:100,b+1:imgW,1) = currColor(1);
        img(1:100,b+1:imgW,2) = currColor(2);
        img(1:100,b+1:imgW,3) = currColor(3);
    end  
    imwrite(img,['./Results_HSV_Sorted/myLDA_Colors_nd_Words_512/k_',num2str(j),'_hue_sorted.png']);
end
% sort 
[HueCPSorted,hx] = sort(HueCP,2);
currColor = [255,0,0];
for j = 1:k
    img = uint8(0*ones(100,imgW,3));
    b = 0;
    for i = 1:512
        numPx = HueCPSorted(j,i);
        if(numPx ~= 0)
            currColor(1) = hueSorted_res_rgbC(hx(j,i),1);
            currColor(2) = hueSorted_res_rgbC(hx(j,i),2);
            currColor(3) = hueSorted_res_rgbC(hx(j,i),3);
            img(1:100,b+1:b+numPx,1) = currColor(1);
            img(1:100,b+1:b+numPx,2) = currColor(2);
            img(1:100,b+1:b+numPx,3) = currColor(3);
                    
            b = b + numPx; 
        end
    end
    if(b < imgW)
        img(1:100,b+1:imgW,1) = currColor(1);
        img(1:100,b+1:imgW,2) = currColor(2);
        img(1:100,b+1:imgW,3) = currColor(3);
    end
    imwrite(img,['./Results_HSV_Sorted/myLDA_Colors_nd_Words_512/k_',num2str(j),'_hueSorted_Sorted.png']);
end
