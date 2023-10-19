// Primero cargo la máscara con las zonas que quiero eliminar
name = getTitle();
MyTitle = split(name,"-");
MyTitle_short = MyTitle[0];

roiManager("Open", "C:/Users/maria.sanguesa/OneDrive - UPNA/Imágenes TFM/ROIsToExclude/ROIs_exclude_"+MyTitle_short+".zip");
roiManager("Combine");
run("Create Mask");
rename("Mask_"+MyTitle_short);

roiManager("Deselect");
roiManager("Delete");

roiManager("Open", "C:/Users/maria.sanguesa/OneDrive - UPNA/Imágenes TFM/ROIs/ROIs"+MyTitle_short+".zip");

roiManager("Measure");

getDimensions(width, height, channels, slices, frames);
newImage(MyTitle_short+"-mask_exclude", "16-bit black", width, height, 1);
roiTotal = roiManager("count");

for (j=0; j<roiTotal; j++){
	roiManager("Select", j);
	grayLevel = getResult("Mean",j);
	Roi.getContainedPoints(xpoints, ypoints);
	if(grayLevel==0){
		for (i = 0; i < xpoints.length; i++) {
			setPixel(xpoints[i], ypoints[i], j);
		}
	}

}

saveAs("Tiff","C:/Users/maria.sanguesa/OneDrive - UPNA/Imágenes TFM/Masks_Exclude/" +MyTitle_short+"-mask_exclude");
