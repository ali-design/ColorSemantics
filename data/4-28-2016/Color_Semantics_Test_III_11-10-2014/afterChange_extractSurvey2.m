function [wTotal2,b2,wcTotal2] = afterChange_extractSurvey2(data)

% Format of questions corresponding to color palettes is:
% in 1st closest palettes: k_1_1 ... k_12_1, so there are 12 questions
% Format of header in this survey result is DO-Q-q_k_1_1 for k_1_1. This
% col contains what word-clouds (wc) with what order was shown to the user.
% E.g. 1|12|5|13 means <wc_1_1, wc_12_1, wc_5_1, non of the above>

% Extract what was shown for each color palette, q
wTotal2 = zeros(8,1);
wcTotal2 = {}; 
b2 = double(zeros(3,12));
c = 0; % number of times each color palette (e.g. k_1_2) is shown
for k = 1:12
    str = ['DO-Q-q_k_', num2str(k), '_2'];
    [mem,memIx] = ismember(str, data(1,:));
    c = 0;
    % For each q extract what was shown
    R = data(173:end,memIx);
    %R = R(~cellfun('isempty',R));    
    numAns = size(R,1);
    for i = 1:numAns
       if(~isempty(R{i,1})) 
           R{i,1} = cell2mat(textscan(R{i,1},'%d|%d|%d|%d'));
           c = c + 1;
       end
    end
    
    % For each word-cloud (wc) find n_1 ... n_4 and m_1 ... m_4. 
    % Example for wc_1_1: n_1 = # wc_1_1 is shown in position 1
    %                     m_1 = # wc_1_1 is clicked in position 1
    
    wc = zeros(8,13); % row 1:4 for n's, row 5:8 for m's 
    for j = 1:13
        for i = 1:numAns
            index = find([R{i,1}]==j);
            if(~isempty(index))
                wc(index,j) = wc(index,j) + 1; % this is n_i
            
                str2 = ['q_k_',num2str(k),'_2_',num2str(j)];
                [mem2,memIx2] = ismember(str2, data(1,:));
                R2 = data(173:end,memIx2);
                if(R2{i,1} == 1)
                    wc(index+4,j) = wc(index+4,j) + 1; % this is m_i
                end
            end
        end
    end
    wcTotal2{k} = wc;
    b2(1,k) = double(wc(1,k)/c); % b1 is prob of wc is shown in pos 1
    b2(2,k) = double(wc(2,k)/c);
    b2(3,k) = double(wc(3,k)/c);
    wTotal2 = wTotal2 + sum(wc,2);
end