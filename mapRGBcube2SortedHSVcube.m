function hsv2rgbMap = mapRGBcube2SortedHSVcube(hueSorted_res_rgbC,res_rgbC)
hsv2rgbMap = uint16(zeros(1,512));
for i = 1:512
    [~,indx]=ismember(hueSorted_res_rgbC(i,:),res_rgbC,'rows');
    hsv2rgbMap(i) = indx;
end
save('hsv2rgbMap.mat','hsv2rgbMap');