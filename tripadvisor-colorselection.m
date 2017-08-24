im = load('travel-trip.mat');
im = im.img;
timg = imread('tripadvisor.png');
qtimg = imgQuantizer('tripadvisor.png');
imshow(qtimg)
A = zeros(size(qtimg,1),size(qtimg,2));
for i=1:size(qtimg,1)
    for j=1:size(qtimg,2)
        for k=1:size(im,2)
            if(qtimg(i,j,1)==im(1,k,1)&&qtimg(i,j,2)==im(1,k,2)&&qtimg(i,j,3)==im(1,k,3))
                A(i,j) = 1;
            end
        end
    end
end
g = imread('tripadvisor_gray.png');
imshow(g)
g2 = g;
g2(:,:,1) = g(:,:,1).*A;
A = uint8(A);

g2(:,:,1) = g(:,:,1).*A;
g2(:,:,2) = g(:,:,2).*A;
g2(:,:,3) = g(:,:,3).*A;
imshow(g2)
A2 = ~A;
A2 = uint8(A2);
n = timg;

n(:,:,1) = timg(:,:,1).*A2;
n(:,:,2) = timg(:,:,2).*A2;
n(:,:,3) = timg(:,:,3).*A2;

f = n+g2;
imshow(f)
imwrite(f,'tripadvisor_processed');
imwrite(f,'tripadvisor_processed.png');
imwrite(timg,'tripadvisor_new.png');