function generate_all_words_pruned
startup;
prunedWordsPath = 'Dataset/words_per_cover_pruned/';
dirPrunedWordsPath = dir([prunedWordsPath,'*.mat']);

fid = fopen('all_words_pruned.txt','w');
count = numel(dirPrunedWordsPath);
tic

c = 1;
while (c <= count)
    [pathstr, fileName, ext] = fileparts(dirPrunedWordsPath(c).name);
    data = load(dirPrunedWordsPath(c).name);
    data = data.text;  
    [m,n] = size(data);
    for i = 1:m
        fprintf(fid,'%s\n',data{i,1});
    end      
    c = c + 1;
end
fclose(fid);
toc
