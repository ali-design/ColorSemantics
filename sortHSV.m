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
