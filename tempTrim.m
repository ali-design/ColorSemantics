c = 1;
vocab = {};
%for i = 2:51
for i = 2:31
    for j = 1:2:24
        vocab{c} = wordTopics{i,j};
        c = c+1;
    end
end
vocab = unique(vocab);

vNum = size(vocab,2);
wordWeights = zeros(vNum,12);

for v = 1:vNum
    for k = 1:2:24
        ix = find(cellfun(@(c)(isequal(c,vocab{v})),wordTopics(:,k)));
        if(ix)
            %wordWeights(v,uint8((k+1)/2)) = wordTopics{1,k+1}*wordTopics{ix,k+1};
            wordWeights(v,uint8((k+1)/2)) = wordTopics{ix,k+1};
        end          
    end
end

% %find a word entered by user e.g. 'gardens'
% ix = find(cellfun(@(c)(isequal(c,'gardens')),vocab(:)));
% %normalize weights
% %so normWeights tell me how much of each topic is in this word entered by
% %user:
% normWeights = wordWeights(ix,:)/sum(wordWeights(ix,:));
% 
% %assume dist from each color topic to each color pal is in distCostKxMagPals 
% %distCostKxMagPals is then a matrix of 12x2654
% word2colorpalDist = normWeights * distCostKxMagPals;  
% % word2colorpalDist is a 1x2654 vect.
% [sorted_word2colorpalDist,ix_sorted_word2colorpalDist] = sort(word2colorpalDist);
% 
% %then use a function to show these pals which maximum of showMax, each pal
% %with it's weight (normaized distance) 
% 
% %showPal(sorted_word2colorpalDist,ix_sorted_word2colorpalDist,showMax)
