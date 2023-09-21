roiManager("Reset");
run("Clear Results");
/*
rename("orig");

run("Split Channels");
selectImage("C2-orig");
close();
selectImage("C3-orig");
close();
selectImage("C1-orig");
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'C1-orig', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
selectImage("Label Image"); */

rename("orig");
run("Split Channels");
close();
close();
selectImage("C1-orig");
run("Gaussian Blur...", "sigma=2.50");

setOption("ScaleConversions", true);
run("16-bit");
run("Auto Threshold", "method=Default ignore_black ignore_white white");
run("Watershed");