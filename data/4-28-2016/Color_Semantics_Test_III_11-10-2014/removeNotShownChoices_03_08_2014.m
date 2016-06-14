function [validRows,pruned] = removeNotShownChoices_03_08_2014(data)
% data is from col V10 to end.
% validRows are indices of valid responses.
% pruned data is data that we use for results.
% After endRow, the right answer is in the options. 
% so we need to remove those resonses where the answer was
% not shown. For participants in rows [3,172].

pruned = data;
[nRow,nCol] = size(data);

% 'DO-Q-q_k_r' <= k=1:12, r=1:2
choicesStartCol = 336;
choicesEndCol = 359;

% question list: e.g.: 'DO-BR-FL_6'
qList{1} = 'DO-BR-FL_6';
qList{2} = 'DO-BR-FL_34';

for j = choicesStartCol:choicesEndCol
   % extract k and r
   kr = cell2mat(textscan(pruned{1,j},'DO-Q-q_k_%d_%d'));
   k = kr(1);
   r = kr(2);
    
   for i = 3:nRow
      % if there is no k, then null responses for q_k_r_q
      if isempty(pruned{i,j})
          continue;
      end
      choices = cell2mat(textscan(pruned{i,j},'%d|%d|%d|%d'));
      if(~ismember(k,choices))
          % first, make the responses of this user to null
          for q = 1:13
             str = ['q_k_',num2str(k),'_',num2str(r),'_',num2str(q)];
             x = find(ismember(pruned(1,:),str));
             pruned{i,x} = '';            
          end
          % second, make this choices null
          pruned{i,j} = '';
          % third, exclude this question from list of Questions 
          % of this user 
          if (r == 1)
              x1 = find(ismember(pruned(1,:),qList{1}));
              questions = cell2mat(textscan(pruned{i,x1},...
                                   'Q%d|Q%d|Q%d|Q%d|Q%d|Q%d|Q%d|Q%d'));
              c2 = ismember(questions,k);
              if(find(c2))
                  str = '';
                  for m = 1:8
                      if(~c2(m))
                          str = [str,'Q',num2str(questions(m)),'|'];
                      else
                          str = [str,'Q999|'];
                      end
                  end
                  if(str(end) == '|')
                     str = str(1:end-1); 
                  end
                  pruned{i,x1} = str;
              end
          elseif (r == 2)
              x1 = find(ismember(pruned(1,:),qList{2}));
              questions = cell2mat(textscan(pruned{i,x1},...
                                   'Q%d|Q%d|Q%d|Q%d|Q%d|Q%d|Q%d|Q%d'));
              c2 = ismember(questions,k+12);
              if(find(c2))
                  str = '';
                  for m = 1:8
                      if(~c2(m))
                          str = [str,'Q',num2str(questions(m)),'|'];
                      else
                          str = [str,'Q999|'];
                      end
                  end
                  if(str(end) == '|')
                     str = str(1:end-1); 
                  end
                  pruned{i,x1} = str;
              end
          end
      end
   end
end

% remove all Q999's
for b = 1:2
    for i = 3:nRow
        x = find(ismember(pruned(1,:),qList{b}));
        str = [pruned{i,x},'|'];
        str = strrep(str,'Q999|','');
        pruned{i,x} = str(1:end-1);
    end
end

% remove participants with all null responses
respStartCol_1 = 18;
respEndCol_1 = 173;
respStartCol_2 = 177;
respEndCol_2 = 332;

X = [1:nRow]';

for i = 3:nRow
        R1 = pruned(i,respStartCol_1:respEndCol_1);
        R1 = R1(~cellfun('isempty',R1));
        R2 = pruned(i,respStartCol_2:respEndCol_2);
        R2 = R2(~cellfun('isempty',R2));
        if (isempty(R1)&&isempty(R2))
            X(i,1) = 0;
            
        end
        % remove previews (null agreements)
        if isempty(pruned{i,3})
            X(i,1) = 0;
        end
        
end
X(X == 0) = [];
pruned = pruned(X,:);
validRows = X;

save Color_Semantics_Test_II_03_08_2014.mat validRows pruned data;
