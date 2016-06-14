for j = 1:5
        im(:,((j-1)*100+1):j*100,1) = repmat(img(j,1),[100,100]);
        im(:,((j-1)*100+1):j*100,2) = repmat(img(j,2),[100,100]);
        im(:,((j-1)*100+1):j*100,3) = repmat(img(j,3),[100,100]);
end

res_rgbC = load('Dataset/color_512/reshaped_rgbColorCubes_White255');
res_rgbC = res_rgbC.res_rgbC;

for j = 1
    yOffset = 0;
    for i = 1:5
            hold on
            rectangle('Position',[j-1, yOffset, 1, 1],...
                      'EdgeColor', 'none','FaceColor',...
                      1/255*[res_rgbC(cs(i)).R,res_rgbC(cs(i)).G,res_rgbC(cs(i)).B]);
            yOffset = yOffset + 1;
        end
    end
hold off
