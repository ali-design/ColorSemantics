function [CS,CDS] = inputLDA_color_basis_Kob
startup;
dataPath = 'Dataset/kob_1170/Kob_img_mats/';
dirDataPath = dir([dataPath,'*.mat']);
count = numel(dirDataPath);
fprintf('Number of cover images in .mat format: %d \n',count);
CS = [];
CDS = [];
c = 1;
while (c <= count)
    dataMat = load([dataPath,dirDataPath(c).name],'-ascii');
    csImg = [];
    for i = 1:1170
        if(dataMat(i) == 0)
            csBuf = 1171*ones(1,1);
        else
            csBuf = i*ones(1,dataMat(i));
        end
        csImg = horzcat(csImg,csBuf);
    end
    fprintf('create CS %d ... \n',c);
    CS = horzcat(CS,csImg);
    fprintf('create CDS %d ... \n',c);
    CDSc = c * ones(size(csImg));
    CDS = horzcat(CDS,CDSc);
    c = c + 1;
end
fprintf('Saving CS and CDS ... \n');
save('Results/Output_mats/CS_Kob.mat','CS','-ascii');
save('Results/Output_mats/CDS_Kob.mat','CDS','-ascii');