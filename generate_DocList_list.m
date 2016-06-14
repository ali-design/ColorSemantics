% This generates DocList which is all the images in clb. No word
% transcription is considered here. For generating list of doc which have
% both colors and words, use generate_Doc

function [Doc_Colors_nd_Words] = generate_DocList_list

list = load('Dataset/DocList_used_Colors_Words_512');
list = list.list;
count = numel(list);
fprintf('Number of cover images: %d \n',count);
tic

c = 1;
n = 1;
d = 0;
f = 0;
agr = 0;
while (c <= count)
        if(isempty(list{c}))
        c = c + 1;
        continue;
    end
    [pathstr, fileName, ext] = fileparts(list{c});
    s = strfind(fileName, '_');
    if(numel(s) == 0)
        fprintf('Failed: %s \n',fileName);
        c = c + 1;
        continue;
    else
        name = fileName(1:(s(1)-1));
        n = c + 1;
        d = d + 1;
        while(n <= count)
            disp(n);
                if(isempty(list{n}))
        n = n + 1;
        continue;
    end
            [pathstr, fileName, ext] = fileparts(list{n});  
            s = strfind(fileName, '_');
            if(numel(s) == 0)
                fprintf('Failed2: %s \n',fileName);
                n = n + 1;
                continue;
            else
                nextName = fileName(1:(s(1)-1));
                if(strcmp(name,nextName))
                    d = d + 1;
                    n = n + 1;
                else
                    c = n;
                    break;
                end
            end
        end
    end
    if(d >= 1)      
        f = f + 1;
        imgInxList{f,1} = name;
        imgInxList{f,2} = d;
        c = n;
        agr = agr + d;
        d = 0;
    end
end

save('Dataset/DocList_1','imgInxList');
toc