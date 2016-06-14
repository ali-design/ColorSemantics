function [reportMatrix] = computeErrorBarRelevance(wTotal, wcTotal)
clc
% position bias
w = wTotal/max(wTotal);
% just want positions 1 ... 3
w1 = w(5,1); w2 = w(6,1); w3 = w(7,1);

epsi = 1e-5;
rangeOfR = min(min(1/w1,1/w2),1/w3) - epsi;

% find r for each color palette k, and word-cloud d:
% find root of this function f(r)
reportMatrix = double(zeros(12,12));
for k = 1:12
    for d = 1:12
        close all;
        wc = wcTotal{k};
        n1 = wc(1,d); n2 = wc(2,d); n3 = wc(3,d);
        m1 = wc(5,d); m2 = wc(6,d); m3 = wc(7,d);


        f = @(r) (n1 - m1)*log(1 - r*w1 )+ m1*log(r*w1) + ...
                 (n2 - m2)*log(1 - r*w2 )+ m2*log(r*w2) + ...
                 (n3 - m3)*log(1 - r*w3 )+ m3*log(r*w3);
        figure
        fplot(f,[epsi,rangeOfR]);

        g = @(r) (m1 - w1*n1*r)/(r*(1 - r*w1)) + ...
                 (m2 - w2*n2*r)/(r*(1 - r*w2)) + ...
                 (m3 - w3*n3*r)/(r*(1 - r*w3));
        figure;
        fplot(g,[epsi,rangeOfR]);        
        x0 = [epsi,rangeOfR]; 
        fprintf('(k,wc) = (%d,%d)\n',k,d);
        if (k == 11 && d == 9)
            reportMatrix(k,d) = 0;
            continue;
        end
        x = fzero(g,x0);
        reportMatrix(k,d) = x;
    end   
end

