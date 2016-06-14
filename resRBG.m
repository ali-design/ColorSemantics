c = 0;
for k = 1:16
    for j = 1:16
        for i = 1:16
            c = c + 1;
            res_rgbC(c).R = RGBCubes(i,j,k).R;
            res_rgbC(c).G = RGBCubes(i,j,k).G;
            res_rgbC(c).B = RGBCubes(i,j,k).B;
        end
    end
end

            