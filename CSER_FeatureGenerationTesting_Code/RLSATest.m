function matrixOperated = RLSATest(x,C)
% Data
% x=[0 0 0 1 0 0 0 0 0 1 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 0 0 
% 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0];
% C = 6;


% Engine
[m ~] = size(x);
xx = [ones(m,1) x ones(m,1)];
xx = reshape(xx',1,[]);
d = diff(xx);
start = find(d==-1); % Starting of series of 1's
stop = find(d==1); % Ending of series of 1's
lgt = stop-start; 
b = lgt <= C;
d(start(b)) = 0;
d(stop(b)) = 0;
yy = cumsum([1 d]);
yy = reshape(yy, [], m)';
y = yy(:,2:end-1);
matrixOperated = y;
