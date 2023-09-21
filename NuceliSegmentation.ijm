run("Make Composite", "display=Composite");
run("Duplicate...", "title=orig duplicate channels=1-7");

roiManager("Reset");
run("Clear Results");

run("Colors...", "foreground=black background=white selection=red");
run("Set Measurements...", "area mean area_fraction redirect=None decimal=2");

//Filtrar, quitar fondo y mejorar el contraste del primer canal
selectWindow("orig");
run("Duplicate...", "title=nucleiMask duplicate channels="+1);
run("Mean...", "radius=3");
run("Subtract Background...", "rolling=300");
run("Enhance Contrast", "saturated=0.35");

// DapiMaxima. Buscar el máximo
// the maxima will only be counted when they “stand out” from the surroundings by more than the prominence
run("Find Maxima...", "prominence="+3+" output=[Single Points]");
rename("dapiMaxima");

//CellMask

selectWindow("nucleiMask");
//dark if the image has a dark background
setAutoThreshold("Default dark");
//Returns the lower and upper threshold levels.
getThreshold(lower, upper);
setThreshold(3.7,upper);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Median...", "radius=1");
//by filling the background
run("Fill Holes");
//Select entire image
run("Select All");
run("Analyze Particles...", "size=20-Infinity pixel show=Masks in_situ");

run("Duplicate...", "title=cellMask");
run("Create Selection");
run("Enlarge...", "enlarge="+5);
setForegroundColor(0, 0, 0);
run("Fill", "slice");

// No sé si restore selection coge la de dapiMaxima o la de cellMask
selectWindow("dapiMaxima");
run("Select None");
run("Restore Selection");
setBackgroundColor(255, 255, 255);
run("Clear Outside");
run("Select None");

// CellEdges

selectWindow("cellMask");
run("Select All");
run("Duplicate...", "title=cellEdges");
run("Find Edges");

// MARKER-CONTROLLED WATERSHED

run("Marker-controlled Watershed", "input=cellEdges marker=dapiMaxima mask=cellMask binary calculate use");

selectWindow("cellEdges-watershed");
run("8-bit");
setThreshold(1, 255);
setOption("BlackBackground", false);
run("Convert to Mask");

selectWindow("cellEdges");
close();
selectWindow("cellMask");
close();
selectWindow("dapiMaxima");
close();
selectWindow("cellEdges-watershed");
rename("cellMask");