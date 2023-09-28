
// Variable definition
var cDAPI=1;

InDir=getDirectory("Choose directory");
list=getFileList(InDir);
L=lengthOf(list);

roiManager("Reset");
run("Clear Results");

for (j=0; j<L; j++){
	if(endsWith(list[j],"tif")){
		
		roiManager("Reset");
		run("Clear Results");

		name=list[j];

		run("Bio-Formats Importer", "open="+InDir+name+" autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
	
		rename("orig-"+name);
		run("Make Composite", "display=Composite");
		run("Duplicate...", "title=dapi-"+name+" duplicate channels=1");
		run("Enhance Contrast", "saturated=0.35");

		run("Duplicate...", "title=dapiMask-"+name);
		
		/*run("Gaussian Blur...", "sigma=2");
		setAutoThreshold("Default dark");
		run("Convert to Mask");
		run("Watershed");
		run("Median...", "radius=1");*/
		//run("Gaussian Blur...", "sigma=2");
		setAutoThreshold("Default dark");
		run("Convert to Mask");
		run("Watershed");
		
		selectImage("dapi-"+name);
		run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'dapi-"+name+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.5000000000000004', 'percentileTop':'100.0', 'probThresh':'0.479071', 'nmsThresh':'0.3', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
		selectImage("Label Image");
		selectImage("dapiMask-"+name);
		
		run("Analyze Particles...", "size=20-Infinity pixel");
		run("Create Selection");
		roiManager("Add");

		selectImage("Label Image");
		//Quedarme con el último elemento que se corresponde con dapi
		roiTotal = roiManager("count"); 
		roiManager("select", roiTotal-1);
		RoiManager.setGroup(0);
		RoiManager.setPosition(0);
		roiManager("Set Color", "White");
		roiManager("Set Line Width", 2);
		run("Flatten");
		rename("contourNuclei-"+name);
		selectImage("Label Image");
		close("Label Image");

	}
}


