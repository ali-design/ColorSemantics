importXlxFile; 
% % save usable data in Color_Semantics_Test_II_03_08_2014.mat 
[validRows,pruned] = removeNotShownChoices_03_08_2014(data);
sR = size(pruned,1) - 2;

subjInx = zeros(sR*12,4);
c = 0;
for i = 1:sR
    for j = 18:13:173
        c = c + 1;
        R = pruned(i+2,j:j+12);
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
    end
end

subjInx2 = zeros(sR*12,4);
c = 0;
for i = 1:sR
    for j = 177:13:332
        c = c + 1;
        R = pruned(i+2,j:j+12);
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
    end
end
