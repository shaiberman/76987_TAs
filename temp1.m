set(gca,'xlim',[-10,10],'ylim',[-10,10]); axis equal
axis(axis); grid on; ylabel('B0 axis'); cla

% Original net magnetization
m = [0,10]; [p0,r0] = cart2pol(m(1),m(2));
a = arrow([0,0],m(1:2));  set(a,'edgecolor',[1,0,0])