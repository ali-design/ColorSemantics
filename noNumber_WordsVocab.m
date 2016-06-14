function [words_vocab] = noNumber_WordsVocab(words_vocab)

ix = regexp(words_vocab(:,1),'\d');


ix_size = size(ix,1);
for i = 1:ix_size
    if(~isempty(ix{i,1}))
        words_vocab{i,1} = '';
        words_vocab{i,2} = '';
    end
end

words_vocab1 = words_vocab(:,1);
words_vocab1 = words_vocab1(~cellfun('isempty',words_vocab1));
words_vocab2 = words_vocab(:,2);
words_vocab2 = words_vocab2(~cellfun('isempty',words_vocab2));


words_vocab = {};

words_vocab(:,1) = words_vocab1;
words_vocab(:,2) = words_vocab2;
save('Dataset/words_vocab_pruned_2cols','words_vocab');
save('Dataset/WO_words_vocab_pruned_2cols','words_vocab2');



