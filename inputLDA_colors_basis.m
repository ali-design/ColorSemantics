function [CS,CDS] = inputLDA_colors_basis(colorBasis_name)

if(strcmp(colorBasis_name,'Kob'))
    [CS,CDS] = inputLDA_color_basis_Kob;

elseif(strcmp(colorBasis_name,'Kuler'))
    [CS,CDS] = inputLDA_color_basis_Kuler;

elseif(strcmp(colorBasis_name,'Matsuda_hue'))
    [CS,CDS] = inputLDA_color_basis_Matsuda_hue;
    
end