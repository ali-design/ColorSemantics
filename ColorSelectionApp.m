close all
load wordstopics_30wordsPerTopic_noTopicWeight;
% user entered 'gardens'
%ix = find(cellfun(@(c)(isequal(c,'trip')),vocab(:)));
%normWeights = wordWeights(ix,:)/sum(wordWeights(ix,:));

ix1 = find(cellfun(@(c)(isequal(c,'trip')),vocab(:)));
ix2 = find(cellfun(@(c)(isequal(c,'travel')),vocab(:)));

normWeights1 = wordWeights(ix1,:);
normWeights2 = wordWeights(ix2,:);
normWeights = 0.5*normWeights1 + 0.5*normWeights2;

normWeights = normWeights / sum(normWeights);

res_LabC = load('reshaped_Lab512Cubes');
res_LabC = res_LabC.res_LabC;

LDA_512_hist_Palette = load('LDA_palettes_512_K_12'); % prop of 512 bins for 12 color topic hists
LDA_512_hist_Palette = LDA_512_hist_Palette.LDA_palettes_512;
LDA_palSize = size(LDA_512_hist_Palette);


mixedColorTopicHist = normWeights * LDA_512_hist_Palette;
generate_image_from_mixedcolortopicshist_512_sortedHue(mixedColorTopicHist);

AIx= find(mixedColorTopicHist);
A = mixedColorTopicHist(AIx);

nColors2 = 512;
p2 = zeros(nColors2,3);
for j = 1:nColors2
	p2(j,:) = [res_LabC(j).L,res_LabC(j).a,res_LabC(j).b];
end

p2 = p2(AIx,:);

imgO = imread('tripadvisor.png');
r_imgO = reshape(imgO,size(imgO,1)*size(imgO,2),3);
q = [0:32:256];
qImg = discretize(r_imgO,q);
qImg = q(qImg) + 16;
qImg = double(qImg)/255;
cform = makecform('srgb2lab');
rLab = double(applycform(qImg, cform));

for i = 1:size(r_imgO,1)
    flag = false;
    for j = 1:size(p2,1)
        if(rLab(i,:) == p2(j,:))
%             r_imgO(i,:) = [127,127,127];
%             indx(i,1) = 1;
            flag = true;
            break;
        end
    end
    if(~flag)
        r_imgO(i,:) = [127,127,127];
    end
end
imgF = reshape(r_imgO,size(imgO,1),size(imgO,2),3);

imshow(imgF);