function [words_vocab] = generate_words_vocab
startup;
words_vocab = {};
coverImgPath = 'Dataset/words_per_cover/';
dirCoverImg = dir([coverImgPath,'*.mat']);

count = numel(dirCoverImg);
fprintf('Number of magazine titles : %d \n',count);
tic

c = 1;
while (c <= count)
    [pathstr, fileName, ext] = fileparts(dirCoverImg(c).name);
    data = load(dirCoverImg(c).name);
    fprintf('Working on %d: %s\n',c,fileName);
    data = data.text;
    [m,n] = size(data);
    for i = 1:m
        breakIt = '';
        tempText = {};
        tT = 0;
        text = data{i,1};
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
            data = vertcat(data,tempText);
            [m,n] = size(data);
        end
    end
    
    for i = 1:m
        text = data{i,1};
        if(isa(text,'double'))
            text = num2str(text);
        end
        lowerText = lower(text);
        text = porterStemmer(lowerText);
        if(isempty(words_vocab))
            words_vocab{1,1} = text;
            words_vocab{1,2} = lower(lowerText);
        else
            numV = size(words_vocab,1);
            j = 1;
            existFlag = 0;
            while(j <= numV)
                if(strcmp(text, words_vocab{j,1}))
                    existFlag = 1;
                    break;
                end
                j = j + 1;
            end
            if(~existFlag)
                words_vocab{j,1} = text;
                words_vocab{j,2} = lower(lowerText);
            end
        end
    end     
    c = c + 1;
end
save('Dataset/words_vocab_2cols','words_vocab');
save('Dataset/WO_words_vocab_2cols','words_vocab(:,2)');
toc