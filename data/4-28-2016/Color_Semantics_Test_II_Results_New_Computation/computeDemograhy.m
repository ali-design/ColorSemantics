function [pruned_female, pruned_male, pruned_noVCD, pruned_VCD, ...
 pruned_US, pruned_nonUS] = computeDemograhy(pruned)

gender = cell2mat(pruned(3:end,5));
uGender = unique(gender);
age = cell2mat(pruned(3:end,6)) + 17;
uAge = unique(age);
numCntry = cell2mat(pruned(3:end,7));
uNumCntry = unique(numCntry);
cntry = cell2mat(pruned(3:end,8));
uCntry = unique(cntry);
lang = cell2mat(pruned(3:end,10));
uLang = unique(lang);
edu = cell2mat(pruned(3:end,11));
uEdu = unique(edu);
vcdEx = cell2mat(pruned(3:end,12));
uVcdEx = unique(vcdEx);
hrWeb = cell2mat(pruned(3:end,13));
uHrWeb = unique(hrWeb);

[genderNum, genderInx] = hist(gender,uGender);
[ageNum, ageInx] = hist(age,uAge);
[numCntryNum, numCntryInx] = hist(numCntry,uNumCntry);
[cntryNum, cntryInx] = hist(cntry,uCntry);
[langNum, langInx] = hist(lang,uLang);
[eduNum, eduInx] = hist(edu,uEdu);
[vcdExNum, vcdExInx] = hist(vcdEx,uVcdEx);
[hrWebNum, hrWebInx] = hist(hrWeb,uHrWeb);

x = find(ismember([pruned{3:end,5}],1)');
prunedVals = pruned(3:end,:);
pruned_male = prunedVals(x,:);

x = find(ismember([pruned{3:end,5}],2)');
prunedVals = pruned(3:end,:);
pruned_female = prunedVals(x,:);

x = find(ismember([pruned{3:end,12}],1)');
prunedVals = pruned(3:end,:);
pruned_noVCD = prunedVals(x,:);

v = cell2mat(pruned(3:end,12));
for i = 1:size(v,1)
    if (v(i,1) >= 3)
        v(i,1) = 3;
    end
end
x = find(ismember(v,3));
prunedVals = pruned(3:end,:);
pruned_VCD = prunedVals(x,:);

x = find(ismember([pruned{3:end,8}],230)');
prunedVals = pruned(3:end,:);
pruned_US = prunedVals(x,:);

v = find(~ismember([pruned{3:end,8}],230)');
prunedVals = pruned(3:end,:);
pruned_nonUS = prunedVals(v,:);

% add headers
p = pruned(1:2,:);
pruned_female = vertcat(p,pruned_female);
pruned_male = vertcat(p,pruned_male);
pruned_noVCD = vertcat(p,pruned_noVCD);
pruned_VCD = vertcat(p,pruned_VCD);
pruned_US = vertcat(p,pruned_US);
pruned_nonUS = vertcat(p,pruned_nonUS);

save demography_03_08_2014.mat

