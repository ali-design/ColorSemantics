sR = size(pruned,1);

subjSum1 = zeros(sR,12);

for i = 1:sR
    c = 0;
    for j = 18:13:173
        c = c + 1;
        R = pruned(i,j:j+12);
        R = R(~cellfun('isempty',R));
        if isempty(R)
            subjSum1(i,c) = 0;
        else
            subjSum1(i,c) = numel(R);
        end
    end
end
subjSum1 = subjSum1(3:end,:);
A1 = subjSum1>0;
B1 = sum(A1,2); 

subjSum2 = zeros(sR,12);
for i = 1:sR
    c = 0;
    for j = 177:13:332
        c = c + 1;
        R = pruned(i,j:j+12);
        R = R(~cellfun('isempty',R));
        if isempty(R)
            subjSum2(i,c) = 0;
        else
            subjSum2(i,c) = numel(R);
        end
    end
end
subjSum2 = subjSum2(3:end,:);
A2 = subjSum2>0;
B2 = sum(A2,2);