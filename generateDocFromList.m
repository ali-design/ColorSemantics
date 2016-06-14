% This generates list of documents from list: it finds magazine titles and
% their corresponding issue numbers. E.g. Academe with 40 issues.

function [imgInxList] = generateDocFromList(list)

count = numel(list);
fprintf('Generating list of documents ...\nNumber of cover images: %d \n',count);
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
toc