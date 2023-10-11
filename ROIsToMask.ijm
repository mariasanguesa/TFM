// Crear una imagen con las mismas dimensiones que la original. De 16-bit
getDimensions(width, height, channels, slices, frames);
newImage("filled", "16-bit black", width, height, 1);

roiTotal = roiManager("count");

// Variables que servirán para escoger el valor de gris del relleno 

x = 0;
y = 0;
z = 0;

for (j=0; j<roiTotal; j++){
	roiManager("Select", j);
	z+=1;
	if(z>255){
		z=0;
		y+=1;
		if(y>255){
			y=0;
			x+=1;
		}	
	}
	setForegroundColor(x, y, z);
	run("Fill", "slice");
}

/*
for (j=0; j<roiTotal; j++){
	roiManager("Select", j);
	Roi.getContainedPoints(xpoints, ypoints);
	for (x = 0; x < xpoints.length; x++) {
		for (y = 0; y < ypoints.length; y++) {
			setPixel(xpoints[x], ypoints[y], j);
		}
	}

}
*/