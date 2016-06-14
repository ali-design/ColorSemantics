% % Extract data(V10:end)
importXlxFile; 
% % save usable data in Color_Semantics_Test_II_03_08_2014.mat 
[validRows,pruned] = removeNotShownChoices_03_08_2014(data);


[wTotal,bTotal,wcTotal,confusionMatrix,q,r_hat,var_r_hat,var_confusionMatrix_hat,NoA_percent] = extractSurvey(pruned);
% similarly for second confusion matrix
[wTotal2,bTotal2,wcTotal2,confusionMatrix2,q2,r_hat2,var_r_hat2,var_confusionMatrix_hat2,NoA_percent2] = extractSurvey2(pruned);


% for demography and pruned data on gender, designer vs non-designer, and
% US vs non-US participants
[pruned_female, pruned_male, pruned_noVCD, pruned_VCD, ...
 pruned_US, pruned_nonUS] = computeDemograhy(pruned);

[wTotal_female1,bTotal_female1,wcTotal_female1,confusionMatrix_female1,q_female1,r_hat_female1,var_r_hat_female1,var_confusionMatrix_hat_female1] = extractSurvey(pruned_female);
[wTotal_female2,bTotal_female2,wcTotal_female2,confusionMatrix_female2,q_female2,r_hat_female2,var_r_hat_female2,var_confusionMatrix_hat_female2] = extractSurvey2(pruned_female);

[wTotal_male1,bTotal_male1,wcTotal_male1,confusionMatrix_male1,q_male1,r_hat_male1,var_r_hat_male1,var_confusionMatrix_hat_male1] = extractSurvey(pruned_male);
[wTotal_male2,bTotal_male2,wcTotal_male2,confusionMatrix_male2,q_male2,r_hat_male2,var_r_hat_male2,var_confusionMatrix_hat_male2] = extractSurvey2(pruned_male);

[wTotal_VCD1,bTotal_VCD1,wcTotal_VCD1,confusionMatrix_VCD1,q_VCD1,r_hat_VCD1,var_r_hat_VCD1,var_confusionMatrix_hat_VCD1] = extractSurvey(pruned_VCD);
[wTotal_VCD2,bTotal_VCD2,wcTotal_VCD2,confusionMatrix_VCD2,q_VCD2,r_hat_VCD2,var_r_hat_VCD2,var_confusionMatrix_hat_VCD2] = extractSurvey2(pruned_VCD);

[wTotal_noVCD1,bTotal_noVCD1,wcTotal_noVCD1,confusionMatrix_noVCD1,q_noVCD1,r_hat_noVCD1,var_r_hat_noVCD1,var_confusionMatrix_hat_noVCD1] = extractSurvey(pruned_noVCD);
[wTotal_noVCD2,bTotal_noVCD2,wcTotal_noVCD2,confusionMatrix_noVCD2,q_noVCD2,r_hat_noVCD2,var_r_hat_noVCD2,var_confusionMatrix_hat_noVCD2] = extractSurvey2(pruned_noVCD);

[wTotal_US1,bTotal_US1,wcTotal_US1,confusionMatrix_US1,q_US1,r_hat_US1,var_r_hat_US1,var_confusionMatrix_hat_US1] = extractSurvey(pruned_US);
[wTotal_US2,bTotal_US2,wcTotal_US2,confusionMatrix_US2,q_US2,r_hat_US2,var_r_hat_US2,var_confusionMatrix_hat_US2] = extractSurvey2(pruned_US);

[wTotal_nonUS1,bTotal_nonUS1,wcTotal_nonUS1,confusionMatrix_nonUS1,q_nonUS1,r_hat_nonUS1,var_r_hat_nonUS1,var_confusionMatrix_hat_nonUS1] = extractSurvey(pruned_nonUS);
[wTotal_nonUS2,bTotal_nonUS2,wcTotal_nonUS2,confusionMatrix_nonUS2,q_nonUS2,r_hat_nonUS2,var_r_hat_nonUS2,var_confusionMatrix_hat_nonUS2] = extractSurvey2(pruned_nonUS);

r_hat_genderDiff_1 = abs(r_hat_female1 - r_hat_male1);
r_hat_genderDiff_2 = abs(r_hat_female2 - r_hat_male2);
r_hat_vcdDiff_1 = abs(r_hat_VCD1 - r_hat_noVCD1);
r_hat_vcdDiff_2 = abs(r_hat_VCD2 - r_hat_noVCD2);
r_hat_US_nonUS_Diff_1 = abs(r_hat_nonUS1 - r_hat_US1);
r_hat_US_nonUS_Diff_2 = abs(r_hat_nonUS2 - r_hat_US2);

save results_03_08_2014.mat;