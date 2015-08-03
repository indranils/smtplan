function drawWorkspace(width, height, initpos, goalpos, wksp)

plot([-1,width+1,width+1,-1,-1],[-1,-1,height+1,height+1,-1],'w','linewidth',2);
hold on;
plot(initpos(1), initpos(2),'kx','linewidth',5);
% initial heading
%quiver(xinit(1),xinit(2),cos(xinit(3)),sin(xinit(3)),'linewidth',2); 
plot(initpos(1), initpos(2), 'linewidth', 5);
plot(goalpos(1), goalpos(2),'gx','linewidth',5);
%drawCircle(xgoal,uncertRadGoal,'g-',1);

for k=1:size(wksp,1)
    x = wksp{k,1}(1,1);
    y = wksp{k,1}(2,1);
    w = wksp{k,1}(1,2)-x;
    h = wksp{k,1}(2,2)-y;
    rectangle('Position',[x,y,w,h],'Facecolor','r');
    text(x + (w/2), y + (h/2), num2str(k));
end

%axis('image');