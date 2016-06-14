close all
clc

Doc = imgInxList;
cm = 1/255*[0,0,143;0,0,223;0,63,255;0,159,255;0,255,255;95,255,159;...
            175,255,79;255,239,0;255,143,0;255,47,0;207,0,0;127,0,0];
figure;
[num_titles, num_Topics] = size(titleVsTopic);
maxT = max(titleVsTopic,1);
mg = 0;

kMat = zeros(num_titles,num_Topics);
kMatDocInx = uint8(zeros(num_titles,num_Topics));
for i = 1:num_titles
    y = 0;
    for j = 1:num_Topics
        if(titleVsTopic(i,j)> 0)
            rectangle('Position',[i-1+mg, y, 1, titleVsTopic(i,j)],...
               'EdgeColor','none','FaceColor',[cm(j,1),cm(j,2),cm(j,3)]);
            y = y + titleVsTopic(i,j);
            kMat(i,j) = titleVsTopic(i,j);
            kMatDocInx(i,j) = i;
        end
    end
    h = text(i-1+mg+.5,(y+0.02),Doc{i,1});
    set(h,'rotation',90,'FontSize',7);
    mg = mg + 0.5;
end
set(gca,'visible','off');

figure
for i = 1:12
    rectangle('Position',[0, i-1, 1, 1],...
               'EdgeColor','none','FaceColor',[cm(i,1),cm(i,2),cm(i,3)]);
end
axis equal

[s_kMat,x_kMat] = sort(kMat,1,'descend');
norm_s_kMat = (s_kMat./repmat(sum(s_kMat),71,1));

for k = 1:num_Topics
    fprintf('Topic k%d\n',k);
    for t = 1:num_titles
        if kMatDocInx(x_kMat(t,k),k)
        fprintf('%s %f\n',Doc{kMatDocInx(x_kMat(t,k),k),1},norm_s_kMat(t,k));
        end
    end
end