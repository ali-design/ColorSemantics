Doc = load('Doc');
Doc = Doc.imgInx;
cm = 1/255*[0,0,143;0,0,223;0,63,255;0,159,255;0,255,255;95,255,159;...
            175,255,79;255,239,0;255,143,0;255,47,0;207,0,0;127,0,0];
figure;
[num_titles, num_Topics] = size(titleVsTopic);
maxT = max(titleVsTopic,1);
mg = 0;
for i = 1:num_titles
    y = 0;
    for j = 1:num_Topics     
        rectangle('Position',[i-1+mg, y, 1, titleVsTopic(i,j)],...
               'EdgeColor','none','FaceColor',[cm(j,1),cm(j,2),cm(j,3)]);
        y = y + titleVsTopic(i,j);
    end
    h = text(i-1+mg+.5,(y+0.02),Doc{i,1});
    set(h,'rotation',90,'FontSize',7);
    mg = mg + 0.5;
end
set(gca,'visible','off');
