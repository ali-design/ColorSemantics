function [WS,DS,CS,CDS] = inputLDA_colors_words
startup;
wordsPath = 'Dataset/words_per_cover/';
dirWordsPath = dir([wordsPath,'*.mat']);
count = numel(dirWordsPath);
fprintf('Number of cover images in .mat format: %d \n',count);
imgsPath = 'Dataset/clb/';
dirTifs = dir([imgsPath,'*.tif']);
dirJpgs = dir([imgsPath,'*.jpg']);
sizeTifs = size(dirTifs,1);
sizeJpgs = size(dirJpgs,1);
tic

WS = [];
DS = [];
vocab = load('Results/Output_mats/words_vocab');
vocab = vocab.words_vocab;
numV = size(vocab,1);
c = 1;
currentDoc = {};
while (c <= count)
    [pt,wordsMatName,ext] = fileparts(dirWordsPath(c).name);
    k = 1;
    currentDoc = {};
    while(k <= sizeTifs)
        [pt,tifName,ext] = fileparts(dirTifs(k).name);
        if(strcmp(tifName,[wordsMatName,'_small02_clb']) ||...
            strcmp(tifName,[wordsMatName,'_small02_clb_p']))
            currentDoc = dirTifs(k).name;
            break;
        end
        k = k + 1;
    end
    if(isempty(currentDoc))
        k = 1;
        while(k <= sizeJpgs)
            [pt,jpgName,ext] = fileparts(dirJpgs(k).name);
            if(strcmp(jpgName,wordsMatName))
                currentDoc = dirJpgs(k).name;
                break;
            end
            k = k + 1;
        end
    end
    
    if(~isempty(currentDoc))
        dataMat = load(dirWordsPath(c).name);
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
        fprintf('create WS %d for %s ... \n',c,currentDoc);
        WS = horzcat(WS,ws);
        fprintf('create DS %d ... \n',c);
        ds = c * ones(size(ws)); 
        DS = horzcat(DS,ds);
        
        % now index colors for file currentDoc
        
        
        
    else
        fprintf('No match #%d : %s... \n',c,wordsMatName);
    end
    c = c + 1;
end
fprintf('Saving WS and DS ... \n');
save('Results/Output_mat/WS.mat','WS','-ascii');
save('Results/Output_mat/DS.mat','DS','-ascii');
toc