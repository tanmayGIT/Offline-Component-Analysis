function accumulatedInCell =  enterInCell(minRow,maxRow,minCol,maxCol)
accumulatedInCell = zeros(1,4);
accumulatedInCell(1,1) = minRow;
accumulatedInCell(1,2) = maxRow;
accumulatedInCell(1,3) = minCol;
accumulatedInCell(1,4) = maxCol;
return
end