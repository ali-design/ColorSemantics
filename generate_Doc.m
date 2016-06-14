% This generates a list of all images which also have their text
% transcriptions filed. This is what should be used in LDA_Color_nd_Word

function [Doc_Colors_nd_Words] = generate_Doc
clc
startup;
coverImgPath = 'Dataset/words_per_cover/';
dirCoverImg = dir([coverImgPath,'*.mat']);

count = numel(dirCoverImg);
fprintf('Number of cover images which have associated words: %d \n',count);
tic

imgsPath = 'Dataset/color_512/iRGB_512_200x150px/';
dirIRGB512 = dir([imgsPath,'*.mat']);
sizeIRGB512 = size(dirIRGB512,1);


c = 1;
n = 1;
d = 0;
f = 0;
agr = 0;
matchNum = 0;
while (c <= count)
    [pathstr, fileName, ext] = fileparts(dirCoverImg(c).name);
    k = 1;
    currentDoc = {};
    while(k <= sizeIRGB512)
        [pt,IRGB512Name,ext] = fileparts(dirIRGB512(k).name);
        
        if(strcmp([fileName,'_cInx512'],IRGB512Name)||...
           strcmp([fileName,'_small02_clb_p_cInx512'],IRGB512Name))
            currentDoc = dirIRGB512(k).name;
            break;
        end
        k = k + 1;
    end  

    if(~isempty(currentDoc))
        matchNum = matchNum + 1;
    
    
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
            [pathstr, fileName, ext] = fileparts(dirCoverImg(n).name);  
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
        imgInx{f,1} = name;
        imgInx{f,2} = d;
        c = n;
        agr = agr + d;
        d = 0;
    end
    else
        c = c+1;
    end

end

save('Dataset/Doc_Colors_nd_Words','imgInx');
toc