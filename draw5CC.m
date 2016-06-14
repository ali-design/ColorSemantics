function draw5CC(color,name,target)
figure;
set(gca,'visible','off');
for i = 1:5
    hold on
    rectangle('Position',[i-1, 0, 1, 1],...
               'EdgeColor','none','FaceColor',...
               [color(1,i,1),color(1,i,2),color(1,i,3)]);
end
text(0,1.5,[char(name),', rated: ',num2str(target),', from Adobe Kuler']);
hold off
axis equal