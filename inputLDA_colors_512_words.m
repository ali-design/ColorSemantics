function[WS,DS,CS,CDS,noMachWord]=inputLDA_colors_512_words(vocabName)

wordsPath = 'Dataset/words_per_cover/';
dirWordsPath = dir([wordsPath,'*.mat']);
count = numel(dirWordsPath);
fprintf('Number of cover images in .mat format: %d \n',count);
imgsPath = 'Dataset/color_512/iRGB_512_200x150px/';
dirIRGB512 = dir([imgsPath,'*.mat']);
sizeIRGB512 = size(dirIRGB512,1);

tic
matchNum = 0;
noMachNum = 0;
noMachWordNum = 0;
noMachWord = {};
unknownWords = 0;
list = {};

WS = [];
DS = [];
CS = [];
CDS = [];
if(isempty(vocabName))
    vocab = load('Dataset/words_vocab');
else
    str = ['Dataset/words_vocab_',vocabName];
    vocab = load(str);
end
vocab = vocab.words_vocab;
numV = size(vocab,1);
c = 1;
prevDoc = {};
currentDoc = {};
while (c <=count)
    [pt,wordsMatName,ext] = fileparts(dirWordsPath(c).name);
    k = 1;
    currentDoc = {};
    while(k <= sizeIRGB512)
        [pt,IRGB512Name,ext] = fileparts(dirIRGB512(k).name);
        
        if(strcmp([wordsMatName,'_cInx512'],IRGB512Name)||...
           strcmp([wordsMatName,'_small02_clb_p_cInx512'],IRGB512Name))
            if(isempty(prevDoc))
                prevDoc = dirIRGB512(k).name; % must be init
            end
            currentDoc = dirIRGB512(k).name;
            break;
        end
        k = k + 1;
    end  
    if(~isempty(currentDoc))

        dataMat = load(dirWordsPath(c).name);     
        dataMat = dataMat.text;
        [m,n] = size(dataMat);
        for i = 1:m
            breakIt = '';
            tempText = {};
            tT = 0;
            text = dataMat{i,1};
            if(findstr(text,' '))
                breakIt = ' ';
                remain = text;
                while true
                    [str, remain] = strtok(remain,' ');
                    if(isempty(str))  
                        break;  
                    end
                    tT = tT + 1;
                    tempText{tT,1} = str;
                end
            end      
            if(findstr(text,'-'))
                breakIt = '-';
                remain = text;
                while true
                    [str, remain] = strtok(remain,'-');
                    if(isempty(str))  
                        break;  
                    end
                    tT = tT + 1;
                    tempText{tT,1} = str;
                end
            end
            if(~isempty(breakIt))
                dataMat = vertcat(dataMat,tempText);
                [m,n] = size(dataMat);
            end
        end
        
        ws = zeros(1,m);
        
        for i = 1:m
            text = dataMat{i,1};
            if(isa(text,'double'))
                text = num2str(text);
            end
            text = porterStemmer(lower(text));
            j = 1;
            while(j <= numV)
                if(strcmp(text, vocab{j,1}))
                    ws(i) = j;
                    break;
                end
                j = j + 1;
            end
            if(ws(i) == 0)
                unknownWords = unknownWords+1;
                fprintf('unknown word:%s in %s',text,dirWordsPath(c).name); 
            end
        end
        
        if(sum(ws) > 0) % otherwise this doc should not be considered
            matchNum = matchNum + 1;
            fprintf('create WS %d for %s ... \n',matchNum,currentDoc);
            ws(ws==0) = [];
            WS = horzcat(WS,ws);
            fprintf('create DS %d ... \n',matchNum);
            ds = matchNum * ones(size(ws)); 
            DS = horzcat(DS,ds);
            list{matchNum} = currentDoc;
            % now index colors for file currentDoc
            dataMat = load(currentDoc,'-ascii');         
            fprintf('create CS %d ... \n',matchNum);
            CS = horzcat(CS,dataMat);
            fprintf('create CDS %d ... \n',matchNum);
            CDSc = matchNum * ones(size(dataMat));
            CDS = horzcat(CDS,CDSc);

        else % this document doesn't have any word
            fprintf('No match #%d : %s... \n',c,wordsMatName);
            noMachNum = noMachNum + 1;
            noMachWord{noMachNum,1} = wordsMatName;
        end
    else % for this document, word file and img file don't match
        fprintf('No match #%d : %s... \n',c,wordsMatName);
        noMachWordNum = noMachWordNum + 1;
        
    end
    c = c + 1;
end

% now generate a list of all contributed documents:
imgInxList = generateDocFromList(list);

% Finally, save all:
fprintf('Saving WS and DS ... \n');
if(isempty(vocabName))
    save('Dataset/inputLDA_mats/WS_C-nd-W_512.mat','WS','-ascii');
    save('Dataset/inputLDA_mats/DS_C-nd-W_512.mat','DS','-ascii');

    fprintf('Saving CS and CDS ... \n');
    save('Dataset/inputLDA_mats/CS_C-nd-W_512.mat','CS','-ascii');
    save('Dataset/inputLDA_mats/CDS_C-nd-W_512.mat','CDS','-ascii');    

    fprintf('Saving docuemnt list ... \n');
    save('Dataset/inputLDA_mats/DocList_C-nd-W_512.mat','imgInxList');
else
    save(['Dataset/inputLDA_mats/WS_C-nd-W_512','_',vocabName,'.mat'],...
          'WS','-ascii');
    save(['Dataset/inputLDA_mats/DS_C-nd-W_512','_',vocabName,'.mat'],...
          'DS','-ascii');

    fprintf('Saving CS and CDS ... \n');
    save(['Dataset/inputLDA_mats/CS_C-nd-W_512','_',vocabName,'.mat'],...
          'CS','-ascii');
    save(['Dataset/inputLDA_mats/CDS_C-nd-W_512','_',vocabName,'.mat'],...
          'CDS','-ascii');
    fprintf('Saving docuemnt list ... \n');
    save('Dataset/inputLDA_mats/DocList_C-nd-W_512','_',vocabName,'.mat',...
         'imgInxList');
end
toc