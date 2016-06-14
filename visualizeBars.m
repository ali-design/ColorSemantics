cm = 1/255*[0,0,143;0,0,223;0,63,255;0,159,255;0,255,255;95,255,159;...
            175,255,79;255,239,0;255,143,0;255,47,0;207,0,0;127,0,0];
figure;
mg = 0;
y = 0;
    for j = 1:12     
        rectangle('Position',[mg, y, 1, 1],...
               'EdgeColor','none','FaceColor',[cm(j,1),cm(j,2),cm(j,3)]);

  
    h = text(mg+1.2,(y+.5),['k',num2str(j)]);
    set(h,'FontSize',10);
            y = y + 1;
    end
set(gca,'visible','on');
axis equal