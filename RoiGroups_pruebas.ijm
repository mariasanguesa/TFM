
roiTotal = roiManager("count");
for (j=0; j<roiTotal; j++){
	roiManager("Select", j);
	setForegroundColor(300, 175, 1);
	run("Fill", "slice"); 
}

