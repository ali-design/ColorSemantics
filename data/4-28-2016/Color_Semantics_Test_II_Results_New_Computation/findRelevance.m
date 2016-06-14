function [confusionMatrix] = findRelevance(wTotal, bTotal, wcTotal)
%finds relevance matrix and then computes confusion matrix and returns it.
clc
% position bias
w = wTotal/max(wTotal);
% just want positions 1 ... 3
w1 = w(5,1); w2 = w(6,1); w3 = w(7,1);

epsi = 1e-5;
rangeOfR = min(min(1/w1,1/w2),1/w3) - epsi;

% find r for each color palette k, and word-cloud d:
% find root of this function f(r)
relevanceMatrix = double(zeros(12,12));
for k = 1:12
    for d = 1:12
        close all;
        wc = wcTotal{k};
        n1 = wc(1,d); n2 = wc(2,d); n3 = wc(3,d);
        m1 = wc(5,d); m2 = wc(6,d); m3 = wc(7,d);


        f = @(r) (n1 - m1)*log(1 - r*w1 )+ m1*log(r*w1) +...
                 (n2 - m2)*log(1 - r*w2 )+ m2*log(r*w2) + ...
                 (n3 - m3)*log(1 - r*w3 )+ m3*log(r*w3);
%         figure
%         fplot(f,[epsi,rangeOfR]);

        g = @(r) (m1 - w1*n1*r)/(r*(1 - r*w1)) + ...
                 (m2 - w2*n2*r)/(r*(1 - r*w2)) + ...
                 (m3 - w3*n3*r)/(r*(1 - r*w3));
%         figure;
%         fplot(g,[epsi,rangeOfR]);        
        x0 = [epsi,rangeOfR]; 
%         fprintf('(k,wc) = (%d,%d)\n',k,d);
%         if ((k == 11 && d == 9))
%             relevanceMatrix(k,d) = 0;
%             continue;
%         end
%         if ((k == 9 && d == 9))
%             relevanceMatrix(k,d) = rangeOfR;
%             continue;
%         end
        if (g(x0(1))*g(x0(2)) > 0) % similar sign
            if(g(x0(1)) < 0)
                relevanceMatrix(k,d) = epsi;
            else   
                relevanceMatrix(k,d) = rangeOfR;
            end
            continue;           
        else  
            x = fzero(g,x0);
            relevanceMatrix(k,d) = x;
        end
    end   
end

confusionMatrix = zeros(12,12);
for i = 1:12
    b = bTotal{i};
    for j = 1:12
        b1 = b(1,j);
        b2 = b(2,j);
        b3 = b(3,j);
        confusionMatrix(i,j) = relevanceMatrix(i,j)*...
                               (w1*b1 + w2*b2 + w3*b3);
    end
end

        

