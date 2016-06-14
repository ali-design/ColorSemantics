for i = 3:130
    for j = 345:368
        [t1,ix1] = regexp(pruned{1,j},'q_k_[0-9]+_[0-9]+','match');
        [t11,ix11] = regexp(pruned{1,j},'[0-9]+','match');   
        [c,ixc] = regexp(pruned{4,345},'[0-9]+','match');
        if ~isempty(find(ismember(c,t11(1))))
            qIx = str2num(t11{1}) + (str2num(t11{2}) - 1)*12;
            flag = 0;
            if (str2num(t11{2}) == 1)
                [f1,ixF1] = regexp(pruned{i,343},'[0-9]+','match');
                flag = 1;
            else
                [f1,ixF1] = regexp(pruned{i,344},'[0-9]+','match');
                flag = 2;
            end
            if ~isempty(find(ismember(f1,num2str(qIx))))
                [a,b] = ismember(f1,num2str(qIx));
                f1(b==1) = '';
                strQ = '';
                for m = 1:size(f1,2)
                    strQ = strcat(strQ,'Q', f1{m}, '|');
                end
                if(flag==1)
                    pruned{i,343} = strQ;
                elseif(flag ==2)
                    pruned{i,344} = strQ;
                end
            end
            for k = 27:341
                [r,x] = regexp(pruned{1,k},strcat(t1,'_[0-9]+'));
                if(~isempty(r{:}))
                    pruned{i,k} = '';
                end
            end
        end
    end
end
