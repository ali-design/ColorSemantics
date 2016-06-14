function[WS,DS,CS,CDS,noMachWord]=inputLDA_colors_512_words_DocListProblem(vocabName)

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
titles = {};
titleNum = 0;
perTitle = 1;

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
        matchNum = matchNum + 1;
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
            % first record document list
            sPDoc = strfind(prevDoc, '_');
            sCDoc = strfind(currentDoc, '_');
            prevDocStr = prevDoc(1:(sPDoc(1)-1));
            currentDocStr = currentDoc(1:(sCDoc(1)-1));
            if(strcmp(prevDocStr,currentDocStr) &&...
               ~strcmp(prevDoc,currentDoc))
                    perTitle = perTitle + 1;
                end
            if(isempty(title))
                prevDoc = currentDoc;
                titleNum = titleNum + 1;
                title{titleNum,1} = prevDocStr;
                title{titleNum,2} = perTitle;
                fprintf('Title %s with %d issues\n',prevDocStr,perTitle);
                perTitle = 1;
            else
                if(strcmp(title{titleNum,1},prevDocStr))
                    title{titleNum,2} = title{titleNum,2}+perTitle;
                end
                perTitle = 1;
                prevDoc = currentDoc;
            end
            % now create word indices
%            fprintf('create WS %d for %s ... \n',c,currentDoc);
%             % ws(ws==0) = [];
%             WS = horzcat(WS,ws);
%             fprintf('create DS %d ... \n',c);
%             ds = c * ones(size(ws)); 
%             DS = horzcat(DS,ds);
%             % now index colors for file currentDoc
%             dataMat = load(currentDoc,'-ascii');         
%             fprintf('create CS %d ... \n',c);
%             CS = horzcat(CS,dataMat);
%             fprintf('create CDS %d ... \n',c);
%             CDSc = c * ones(size(dataMat));
%             CDS = horzcat(CDS,CDSc);
            

                
        else % this document doesn't have any word
            fprintf('No match #%d : %s... \n',c,wordsMatName);
            noMachNum = noMachNum + 1;
            noMachWord{noMachNum,1} = wordsMatName;
            % but title should still be recorded:
            if(perTitle > 1)
                if(strcmp(title{titleNum,1},prevDocStr))
                    title{titleNum,2} = title{titleNum,2}+perTitle;
                else
                    titleNum = titleNum + 1;
                    title{titleNum,1} = prevDocStr;
                    title{titleNum,2} = perTitle;
                end
                fprintf('Title %s with %d issues\n',prevDocStr,perTitle);
                perTitle = 1;
                prevDoc = '';
            end
        end
    else % for this document, word file and img file don't match
        fprintf('No match #%d : %s... \n',c,wordsMatName);
        noMachWordNum = noMachWordNum + 1;
        
        % but title should still be recorded:
        if(perTitle > 1)
            if(strcmp(title{titleNum,1},prevDocStr))
                title{titleNum,2} = title{titleNum,2}+perTitle;
            else
            titleNum = titleNum + 1;
            title{titleNum,1} = prevDocStr;
            title{titleNum,2} = perTitle;
            end
            fprintf('Title %s with %d issues\n',prevDocStr,perTitle);
            perTitle = 1;
            prevDoc = currentDoc;
        end
    end
    c = c + 1;
end
fprintf('Saving WS and DS ... \n');
if(isempty(vocabName))
    save('Dataset/inputLDA_mats/WS.mat','WS','-ascii');
    save('Dataset/inputLDA_mats/DS.mat','DS','-ascii');

    fprintf('Saving CS and CDS ... \n');
    save('Dataset/inputLDA_mats/CS_512.mat','CS','-ascii');
    save('Dataset/inputLDA_mats/CDS_512.mat','CDS','-ascii');    
else
    save(['Dataset/inputLDA_mats/WS','_',vocabName,'.mat'],'WS','-ascii');
    save(['Dataset/inputLDA_mats/DS','_',vocabName,'.mat'],'DS','-ascii');

    fprintf('Saving CS and CDS ... \n');
    save(['Dataset/inputLDA_mats/CS_512','_',vocabName,'.mat'],'CS','-ascii');
    save(['Dataset/inputLDA_mats/CDS_512','_',vocabName,'.mat'],'CDS','-ascii');
end
toc