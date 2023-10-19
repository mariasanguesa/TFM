roiCount = roiManager("Count");
waitForUser("Título", "Selecciona área.");
getSelectionCoordinates(xarea, yarea);

for (roi=0;roi<roiCount;roi++){
	roiManager("select",roi);
	Roi.getContainedPoints(xroi, yroi);
	for (x = 0; x < xroi.length; x++) {
		for (y = 0; y < yroi.length; y++) {
			if(contains(xarea,xroi[x])){
				if(contains(yarea,yroi[y])){
					print("si");
				}
			}
		}
	}
}

function contains( array, value ) {
    for (i=0; i<array.length; i++) 
        if ( array[i] == value ) return true;
    return false;
}


roiManager("Combine");
roiManager("Add");
makeRectangle(1662, 813, 60, 75);
Roi.setPosition(1);
roiManager("Add");
roiManager("Select", newArray(3246,3247));
roiManager("AND");
roiManager("Add");
roiManager("delete");
