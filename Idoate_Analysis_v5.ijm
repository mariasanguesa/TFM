// changelog September 2022
// Use DAPI to segment nuclei and determine cytoplasm as a ring of X microns around

// New features wrt to v2:
// - Work with 32-bit images to avoid false positives when there is only background signal
// - New thresholds for all markers (32-bit float images)
// - Define min % of cell with positive expression of marker, instead of min number of pixels

// New features wrt to v3:
// - Problem of eritrocites resulting in false detections of Foxp3+ or CD11b+ cells. Work with dual thresholds for those two markers: lowTH and highTH.
//   Cell classification: CD11b > highTH && Foxp3 < lowTH --> CD11b+ cell
//                        Foxp3 > highTH && CD11b < lowTH --> Foxp3+ cell
//						  CD11b > highTH && Foxp3 > lowTH --> Eritrocite
//						  Foxp3 > highTH && CD11b > lowTH --> Eritrocite
//						  Foxp3 > lowTH  && CD11b > lowTH --> Eritrocite

// New features wrt to v4:
// - Detection of CD163+/CD11b+ cells (and update of CD163+ and CD11b+ counts)
// - Higher threshold for CD163 to avoid false detections in patients with higher background for this marker
// - Independent minMarkerPerc for Foxp3, so we can set it lower and detect better eritrocites (they tend to express CD11b more extensively than Foxp3)


var prominence=3, cytoBand=2, thTissue=8;
var cDAPI=1, cCD11b=2, cFoxp3=3, cCD8=4, cCD3=5, cCD163=6, cGFAP=7, cAF=8;  
var minMarkerPerc=15, minFoxp3Perc=7, minCD163Perc=15, thCD11b=5.00, thFoxp3=5.00, thCD8=2.00, thCD3=8.00, thCD163=23.00, thNucl=3.70, thGFAP=2.20, lowThPerc=60;

macro "QIF Action Tool 1 - Cf00T2d15IT6d10m"{
	
	run("ROI Manager...");
	
	//just one file
	name=File.openDialog("Select File");
	//print(name);
	print("Processing "+name);
	
	Dialog.create("Parameters for the analysis");
	// Tissue segmentation options:
	Dialog.addMessage("Choose threshold for tissue segmentation")	
	Dialog.addNumber("Tissue threshold", thTissue);	
	// Cell segmentation options:
	//modeArray=newArray("Default","Otsu","IsoData","Moments","Triangle","MaxEntropy","Minimum");
	Dialog.addMessage("Cell segmentation")
	//Dialog.addRadioButtonGroup("Thresholding method for DAPI", modeArray, 1, 7, "Default");
	Dialog.addNumber("DAPI threshold", thNucl);
	Dialog.addNumber("Prominence for maxima detection", prominence);
	Dialog.addNumber("Cytoplasm width (microns)", cytoBand);
	// Tumor segmentation options:
	Dialog.addMessage("Tumor segmentation")
	//Dialog.addRadioButtonGroup("Thresholding method for GFAP", modeArray, 1, 7, "Default");
	Dialog.addNumber("GFAP threshold", thGFAP);
	// Markers' segmentation options:
	Dialog.addMessage("Markers' segmentation")
	Dialog.addNumber("CD3 threshold", thCD3)
	Dialog.addNumber("CD8 threshold", thCD8)
	Dialog.addNumber("CD11b threshold", thCD11b)
	Dialog.addNumber("CD163 threshold", thCD163)
	Dialog.addNumber("Foxp3 threshold", thFoxp3);	
	Dialog.addNumber("Factor to calculate a lower threshold of any marker (%)", lowThPerc);	
	Dialog.addNumber("Min presence of CD163+ per cell (%)", minCD163Perc);
	Dialog.addNumber("Min presence of Foxp3+ per cell (%)", minFoxp3Perc);
	Dialog.addNumber("Min presence of positive marker per cell (%)", minMarkerPerc);
	
	Dialog.show();	
	thTissue= Dialog.getNumber();
	//thMethodNucl=Dialog.getRadioButton();
	thNucl= Dialog.getNumber();
	prominence= Dialog.getNumber();
	cytoBand= Dialog.getNumber();
	//thMethodTum=Dialog.getRadioButton();	
	thGFAP= Dialog.getNumber();
	thCD3= Dialog.getNumber();
	thCD8= Dialog.getNumber();
	thCD11b= Dialog.getNumber();
	thCD163= Dialog.getNumber();
	thFoxp3= Dialog.getNumber();
	lowThPerc= Dialog.getNumber();
	minCD163Perc= Dialog.getNumber();
	minFoxp3Perc= Dialog.getNumber();
	minMarkerPerc= Dialog.getNumber();

	//setBatchMode(true);
	qif("-","-",name,thTissue,thNucl,prominence,cytoBand,thGFAP,thCD3,thCD8,thCD11b,thCD163,thFoxp3,lowThPerc,minCD163Perc,minFoxp3Perc,minMarkerPerc);
	setBatchMode(false);
	showMessage("QIF done!");

}

macro "QIF Action Tool 2 - C00fT0b11DT9b09iTcb09r"{
	
	run("ROI Manager...");
	
	InDir=getDirectory("Choose Tiles' directory");
	list=getFileList(InDir);
	L=lengthOf(list);

	Dialog.create("Parameters for the analysis");
	// Tissue segmentation options:
	Dialog.addMessage("Choose threshold for tissue segmentation")	
	Dialog.addNumber("Tissue threshold", thTissue);	
	// Cell segmentation options:
	//modeArray=newArray("Default","Otsu","IsoData","Moments","Triangle","MaxEntropy","Minimum");
	Dialog.addMessage("Cell segmentation")
	//Dialog.addRadioButtonGroup("Thresholding method for DAPI", modeArray, 1, 7, "Default");
	Dialog.addNumber("DAPI threshold", thNucl);
	Dialog.addNumber("Prominence for maxima detection", prominence);
	Dialog.addNumber("Cytoplasm width (microns)", cytoBand);
	// Tumor segmentation options:
	Dialog.addMessage("Tumor segmentation")
	//Dialog.addRadioButtonGroup("Thresholding method for GFAP", modeArray, 1, 7, "Default");
	Dialog.addNumber("GFAP threshold", thGFAP);
	// Markers' segmentation options:
	Dialog.addMessage("Markers' segmentation")
	Dialog.addNumber("CD3 threshold", thCD3)
	Dialog.addNumber("CD8 threshold", thCD8)
	Dialog.addNumber("CD11b threshold", thCD11b)
	Dialog.addNumber("CD163 threshold", thCD163)
	Dialog.addNumber("Foxp3 threshold", thFoxp3);	
	Dialog.addNumber("Factor to calculate a lower threshold of any marker (%)", lowThPerc);	
	Dialog.addNumber("Min presence of CD163+ per cell (%)", minCD163Perc);
	Dialog.addNumber("Min presence of Foxp3+ per cell (%)", minFoxp3Perc);
	Dialog.addNumber("Min presence of positive marker per cell (%)", minMarkerPerc);
	
	Dialog.show();	
	thTissue= Dialog.getNumber();
	//thMethodNucl=Dialog.getRadioButton();
	thNucl= Dialog.getNumber();
	prominence= Dialog.getNumber();
	cytoBand= Dialog.getNumber();
	//thMethodTum=Dialog.getRadioButton();	
	thGFAP= Dialog.getNumber();
	thCD3= Dialog.getNumber();
	thCD8= Dialog.getNumber();
	thCD11b= Dialog.getNumber();
	thCD163= Dialog.getNumber();
	thFoxp3= Dialog.getNumber();
	lowThPerc= Dialog.getNumber();
	minCD163Perc= Dialog.getNumber();
	minFoxp3Perc= Dialog.getNumber();
	minMarkerPerc= Dialog.getNumber();
	
	for (j=0; j<L; j++)
	{
		if(endsWith(list[j],"tif")){
			//analyze
			//d=InDir+list[j]t;
			name=list[j];
			print("Processing "+name);
			//setBatchMode(true);
			qif(InDir,InDir,list[j],thTissue,thNucl,prominence,cytoBand,thGFAP,thCD3,thCD8,thCD11b,thCD163,thFoxp3,lowThPerc,minCD163Perc,minFoxp3Perc,minMarkerPerc);
			setBatchMode(false);
			}
	}
	
	showMessage("QIF done!");

}


function qif(output,InDir,name,thTissue,thNucl,prominence,cytoBand,thGFAP,thCD3,thCD8,thCD11b,thCD163,thFoxp3,lowThPerc,minCD163Perc,minFoxp3Perc,minMarkerPerc)
{

run("Close All");

if (InDir=="-") {
	run("Bio-Formats Importer", "open="+name+" autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
	}
else {
	run("Bio-Formats Importer", "open="+InDir+name+" autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
	}	


roiManager("Reset");
run("Clear Results");
MyTitle=getTitle();
output=getInfo("image.directory");

OutDir = output+File.separator+"AnalyzedImages";
File.makeDirectory(OutDir);

aa = split(MyTitle,".");
MyTitle_short = aa[0];

//--Keep only marker channels and elliminate autofluorescence:
run("Duplicate...", "title=orig duplicate channels=1-7");
selectWindow(MyTitle);
close();
selectWindow("orig");
run("Make Composite", "display=Composite");

getDimensions(width, height, channels, slices, frames);

Stack.setChannel(cDAPI);
run("Blue");
run("Set Label...", "label=DAPI");
Stack.setChannel(cCD11b);
run("Yellow");
run("Set Label...", "label=CD11b");
Stack.setChannel(cFoxp3);
run("Magenta");
run("Set Label...", "label=Foxp3");
Stack.setChannel(cCD8);
run("Red");
run("Set Label...", "label=CD8");
Stack.setChannel(cCD3);
run("Orange Hot");
run("Set Label...", "label=CD3");
Stack.setChannel(cCD163);
run("Green");
run("Set Label...", "label=CD163");
Stack.setChannel(cGFAP);
run("Cyan");
run("Set Label...", "label=GFAP");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("1111111");
wait(100);

run("RGB Color");
rename("merge");

run("Colors...", "foreground=black background=white selection=red");
run("Set Measurements...", "area mean area_fraction redirect=None decimal=2");


//--DETECT TISSUE

print("---- Segmenting tissue ----");
setBatchMode(true);
showStatus("Detecting tissue...");
selectWindow("merge");
run("Duplicate...", "title=tissue");
run("8-bit");
run("Gaussian Blur...", "sigma=4 stack");
//run("Threshold...");
	//thTissue=8;
setThreshold(thTissue, 255);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Invert LUT");
run("Median...", "radius=12");
run("Analyze Particles...", "size=5000-Infinity pixel show=Masks in_situ");
run("Invert");
wait(100);
run("Analyze Particles...", "size=20000-Infinity pixel show=Masks in_situ");
run("Create Selection");
run("Add to Manager");	// ROI0 --> whole tissue
selectWindow("tissue");
close();
setBatchMode(false);

//--If there is an annotation to elliminate part of the image, do it
if(File.exists(output+File.separator+"ROIs"+File.separator+MyTitle_short+"_roi.roi")) {
	roiManager("Open", output+File.separator+"ROIs"+File.separator+MyTitle_short+"_roi.roi");
	roiManager("Deselect");
	roiManager("Select", newArray(0,1));
	roiManager("AND");
	roiManager("Add");
	roiManager("Deselect");
	roiManager("Select", newArray(0,2));
	roiManager("XOR");
	roiManager("Add");
	roiManager("Deselect");
	roiManager("Select", newArray(0,1,2));
	roiManager("Delete");
	roiManager("Deselect");
}

selectWindow("merge");
roiManager("Select", 0);
run("Measure");
Atissue = getResult("Area", 0);
run("Clear Results");
roiManager("Set Color", "white");
roiManager("Set Line Width", 4);
run("Flatten");
wait(200);
selectWindow("merge");
close();
selectWindow("merge-1");
rename("merge");


// SEGMENT NUCLEI FROM DAPI:

selectWindow("orig");
  // cDAPI=1;
run("Duplicate...", "title=nucleiMask duplicate channels="+cDAPI);
//run("8-bit");
run("Mean...", "radius=3");
run("Subtract Background...", "rolling=300");
run("Enhance Contrast", "saturated=0.35");
run("Duplicate...", "title=dapi");
selectWindow("nucleiMask");
	// prominence=3
run("Find Maxima...", "prominence="+prominence+" output=[Single Points]");
rename("dapiMaxima");

selectWindow("nucleiMask");
	//thMethodNucl="Default";
//setAutoThreshold(thMethodNucl+" dark");
setAutoThreshold("Default dark");
getThreshold(lower, upper);
   //thNucl=3.70;
setThreshold(thNucl,upper);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Median...", "radius=1");
run("Fill Holes");
run("Select All");
run("Analyze Particles...", "size=20-Infinity pixel show=Masks in_situ");

// Generate cellMask by enlarging the mask of nuclei
run("Duplicate...", "title=cellMask");
run("Create Selection");
	//cytoBand=5;
run("Enlarge...", "enlarge="+cytoBand);
setForegroundColor(0, 0, 0);
run("Fill", "slice");

selectWindow("dapiMaxima");
run("Select None");
run("Restore Selection");
setBackgroundColor(255, 255, 255);
run("Clear Outside");
run("Select None");

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
//roiManager("Reset");
//run("Analyze Particles...", "size=0-Infinity show=Masks add in_situ");
//roiManager("Show None");

selectWindow("cellEdges");
close();
selectWindow("cellMask");
close();
selectWindow("dapiMaxima");
close();
selectWindow("cellEdges-watershed");
rename("cellMask");

//--Save cell segmentation image
selectWindow("cellMask");
run("Create Selection");
selectWindow("dapi");
run("Restore Selection");
run("Flatten");
saveAs("Jpeg", OutDir+File.separator+MyTitle_short+"_CellSegmentation.jpg");
wait(100);
close();
selectWindow("dapi");
close();
selectWindow("cellMask");
run("Select None");


//--SEGMENT TUMOR CELLS

selectWindow("orig");
  // cGFAP=7;
run("Duplicate...", "title=tumor duplicate channels="+cGFAP);
//run("8-bit");
run("Mean...", "radius=3");
run("Enhance Contrast", "saturated=0.35");
	// thMethodTum="Default";
//setAutoThreshold(thMethodTum+" dark");
    // thGFAP=2.4;
setThreshold(thGFAP,255);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Median...", "radius=1");
run("Analyze Particles...", "size=30-Infinity pixel show=Masks in_situ");
run("Invert");
run("Median...", "radius=4");
run("Analyze Particles...", "size=400-Infinity pixel show=Masks in_situ");
run("Invert");
selectWindow("tumor");
roiManager("Select", 0);
setBackgroundColor(255, 255, 255);
run("Clear Outside");
run("Select None");
run("Create Selection");
roiManager("Add");		// Roi1 --> Tumor region
run("Select None");
//close();

selectWindow("merge");
roiManager("Select", 1);
roiManager("Set Color", "#A500FF");
roiManager("Set Line Width", 4);
run("Flatten");
saveAs("Jpeg", OutDir+File.separator+MyTitle_short+"_TissueAndTumorSegmentation.jpg");
wait(100);
close();
selectWindow("merge");
close();
selectWindow("orig");

//--Measure tumor area
run("Clear Results");
roiManager("Select", 1);
run("Measure");
run("Select None");
Atumor = getResult("Area", 0);
run("Clear Results");


// CHECK ONE BY ONE WHICH CELLS ARE PART OF THE TUMOR

selectWindow("cellMask");
roiManager("Reset");
run("Analyze Particles...", "size=0-Infinity show=Masks add in_situ");
roiManager("Show None");
nCells=roiManager("Count");
selectWindow("cellMask");
run("Select All");
setBackgroundColor(255, 255, 255);
run("Clear", "slice");
wait(100);

run("Clear Results");
selectWindow("tumor");
run("Select None");
roiManager("Deselect");
roiManager("Measure");
selectWindow("cellMask");	// fill in cellMask only nuclei positive por RNA
for (i=0; i<nCells; i++)
{
	Ii=getResult("Mean",i);	
	if (Ii!=0) {	//if there is RNA spot, negative cell --> delete ROI
  		roiManager("Select", i);
		run("Fill", "slice");
  	}  	 	
}
run("Select None");
roiManager("Reset");

//--Count number of cells in the tumor compartment:
selectWindow("cellMask");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCellsTumor = nResults;

selectWindow("tumor");
//close();
selectWindow("nucleiMask");
//close();
imageCalculator("AND", "nucleiMask","cellMask");	//keep only tumoral nuclei


////////////////////
//--PHENOTYPING...
////////////////////

//--CD3
nCD3 = Find_Phenotype("CD3", cCD3, thCD3, minMarkerPerc, "cytoplasmic");
print("Number of CD3+ cells: "+nCD3);

//--CD8
nCD8 = Find_Phenotype("CD8", cCD8, thCD8, minMarkerPerc, "cytoplasmic");
print("Number of CD8+ cells: "+nCD8);

//--CD11b
nCD11b = Find_Phenotype("CD11b", cCD11b, thCD11b, minMarkerPerc, "cytoplasmic");
print("Number of CD11b+ cells: "+nCD11b);

//--CD163
nCD163 = Find_Phenotype("CD163", cCD163, thCD163, minCD163Perc, "cytoplasmic");
print("Number of CD163+ cells: "+nCD163);

//--Foxp3
nFoxp3 = Find_Phenotype("Foxp3", cFoxp3, thFoxp3, minFoxp3Perc, "nuclear");
print("Number of Foxp3+ cells: "+nFoxp3);


//--DETECT ERITROCITES EXPRESSING CD11b + Foxp3

//--Foxp3 in cytoplasm (they are usually eritrocites)
nFoxp3_cyt = Find_Phenotype("Foxp3_cyt", cFoxp3, thFoxp3, minFoxp3Perc, "cytoplasmic");

//--CD11b+Foxp3 (Foxp3 both in nucleus or cytoplasm, these should be erotrocites)
imageCalculator("OR", "Foxp3_cyt","Foxp3");
imageCalculator("AND create", "CD11b","Foxp3_cyt");
rename("CD11b_Foxp3");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD11b_Foxp3 = nResults;
selectWindow("Foxp3_cyt");
close();


// Use a lower threshold to detect a -maybe faint- combined expression of CD11b and Foxp3. If one of them
// is lower than these "low" threshold, then that cell should be a real CD11b+ or Foxp3+ cell

thFoxp3_low = thFoxp3*lowThPerc/100;
thCD11b_low = thCD11b*lowThPerc/100;

//--Foxp3 in cytoplasm with low threshold (they are usually eritrocites)
nFoxp3_low = Find_Phenotype("Foxp3_low", cFoxp3, thFoxp3_low, minFoxp3Perc, "cytoplasmic");
//--CD11b with low threshold
nCD11b_low = Find_Phenotype("CD11b_low", cCD11b, thCD11b_low, minMarkerPerc, "cytoplasmic");

//--CD11b+Foxp3 (Foxp3 both in nucleus or cytoplasm, these should be erotrocites)
imageCalculator("AND create", "CD11b_low","Foxp3_low");
rename("CD11b_Foxp3_low");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD11b_Foxp3_low = nResults;
selectWindow("Foxp3_low");
close();
selectWindow("CD11b_low");
close();


//--DOUBLE POSITIVES...

//--CD3+CD8
imageCalculator("AND", "CD8","CD3");
selectWindow("CD8");
imageCalculator("Subtract", "CD8","CD11b_Foxp3");	// take out the CD11b-Foxp3
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD8 = nResults;

//--CD8+Foxp3
imageCalculator("AND create", "CD8","Foxp3");
rename("CD8_Foxp3");
imageCalculator("Subtract", "CD8_Foxp3","CD11b_Foxp3");	// take out the CD11b-Foxp3
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD8_Foxp3 = nResults;

//--CD3+Foxp3
imageCalculator("AND create", "CD3","Foxp3");
rename("CD3_Foxp3");
imageCalculator("Subtract", "CD3_Foxp3","CD8_Foxp3");	// take out the CD8-Foxp3
imageCalculator("Subtract", "CD3_Foxp3","CD11b_Foxp3");	// take out the CD11b-Foxp3
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD3_Foxp3 = nResults;

//--CD8+CD11b
imageCalculator("AND create", "CD8","CD11b");
rename("CD8_CD11b");
imageCalculator("Subtract", "CD8_CD11b","CD11b_Foxp3");	// take out the CD11b-Foxp3
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD8_CD11b = nResults;

//--CD3+CD11b
imageCalculator("AND create", "CD3","CD11b");
rename("CD3_CD11b");
imageCalculator("Subtract", "CD3_CD11b","CD8_CD11b");	// take out the CD8-CD11b
imageCalculator("Subtract", "CD3_CD11b","CD11b_Foxp3");	// take out the CD11b-Foxp3
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD3_CD11b = nResults;

//--CD163+CD11b
imageCalculator("AND create", "CD163","CD11b");
rename("CD163_CD11b");
imageCalculator("Subtract", "CD163_CD11b","CD11b_Foxp3");	// take out the CD11b-Foxp3
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD163_CD11b = nResults;


//--RECALCULATE SINGLE POSITIVES ELLIMINATING DOUBLE POSITIVES

roiManager("Reset");

// CD3
// Take out CD3-CD8 cells:
imageCalculator("Subtract", "CD3","CD8");
// Take out CD3-CD11b cells:
imageCalculator("Subtract", "CD3","CD3_CD11b");
// Take out CD3-Foxp3 cells:
imageCalculator("Subtract", "CD3","CD3_Foxp3");
// Take out CD11b-Foxp3 cells:
imageCalculator("Subtract", "CD3","CD11b_Foxp3");
// Recalculate single CD3+ cells:
selectWindow("CD3");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD3 = nResults;

// CD8
// Take out CD8-CD11b cells:
imageCalculator("Subtract", "CD8","CD8_CD11b");
// Take out CD8-Foxp3 cells:
imageCalculator("Subtract", "CD8","CD8_Foxp3");
// Take out CD11b-Foxp3 cells:
imageCalculator("Subtract", "CD8","CD11b_Foxp3");
// Recalculate single CD8+ cells:
selectWindow("CD8");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD8 = nResults;

// CD11b
// Take out CD8-CD11b cells:
imageCalculator("Subtract", "CD11b","CD8_CD11b");
// Take out CD3-CD11b cells:
imageCalculator("Subtract", "CD11b","CD3_CD11b");
// Take out CD163-CD11b cells:
imageCalculator("Subtract", "CD11b","CD163_CD11b");
// Take out FAINT CD11b-Foxp3 cells:
imageCalculator("Subtract", "CD11b","CD11b_Foxp3_low");
// Recalculate single CD11b+ cells:
selectWindow("CD11b");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD11b = nResults;

// Foxp3
// Take out CD8-Foxp3 cells:
imageCalculator("Subtract", "Foxp3","CD8_Foxp3");
// Take out CD3-Foxp3 cells:
imageCalculator("Subtract", "Foxp3","CD3_Foxp3");
// Take out FAINT CD11b-Foxp3 cells:
imageCalculator("Subtract", "Foxp3","CD11b_Foxp3_low");
// Recalculate single Foxp3+ cells:
selectWindow("Foxp3");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nFoxp3 = nResults;

// CD163
// Take out CD11b-Foxp3 cells:
imageCalculator("Subtract", "CD163","CD11b_Foxp3");
// Take out CD163-CD11b cells:
imageCalculator("Subtract", "CD163","CD163_CD11b");
// Recalculate single CD163+ cells:
selectWindow("CD163");
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nCD163 = nResults;

// Calculate CD163/CD8 ratio to identify patients with high CD8 and low CD163:
rCD163_CD8 = nCD163/nCD8;

selectWindow("CD11b_Foxp3_low");
close();


//--Write results:
run("Clear Results");
if(File.exists(output+File.separator+"QuantificationResults.xls"))
{	
	//if exists add and modify
	open(output+File.separator+"QuantificationResults.xls");
	wait(500);
	IJ.renameResults("Results");
	wait(500);
}
i=nResults;
wait(100);
setResult("Label", i, MyTitle); 
setResult("Total tissue area (um2)", i, Atissue); 
setResult("# Cells in total tissue", i, nCells); 
setResult("Total tumor area (um2)", i, Atumor); 
setResult("# Cells in tumor", i, nCellsTumor); 
setResult("# CD3+ in tumor", i, nCD3); 
setResult("# CD8+ in tumor", i, nCD8); 
setResult("# CD11b in tumor", i, nCD11b); 
setResult("# CD163 in tumor", i, nCD163); 
setResult("# Foxp3 in tumor", i, nFoxp3); 
setResult("# CD3+_CD11b+ in tumor", i, nCD3_CD11b); 
setResult("# CD8+_CD11b+ in tumor", i, nCD8_CD11b); 
setResult("# CD3+_Foxp3+ in tumor", i, nCD3_Foxp3); 
setResult("# CD8+_Foxp3+ in tumor", i, nCD8_Foxp3);
setResult("# CD163+_CD11b+ in tumor", i, nCD163_CD11b);
setResult("Ratio CD163/CD8", i, rCD163_CD8); 
saveAs("Results", output+File.separator+"QuantificationResults.xls");
	


// SAVE DETECTIONS:

roiManager("Reset");

// CD3
selectWindow("CD3");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 0);
//Roi.setStrokeColor(255,165,0);
roiManager("Set Color", "#FFA500");
roiManager("rename", "CD3");
roiManager("Set Line Width", 2);

// CD8
selectWindow("CD8");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 1);
roiManager("Set Color", "red");
roiManager("rename", "CD8");
roiManager("Set Line Width", 2);

// CD11b
selectWindow("CD11b");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 2);
roiManager("Set Color", "yellow");
roiManager("rename", "CD11b");
roiManager("Set Line Width", 2);

// CD163
selectWindow("CD163");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 3);
roiManager("Set Color", "green");
roiManager("rename", "CD163");
roiManager("Set Line Width", 2);

// Foxp3
selectWindow("Foxp3");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 4);
roiManager("Set Color", "magenta");
roiManager("rename", "Foxp3");
roiManager("Set Line Width", 2);

// CD3_CD11b
selectWindow("CD3_CD11b");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 5);
roiManager("Set Color", "white");
roiManager("rename", "CD3_CD11b");
roiManager("Set Line Width", 2);

// CD8_CD11b
selectWindow("CD8_CD11b");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 6);
roiManager("Set Color", "white");
roiManager("rename", "CD8_CD11b");
roiManager("Set Line Width", 2);

// CD3_Foxp3
selectWindow("CD3_Foxp3");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 7);
roiManager("Set Color", "white");
roiManager("rename", "CD3_Foxp3");
roiManager("Set Line Width", 2);

// CD8_Foxp3
selectWindow("CD8_Foxp3");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 8);
roiManager("Set Color", "white");
roiManager("rename", "CD8_Foxp3");
roiManager("Set Line Width", 2);

// CD163_CD11b
selectWindow("CD163_CD11b");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 9);
roiManager("Set Color", "white");
roiManager("rename", "CD163_CD11b");
roiManager("Set Line Width", 2);

// CD11b_Foxp3
selectWindow("CD11b_Foxp3");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 10);
roiManager("Set Color", "white");
roiManager("rename", "CD11b_Foxp3");
roiManager("Set Line Width", 2);

// TUMOR
selectWindow("tumor");
run("Create Selection");
type = selectionType();
if(type==-1) { makeRectangle(1,1,1,1); }
roiManager("Add");
close();
selectWindow("orig");
roiManager("Select", 11);
roiManager("Set Color", "#A500FF");
roiManager("rename", "Tumor");
roiManager("Set Line Width", 2);


roiManager("Deselect");
roiManager("Save", OutDir+File.separator+MyTitle_short+"_ROIs.zip");

selectWindow("orig");
saveAs("Tiff", OutDir+File.separator+MyTitle_short+"_orig.tif");

if (InDir!="-") {
close(); }

selectWindow("nucleiMask");
close();
selectWindow("cellMask");
close();


//Clear unused memory
wait(500);
run("Collect Garbage");

//showMessage("Done!");

}


function Find_Phenotype(phName, ch, thMarker, minMarkerPerc, markerLoc) {

if(markerLoc=="nuclear") {
	maskToUse="nucleiMask";
}
else {
	maskToUse="cellMask";
}

selectWindow("orig");
run("Select None");
run("Duplicate...", "title="+phName+"mask duplicate channels="+ch);
//run("8-bit");
run("Mean...", "radius=2");
  //thMarker=30;  
setThreshold(thMarker, 255);
setOption("BlackBackground", false);
run("Convert to Mask");
//--AND between marker mask and tumoral cell mask so that marker in individual cells is left and 
// size filtering may be applied to detect positive cells with a certain no. of positive pixels
imageCalculator("AND", phName+"mask",maskToUse);
//run("Analyze Particles...", "size=20-Infinity pixel show=Masks in_situ");
//run("Analyze Particles...", "size="+minMarkerPerc+"-Infinity pixel show=Masks in_situ");

//--Detect marker-positive cells in the tumor
selectWindow("cellMask");
run("Select None");
run("Duplicate...", "title="+phName);
roiManager("Reset");
run("Analyze Particles...", "size=0-Infinity show=Masks add in_situ");
roiManager("Show None");
n=roiManager("Count");
selectWindow(phName);
run("Select All");
setBackgroundColor(255, 255, 255);
run("Clear", "slice");
wait(100);
run("Clear Results");
selectWindow(phName+"mask");
run("Select None");
roiManager("Deselect");
roiManager("Measure");
selectWindow(phName);	// fill in marker mask with only marker-positive cells in the tumor
for (i=0; i<n; i++)
{
	Aperc=getResult("%Area",i);	
	if (Aperc>=minMarkerPerc) {	
  		roiManager("Select", i);
		run("Fill", "slice");
  	}	 	 	
}
run("Select None");
roiManager("Reset");
//--Count number of marker-positive cells in the tumor:
selectWindow(phName);
run("Select None");
run("Analyze Particles...", "size=0-Infinity pixel show=Masks display clear in_situ");
nMarkerCells = nResults;

selectWindow(phName+"mask");
close();
selectWindow(phName);
	
return nMarkerCells;
	
}



