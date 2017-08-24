close all
load wordstopics_30wordsPerTopic_noTopicWeight;
% user entered 'gardens'
ix = find(cellfun(@(c)(isequal(c,'business')),vocab(:)));
%ix = find(cellfun(@(c)(isequal(c,'loves')),vocab(:)));
%ix = find(cellfun(@(c)(isequal(c,'news')),vocab(:)));
%ix = find(cellfun(@(c)(isequal(c,'technology')),vocab(:)));

ix1 = find(cellfun(@(c)(isequal(c,'technology')),vocab(:)));
ix2 = find(cellfun(@(c)(isequal(c,'fashion')),vocab(:)));
%ix3 = find(cellfun(@(c)(isequal(c,'animals')),vocab(:)));


%normalize weights
%so normWeights tell me how much of each topic is in this word entered by
%user:
normWeights = wordWeights(ix,:)/sum(wordWeights(ix,:));
normWeights1 = wordWeights(ix1,:);
normWeights2 = wordWeights(ix2,:);
normWeights = 0.2*normWeights1 + 0.8*normWeights2;
normWeights = normWeights / sum(normWeights);
% %normWeights = normWeights .* k_sizes;


% normWeights1 = wordWeights(ix1,:);
% normWeights2 = wordWeights(ix2,:);
% normWeights3 = wordWeights(ix3,:);
% normWeights = normWeights1 + normWeights2 + normWeights3;
% normWeights = normWeights / sum(normWeights);

% top N matches:
nMatch = 20;

res_LabC = load('reshaped_Lab512Cubes');
res_LabC = res_LabC.res_LabC;

LDA_512_hist_Palette = load('LDA_palettes_512_K_12'); % prop of 512 bins for 12 color topic hists
LDA_512_hist_Palette = LDA_512_hist_Palette.LDA_palettes_512;
LDA_palSize = size(LDA_512_hist_Palette);


mixedColorTopicHist = normWeights * LDA_512_hist_Palette;
%generate_image_from_mixedcolortopicshist_512(mixedColorTopicHist);
generate_image_from_mixedcolortopicshist_512_sortedHue(mixedColorTopicHist);
[A,ix] = sort(mixedColorTopicHist);
A = A(round(0.9*512):end);
ix = ix(round(0.9*512):end);

nColors2 = 512;
p2 = zeros(nColors2,3);
for j = 1:nColors2
	p2(j,:) = [res_LabC(j).L,res_LabC(j).a,res_LabC(j).b];
end

p2 = p2(ix,:);

% compare this new color topic with all magazine palettes:
[costStruct,distanceCost] = LDA_512_PaletteMatching(p2,A,nMatch);
distanceCostStruct{1,1}.cost = costStruct{1}.cost;
distanceCostStruct{1,2}.matchedPal = costStruct{1}.matchedPal;
distanceCostStruct{1,3}.name = ['K_',num2str(0),'_hist512'];
% disp(k);
    
% demo src color palettes and their matched kob 3-color-combinations
demoMatchedLDA_512_Palettes(distanceCostStruct);
%distCostKxMagPals(k,:) = distanceCost;

