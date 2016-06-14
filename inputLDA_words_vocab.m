function [WS,DS] = inputLDA_words_vocab
startup;
dataPath = 'Dataset/words_per_cover/';
dirDataPath = dir([dataPath,'*.mat']);
count = numel(dirDataPath);
fprintf('Number of cover images in .mat format: %d \n',count);
tic

WS = [];
DS = [];
vocab = load('words_vocab');
vocab = vocab.words_vocab;
numV = size(vocab,1);
c = 1;
while (c <= count)
    dataMat = load(dirDataPath(c).name);
    data = dataMat.text;
    [m,n] = size(data);
    ws = zeros(1,m);
    for i = 1:m
        text = data{i,1};
        if(isa(text,'double'))
            text = num2str(text);
        end
        text = lower(text);
        j = 1;
        while(j <= numV)
            if(strcmp(text, vocab{j,1}))
                break;
            end
            j = j + 1;
        end
        ws(i) = j;
    end
    fprintf('create WS %d ... \n',c);
    WS = horzcat(WS,ws);
    fprintf('create DS %d ... \n',c);
    ds = c * ones(size(ws)); 
    DS = horzcat(DS,ds);
    c = c + 1;
end
fprintf('Saving WS and DS ... \n');
save('Results/Output_mats/WS.mat','WS','-ascii');
save('Results/Output_mats/DS.mat','DS','-ascii');
toc