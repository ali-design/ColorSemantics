function read_words_from_Xls_mats(cover_words_data_path,words_per_cover_path)
startup;
coverImgPath = [cover_words_data_path,'/'];
dirCoverImg = dir([coverImgPath,'*.mat']);
outputPath = [words_per_cover_path,'/'];

count = numel(dirCoverImg);
fprintf('Number of magazine titles : %d \n',count);
tic

for c=1:count
    [pathstr, fileName, ext] = fileparts(dirCoverImg(c).name);
    data = load([coverImgPath,fileName]);
    data = data.textfromMagazineCovers;
    [m,n] = size(data);
    emptyColFound = 0;
    for i = 1:n
        if(~emptyColFound)
            coverName = data{1,i};
            if(isempty(coverName))
                fprintf('problem saving in col# %d of %s\n',i,fileName);
                emptyColFound = 1;
                break;
            end
            coverName = strrep(coverName,' ','-');
            coverName = strrep(coverName,'&','and');
        
            text = data(2:m,i);
            text = text(~cellfun('isempty',text));

            save([outputPath,coverName],'text');
        end
    end        
end
toc