function [CS,CDS] = inputLDA_color_basis_KobBipart
startup;
dataMat = load('Dataset\kob_1170\matchedBipartKobImgPalettes');
dataMat = dataMat.distanceCostStruct;
count = size(dataMat,1);
fprintf('Number of cover images: %d \n',count);
CS = [];
CDS = [];

for i = 1:count
    csBuf = 1171*ones(1,1170);
    temp = dataMat{i,2}.kobIndex;
    for j = 1:10
        csBuf(1,temp(j)) = temp(j);
    end
    CS = horzcat(CS,csBuf);
    cdsBuf = i * ones(1,1170);
    CDS = horzcat(CDS,cdsBuf);
end
fprintf('Saving CS and CDS ... \n');
save('Results/Output_mats/CS_KobBipart.mat','CS','-ascii');
save('Results/Output_mats/CDS_Kob.matBipart','CDS','-ascii');