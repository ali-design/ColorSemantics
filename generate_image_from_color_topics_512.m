function [LDA_palettes_512] = generate_image_from_color_topics_512(CP)

res_rgbC = load('./Dataset/color_512/reshaped_rgbColorCubes');
res_rgbC = res_rgbC.res_rgbC;

% CP a sparse matrix of size W x T, where W is the number of words in the 
% vocabulary and T is the number of topics. 
% CP(i,j) contains the number of times word i has been assigned to topic j. 
CP = bsxfun(@rdivide,CP,sum(CP(1:512,:)));
k = size(CP,2);

img = uint8(0*ones(100,500,3));
% 512 colors vs topics
LDA_palettes_512 = double(zeros(size(CP)));
for j = 1:k
    b = 0;
    for i = 1:512
        numPx = round(500*CP(i,j));
        img(1:100,b+1:b+numPx,1) = res_rgbC(i).R;
        img(1:100,b+1:b+numPx,2) = res_rgbC(i).G;
        img(1:100,b+1:b+numPx,3) = res_rgbC(i).B;
        if(i == 512)
            img(1:100,b+1:500,1) = res_rgbC(i).R;
            img(1:100,b+1:500,2) = res_rgbC(i).G;
            img(1:100,b+1:500,3) = res_rgbC(i).B;
        else
            b = b + numPx; 
        end
        LDA_palettes_512(i,j) = CP(i,j);
    end
    imwrite(img,['./Results_HSV_Sorted/myLDA_Colors_nd_Words_512/k_',num2str(j),'.png']);
end
LDA_palettes_512 = LDA_palettes_512';
save(['./Results_HSV_Sorted/myLDA_Colors_nd_Words_512/LDA_palettes_512_K_',num2str(k),'.mat'],'LDA_palettes_512');