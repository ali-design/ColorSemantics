function [wTotal,bTotal,wcTotal,confusionMatrix,q,r_hat,var_r_hat,var_u_hat,NoA_percent2] = extractSurvey2(data)
confusionMatrix = double(zeros(12,12));
% Format of questions corresponding to color palettes is:
% in 1st closest palettes: k_1_1 ... k_12_1, so there are 12 questions
% Format of header in this survey result is DO-Q-q_k_1_1 for k_1_1. This
% col contains what word-clouds (wc) with what order was shown to the user.
% E.g. 1|12|5|13 means <wc_1_1, wc_12_1, wc_5_1, non of the above>

% Extract what was shown for each color palette, q
numQ = zeros(1,12);
wTotal = zeros(8,1);
wcTotal = {}; 
bTotal = {};
q = double(zeros(12,12));
m_ij = zeros(12,12);
m_i = zeros(1,12);
NoA_percent2 = zeros(12,1);
for k = 1:12
    str = ['DO-Q-q_k_', num2str(k), '_2'];
    [mem,memIx] = ismember(str, data(1,:));
    c = 0;% number of times each color palette (e.g. k_1_1) is shown
    % For each q extract what was shown
    R = data(3:end,memIx);   
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
    
    wc = zeros(8,13); % col 1:4 for n's, col 5:8 for m's 
    for j = 1:13
        for i = 1:numAns
            index = find([R{i,1}]==j);
            if(~isempty(index))
                wc(index,j) = wc(index,j) + 1; % this is n_i
            
                str2 = ['q_k_',num2str(k),'_2_',num2str(j)];
                [mem2,memIx2] = ismember(str2, data(1,:));
                R2 = data(3:end,memIx2);
                if(R2{i,1} == 1)
                    wc(index+4,j) = wc(index+4,j) + 1; % this is m_i
                end
            end
        end
    end
    
    % wc is info of all 12 word clouds shown/clicked for color palette k
    wcTotal{k} = wc; 
    % wTotal(1:4) is number of times an option is shown 
    % wTotal(5:8) an option is clicked                           
    % for None of the above:
    NoA_percent2(k,1) = wc(8,13)/wc(4,13);

    wTotal = wTotal + sum(wc,2);   
    
    b = double(zeros(3,12));
    b(1,:) = double(wc(1,1:12)/c); % b1 is prob of each wc is shown in 
                                   % position 1 for color palette k
    b(2,:) = double(wc(2,1:12)/c); 
    b(3,:) = double(wc(3,1:12)/c); 
    bTotal{k} = b;
    
    m_ij(k,:) = sum(wc(5:7,1:12)); % number of times wc's are clicked for k
    m_i(1,k) = c; % number of time each color palette is shown
    confusionMatrix(k,:) = m_ij(k,:) / m_i(1,k); 
         

end

% position bias
w = wTotal/max(wTotal);
% just want positions 1 ... 3
w1 = w(5,1); w2 = w(6,1); w3 = w(7,1);

for k = 1:12
    b = bTotal{k};
    for j = 1:12
%       djp = double(ones(1,12)) * 1/3 * 2/11;
%       djp(1,k) = 1/3;
%       q(k,:) = djp * (w1 + w2 + w3);
        b1 = b(1,j);
        b2 = b(2,j);
        b3 = b(3,j);
        q(k,j) = b1*w1 + b2*w2 + b3*w3;
    end
end

M_i = repmat(m_i',1,12);

r_hat = confusionMatrix ./ q;
var_r_hat = m_ij * (M_i * q - m_ij) ./ (M_i .^ 3 * q .^2);
var_u_hat = m_ij * (M_i * q - m_ij) ./ (M_i .^ 3);