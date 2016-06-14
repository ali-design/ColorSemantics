function[WS,DS,CS,CDS,noMachWord]=inputLDA_colors_Kob_words(vocabName)
startup;
wordsPath = 'Dataset/words_per_cover/';
dirWordsPath = dir([wordsPath,'*.mat']);
count = numel(dirWordsPath);
fprintf('Number of cover images in .mat format: %d \n',count);
imgsPath = 'Dataset/kob_1170/Kob_img_mats/';
dirKobs = dir([imgsPath,'*.mat']);
sizeKobs = size(dirKobs,1);

tic
noMachNum = 0;
noMachWordNum = 0;
noMachWord = {};
WS = [];
DS = [];
CS = [];
CDS = [];
if(isempty(vocabName))
    vocab = load('Results/Output_mats/words_vocab.mat');
else
    str = ['Results/Output_mats/words_vocab_',vocabName];
    vocab = load(str);
end
vocab = vocab.words_vocab;
numV = size(vocab,1);
c = 1;
currentDoc = {};
while (c <= count)
    [pt,wordsMatName,ext] = fileparts(dirWordsPath(c).name);
    k = 1;
    currentDoc = {};
    while(k <= sizeKobs)
        [pt,KobsName,ext] = fileparts(dirKobs(k).name);
        if(strcmp(KobsName,[wordsMatName,'_small02_clb_kob1170']) ||...
           strcmp(KobsName,[wordsMatName,'_small02_clb_p_kob1170']) || ...
           strcmp(KobsName,[wordsMatName,'_kob1170']))
            currentDoc = dirKobs(k).name;
            break;
        end
        k = k + 1;
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
                    ws(i) = j;
                    break;
                end
                j = j + 1;
            end
        end
        
        if(sum(ws) > 0) % otherwise this doc should not be considered
            fprintf('create WS %d for %s ... \n',c,currentDoc);
            ws(ws==0) = [];
            WS = horzcat(WS,ws);
            fprintf('create DS %d ... \n',c);
            ds = c * ones(size(ws)); 
            DS = horzcat(DS,ds);
            % now index colors for file currentDoc
            dataMat = load(currentDoc,'-ascii');
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
        else
            fprintf('No match #%d : %s... \n',c,wordsMatName);
            noMachNum = noMachNum + 1;
            noMachWord{noMachNum,1} = wordsMatName;
        end
    else
        fprintf('No match #%d : %s... \n',c,wordsMatName);
        noMachWordNum = noMachWordNum + 1;
    end
    c = c + 1;
end
fprintf('Saving WS and DS ... \n');
save(['Results/Output_mats/WS','_',vocabName,'.mat'],'WS','-ascii');
save(['Results/Output_mats/DS','_',vocabName,'.mat'],'DS','-ascii');

fprintf('Saving CS and CDS ... \n');
save(['Results/Output_mats/CS_Kob','_',vocabName,'.mat'],'CS','-ascii');
save(['Results/Output_mats/CDS_Kob','_',vocabName,'.mat'],'CDS','-ascii');
toc