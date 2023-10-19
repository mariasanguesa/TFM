
name = getTitle();

MyTitle = split(name,"-");
MyTitle_short = MyTitle[0];

roiManager("Open", "C:/Users/maria.sanguesa/OneDrive - UPNA/Imágenes TFM/ROIs/ROIs"+MyTitle_short+".zip");

// Crear una imagen con las mismas dimensiones que la original. De 16-bit
getDimensions(width, height, channels, slices, frames);
newImage(MyTitle_short+"-mask", "16-bit black", width, height, 1);

roiTotal = roiManager("count");

for (j=0; j<roiTotal; j++){
	roiManager("Select", j);
	Roi.getContainedPoints(xpoints, ypoints);
	// Xpoints Ypoints coinciden en longitud. Y deben tener la misma posición para que se pueda acceder a las coordenadas del pixel
	for (i = 0; i < xpoints.length; i++) {
		setPixel(xpoints[i], ypoints[i], j);
	}

}

saveAs("Tiff","C:/Users/maria.sanguesa/OneDrive - UPNA/Imágenes TFM/Masks/" +MyTitle_short+"-mask");