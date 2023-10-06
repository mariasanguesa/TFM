// Crear una imagen con las mismas dimensiones que la original. De 16-bit
getDimensions(width, height, channels, slices, frames);
newImage("filled", "16-bit black", width, height, 1);

roiTotal = roiManager("count");

// Variables que servirán para escoger el valor de gris del relleno 
x = 255;
y = 255;
z = 255;

for (j=0; j<roiTotal; j++){
	roiManager("Select", j);
	z-=1;
	if(z<0){
		z=255;
		y-=1;
		if(y<0){
			y=255;
			x-=1;
		}	
	}
	setForegroundColor(x, y, z);
	run("Fill", "slice");
}

