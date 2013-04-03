function[P S sortedIndex] = arrangeImages(textFile)
nLinesT1 = 0;
fid = fopen(textFile,'rt');
while (fgets(fid) ~= -1),
    nLinesT1 = nLinesT1+1;
   
end
fclose(fid);
[P,S] = textread(textFile,'%d %d',nLinesT1);
[~,sortedIndex] = sort(S);
end
