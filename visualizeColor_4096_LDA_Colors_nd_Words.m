function [titlePortion,topicVsTitle,titleVsTopic] = ...
         visualizeColor_4096_LDA_Colors_nd_Words(CP,CDP,Y,imgInxList,res_rgbC)

    % myWriteTopics_for_Wordcloud( WP , beta , WO , 30 , 1000, 'forWordCloud.txt' )
% docs that have both color and words:
% Doc = load('Dataset/Doc_Colors_nd_Words'); 
% Doc = Doc.imgInx;
Doc = imgInxList;

%res_rgbC = load('Dataset/color_512/reshaped_rgbColorCubes_White255');
%res_rgbC = res_rgbC.res_rgbC;

% CP a sparse matrix of size W x T, where W is the number of words in the 
% vocabulary and T is the number of topics. 
% CP(i,j) contains the number of times word i has been assigned to topic j. 
% CP = CP/max(sum(CP(1:512,:)));

k = size(CP,2);
close(findobj('type','figure','name','Topic Histogram of 4096-RGB'));
figureHandle = figure('name', 'Topic Histogram of 4096-RGB');

% 4096 colors vs topics
for j = 1:k
    yOffset = 0;
    CP = CP/sum(CP(1:4096,j));
    for i = 1:4096
        if(CP(i,j)> 0)
            hold on
            rectangle('Position',[j-1, yOffset, 1, CP(i,j)],...
                      'EdgeColor', 'none','FaceColor',...
                      1/255*[res_rgbC(i).R,res_rgbC(i).G,res_rgbC(i).B]);
            yOffset = yOffset + CP(i,j);
        end
    end
    text((j-1+0.25),(yOffset+0.05),['k',num2str(j)]);
end
hold off

% % images vs topics
% close(findobj('type','figure','name','Topic Histogram of magazine covers'));
% figureHandle = figure('name', 'Topic Histogram of magazine covers');
numOfDocs = size(Doc,1);
titlePortion = zeros(k,numOfDocs);
topicVsTitle{:} = [];
for j = 1:k
%     yOffset = 1;
    %fprintf('Topic %d:',j);
    titlePortion(j,1) = sum(CDP(1:Doc{1,2}));
    b = Doc{1,2};
    for i = 2:size(Doc,1)
        a = b;
        b = a+(Doc{i,2});
        titlePortion(j,i) = sum(CDP(a+1:b,j));
        %fprintf('%s: %f \n',Doc{i,1},titlePortion(j,i));
        %text((j-1+0.25),(yOffset+i+0.05),Doc(i,1));
    end
    titlePortion(j,:) = titlePortion(j,:)/sum(titlePortion(j,:));
    [tMax tX] = max(titlePortion(j,:));
    str = ['Topic ',num2str(j),' with highest magazine title: ', Doc{tX,1}]; 
    topicVsTitle{j,1} = str;
    fprintf('%s\n',str);
end

% title vs topic
docSize = 200*150;
titleVsTopic = zeros(numOfDocs,k);
a = 0;
for i = 1:numOfDocs
    b = a + docSize*Doc{i,2};
    if(i == 57)
        disp(i);
    end
    titleBuffer = Y(a+1:b);
    toPortion = hist(titleBuffer,[1:k]);
    titleVsTopic(i,:) = toPortion/sum(toPortion);  
    a = b;
end

secLabels = cell(1,k);
for i = 1:k
    str = ['k',num2str(i)];
    secLabels{1,i} = str;
end
         
close(findobj('type','figure','name','Magazine Title vs Topics'));
figureHandle = figure('name', 'Magazine Title vs Topics');
pie(titleVsTopic(35,:),secLabels);
title([Doc{35,1},' magazine covers include these topic proportions:']);
axis equal

    