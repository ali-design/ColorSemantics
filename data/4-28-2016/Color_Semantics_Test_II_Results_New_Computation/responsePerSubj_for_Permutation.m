% importXlxFile; 
% % % save usable data in Color_Semantics_Test_II_03_08_2014.mat 
% [validRows,pruned] = removeNotShownChoices_03_08_2014(data);
% sR = size(pruned,1) - 2;

subjInx = zeros(sR*12,12);
%each row is a subject_trial for topic (color-word) k, 
%col 1: = 1, if subject chose right word cloud for the color pal
%col 2: = 1, if subject chose at least one of the two other word clouds
%col 3: = 1, if subject chose None of the above (could potentialy choose all options as well as None of the above!)
%col 4: = k (index of the color topic)
%col 5: index of word cloud shown in position 1
%col 6: index of word cloud shown in position 2
%col 7: index of word cloud shown in position 3
%col 8: index of word cloud shown in position 4
%col 9: = 1 if subject chose word cloud shown in position 1
%col 10: = 1 if subject chose word cloud shown in position 2
%col 11: = 1 if subject chose word cloud shown in position 3
%col 12: = 1 if subject chose word cloud shown in position 4

c = 0;
for i = 1:sR
    for j = 18:13:173
        c = c + 1;
        R = pruned(i+2,j:j+12);
        RR = R;
        k = (j-18)/13 + 1;
        if(~isempty(R(~cellfun('isempty',R))))
            subjInx(c,4) = k;
            if(~isempty(cell2mat(R(1,k))) && k ~=13)
                subjInx(c,1) = 1;
            end
            if(~isempty(cell2mat(R(1,13))))
                subjInx(c,3) = 1;
            end
            R{1,13} = '';
            R{1,k} = '';
            if(~isempty(R(~cellfun('isempty',R))))
                subjInx(c,2) = 1;
            end
        end
        % for this subj find, for e.g. k = 3, col that is in DO-Q-q_k_3_1
        % if it not empty, e.g. 3|10|4|13 means wc_3, wc_10, wc_4, wc_13
        % shown. 
        % Then check for all of these, e.g. if R{1,3} == 1 => subj chose 
        % wc_3
        hStr = ['DO-Q-q_k_',num2str(k),'_1'];
        ix = find(cellfun(@(c)(isequal(c,hStr)),pruned(1,:)));
        if (~isempty(pruned{i+2,ix}))
           choices = cell2mat(textscan(pruned{i+2,ix},'%d|%d|%d|%d'));
           sizeChoices = size(choices,2);
           if (sizeChoices>0 && sizeChoices<4)
               disp('Warning!')
           end
           for q = 1:sizeChoices 
               if (RR{1,choices(q)} == 1)
                  subjInx(c,4+q) = choices(q);
                  subjInx(c,8+q) = 1;
               end
           end
        end
    end
end

subjInx2 = zeros(sR*12,12);
c = 0;
for i = 1:sR
    for j = 177:13:332
        c = c + 1;
        R = pruned(i+2,j:j+12);
        RR = R;
        k = (j-177)/13 + 1;
        if(~isempty(R(~cellfun('isempty',R))))
            subjInx2(c,4) = k;
            if(~isempty(cell2mat(R(1,k))) && k ~=13)
                subjInx2(c,1) = 1;
            end
            if(~isempty(cell2mat(R(1,13))))
                subjInx2(c,3) = 1;
            end
            R{1,13} = '';
            R{1,k} = '';
            if(~isempty(R(~cellfun('isempty',R))))
                subjInx2(c,2) = 1;
            end
        end
        % for this subj find, for e.g. k = 3, col that is in DO-Q-q_k_3_1
        % if it not empty, e.g. 3|10|4|13 means wc_3, wc_10, wc_4, wc_13
        % shown. 
        % Then check for all of these, e.g. if R{1,3} == 1 => subj chose 
        % wc_3
        hStr = ['DO-Q-q_k_',num2str(k),'_2'];
        ix = find(cellfun(@(c)(isequal(c,hStr)),pruned(1,:)));
        if (~isempty(pruned{i+2,ix}))
           choices = cell2mat(textscan(pruned{i+2,ix},'%d|%d|%d|%d'));
           sizeChoices = size(choices,2);
           if (sizeChoices>0 && sizeChoices<4)
               disp('Warning!')
           end
           for q = 1:sizeChoices 
               if (RR{1,choices(q)} == 1)
                  subjInx2(c,4+q) = choices(q);
                  subjInx2(c,8+q) = 1;
               end
           end
        end
    end
end


% c = 0;
% for i = 1:sR
%     for j = 177:13:332
%         c = c + 1;
%         R = pruned(i+2,j:j+12);
%         k = (j-177)/13 + 1;
%         if(~isempty(R(~cellfun('isempty',R))))
%             subjInx2(c,4) = k;
%             if(~isempty(cell2mat(R(1,k))) && k ~=13)
%                 subjInx2(c,1) = 1;
%             end
%             if(~isempty(cell2mat(R(1,13))))
%                 subjInx2(c,3) = 1;
%             end
%             R{1,13} = '';
%             R{1,k} = '';
%             if(~isempty(R(~cellfun('isempty',R))))
%                 subjInx2(c,2) = 1;
%             end
%         end
%     end
% end
