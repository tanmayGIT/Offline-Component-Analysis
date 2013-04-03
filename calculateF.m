function returnedF = calculateF(xDash,x,m,scaleFactor)

global wienerFilteredMat;
a = ceil((xDash / scaleFactor) - x);

returnedF = ((-a*(1-a^2))*wienerFilteredMat(x-1,m)) + ((1-2*a^2+a^3)*wienerFilteredMat(x,m)) + ...
                        ((a*(1+a-a^2))*wienerFilteredMat(x+1,m)) - ((a^2)*(1-a)*wienerFilteredMat(x+2,m));
    
end