function [titlePortion,topicVsTitle,titleVsTopic] = ...
         visualize_LDA_words(WP,DP,Z,DS,Doc)

Doc = load(Doc);
Doc = Doc.imgInx;

% WP a sparse matrix of size W x T, where W is the number of words in the 
% vocabulary and T is the number of topics. 
% WP(i,j) contains the number of times word i has been assigned to topic j. 
WP = WP/max(sum(WP(1:size(WP,1),:)));
k = size(WP,2);

% topicVsTitle:
numOfDocs = size(Doc,1);
titlePortion = zeros(k,numOfDocs);
topicVsTitle = {};
for j = 1:k
    titlePortion(j,1) = sum(DP(1:Doc{1,2}));
    b = Doc{1,2};
    for i = 2:size(Doc,1)
        a = b;
        b = a+(Doc{i,2});
        titlePortion(j,i) = sum(DP(a+1:b,j));
        %fprintf('%s: %f \n',Doc{i,1},titlePortion(j,i));
        %text((j-1+0.25),(y+i+0.05),Doc(i,1));
    end
    titlePortion(j,:) = titlePortion(j,:)/sum(titlePortion(j,:));
    [tMax tX] = max(titlePortion(j,:));
    str = ['Topic ',num2str(j),' with highest magazine title: ', Doc{tX,1}]; 
    topicVsTitle{j,1} = str;
    fprintf('%s\n',str);
end

% title vs topic
titleVsTopic = zeros(numOfDocs,k);
a = 0;
agr = 0;
[q,ix] = unique(DS);
for i = 1:numOfDocs
    for m = 1:size(q,2)
        if(q(m) == Doc{i,2} + agr)
            b = ix(m);
            agr = agr + Doc{i,2};
            break;
        end
    end
    %b = a + ix(Doc{i,2};
    titleBuffer = Z(a+1:b);
    toPortion = hist(titleBuffer,[1:k]);
    titleVsTopic(i,:) = toPortion/sum(toPortion);  
    a = b;
end


[num_titles, num_Topics] = size(titleVsTopic);
% mg = 0;
% for i = 1:num_titles
%     y = 0;
%     for j = 1:num_Topics     
%         rectangle('Position',[i-1+mg, y, 1, titleVsTopic(i,j)],...
%                'EdgeColor','none','FaceColor',[cm(j,1),cm(j,2),cm(j,3)]);
%         y = y + titleVsTopic(i,j);
%     end
%     h = text(i-1+mg+.5,(y+0.02),Doc{i,1});
%     set(h,'rotation',90,'FontSize',7);
%     mg = mg + 0.5;
% end
% set(gca,'visible','off');
% 
% 
% secLabels = {['k',num2str(1)],['k',num2str(2)],['k',num2str(3)],...
%              ['k',num2str(4)],['k',num2str(5)],['k',num2str(6)],...
%              ['k',num2str(7)],['k',num2str(8)],['k',num2str(9)],...
%              ['k',num2str(10)],['k',num2str(11)],['k',num2str(12)]};
%          
% close(findobj('type','figure','name','Magazine Title vs Topics'));
% figureHandle = figure('name', 'Magazine Title vs Topics');
% pie(titleVsTopic(52,:),secLabels);
% title([Doc{52,1},' magazine covers include these topic proportions:']);
% axis equal

% cm = 1/255*[0,0,143;0,0,223;0,63,255;0,159,255;0,255,255;95,255,159;...
%             175,255,79;255,239,0;255,143,0;255,47,0;207,0,0;127,0,0];
% figure;
% [num_titles, num_Topics] = size(titleVsTopic);
% maxT = max(titleVsTopic,1);
% mg = 0;
% for i = 1:num_titles
%     y = 0;
%     for j = 1:num_Topics     
%         rectangle('Position',[i-1+mg, y, 1, titleVsTopic(i,j)],...
%                'EdgeColor','none','FaceColor',[cm(j,1),cm(j,2),cm(j,3)]);
%         y = y + titleVsTopic(i,j);
%     end
%     h = text(i-1+mg+.5,(y+0.02),Doc{i,1});
%     set(h,'rotation',90,'FontSize',7);
%     mg = mg + 0.5;
% end
% set(gca,'visible','off');