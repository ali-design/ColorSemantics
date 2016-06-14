function [words_vocab] = generate_words_vocab_pruned()
startup;
words_vocab = {};
coverImgPath = 'Dataset/TextTranscription_worldCat_noMasthead/words_per_cover/';
dirCoverImg = dir([coverImgPath,'*.mat']);

prunedWordsPath = 'Dataset/TextTranscription_worldCat_noMasthead/words_per_cover_pruned/';

stopWords = load('Dataset/TextTranscription_worldCat_noMasthead/stopWordsList');
stopWords = stopWords.stopWordsList';
stopWords_stem = {};
for i = 1:size(stopWords,2)
    stopWords_stem{1,i} = porterStemmer(stopWords{1,i});
end

myStopWords = load('Dataset/TextTranscription_worldCat_noMasthead/myStopWordsList');
myStopWords = myStopWords.mystopwords';
myStopWords_stem = {};
for i = 1:size(myStopWords,2)
   myStopWords_stem{1,i} = porterStemmer(myStopWords{1,i}); 
end
count = numel(dirCoverImg);
fprintf('Number of magazine titles : %d \n',count);
tic

c = 1;
while (c <= count)
    [pathstr, fileName, ext] = fileparts(dirCoverImg(c).name);
    data = load([coverImgPath,dirCoverImg(c).name]);
    fprintf('Working on %d: %s\n',c,fileName);
    data = data.text;  
    [m,n] = size(data);
    for i = 1:m
        breakIt = '';
        tempText = {};
        tT = 0;
        text = data{i,1};
        % if a string has more than one word, decompose it:
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
        % if a string is compound e.g. cutting-edge, decompose it
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
            data = vertcat(data,tempText);
            [m,n] = size(data);
        end
    end
    % purne
    % remove numbers:
    for i = 1:m
        if(~isa(data{i,1},'char'))
            data{i,1} = '';
        end
    end
    data = data(~cellfun('isempty',data));
    [m,n] = size(data);
    
    % lower, remove 's, and space at end, and map month to season
    data = lower(data);
    for i = 1:m
        text = data{i,1};
        text = strrep(text,' ','');
        text = strrep(text,'''s','');
        data{i,1} = text;
        switch text
            case {'january','february','march','april','may','june',...
                    'july','august','september','october','november',...
                    'december'}    
                data{i,1} = {};
            case 'man'
                data{i,1} = 'men';
            case 'woman'
                data{i,1} = 'women';
        end
    end
    data=data(~cellfun('isempty',data)); 
    % save this new data
    save([prunedWordsPath,dirCoverImg(c).name],'data');
    fprintf('Saving pruned words %d: %s\n',c,fileName);

    % now generate vocab
    [m,n] = size(data);
    for i = 1:m
        text = data{i,1};
        stemText = porterStemmer(text);
        if(isempty(words_vocab))
            words_vocab{1,1} = stemText;
            words_vocab{1,2} = text;
        else
            numV = size(words_vocab,1);
            j = 1;
            existFlag = 0;
            while(j <= numV)
                if(strcmp(stemText, words_vocab{j,1}))
                    existFlag = 1;
                    break;
                end
                j = j + 1;
            end
            if(~existFlag)
                words_vocab{j,1} = stemText;
                words_vocab{j,2} = text;
            end
        end
    end    
    
    c = c + 1;
end
% remove numbers from vocab:
words_vocab = noNumber_WordsVocab(words_vocab);

% remove stop words
[w ix] = setdiff(words_vocab(:,1),stopWords_stem,'stable');
w2 = words_vocab(ix,2);
words_vocab = {};
words_vocab(:,1) = w;
words_vocab(:,2) = w2;
%data = setdiff(data,myStopWords_stem,'stable');
[w ix] = setdiff(words_vocab(:,1),myStopWords_stem,'stable');
w2 = words_vocab(ix,2);
words_vocab = {};
words_vocab(:,1) = w;
words_vocab(:,2) = w2;

% % I want this
% words_vocab{size(words_vocab,1)+1,1} = 'new';
% words_vocab{size(words_vocab,1),2} = 'news';

words_vocab_col2 = words_vocab(:,2);    
save('Dataset/TextTranscription_worldCat_noMasthead/words_vocab_pruned_2cols','words_vocab');
save('Dataset/TextTranscription_worldCat_noMasthead/WO_words_vocab_pruned_2cols','words_vocab_col2');
toc
