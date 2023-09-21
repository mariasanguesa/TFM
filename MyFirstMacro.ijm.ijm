
// Variable definition
var cDAPI=1, cCD8=4, cBatf3=5;

Dialog.create("Parameters for the analysis");
// Channels:
Dialog.addMessage("Choose channel numbers");
Dialog.addNumber("DAPI", cDAPI);	
Dialog.addNumber("CD8", cCD8);	
Dialog.addNumber("Batf3", cBatf3);

Dialog.show();	
cDAPI= Dialog.getNumber();
cCD8= Dialog.getNumber();
cBatf3= Dialog.getNumber();

InDir=getDirectory("Choose directory");
list=getFileList(InDir);
L=lengthOf(list);

OutDir = InDir+File.separator+"3ChannelImages";
File.makeDirectory(OutDir);

for (j=0; j<L; j++){
	if(endsWith(list[j],"tif")){		
		name=list[j];

		open(InDir+list[j]);	
		rename("orig"+name);

		// Make composite from 8-channel image
		run("Make Composite", "display=Composite");
		
		run("Duplicate...", "title=dapi"+name+" duplicate channels="+cDAPI);
		run("Blue");
		run("Enhance Contrast", "saturated=0.35");
		selectImage("orig"+name);
		run("Duplicate...", "title=cd8"+name+" duplicate channels="+cCD8);
		run("Red");
		run("Enhance Contrast", "saturated=0.35");
		selectImage("orig"+name);
		run("Duplicate...", "title=batf3"+name+" duplicate channels="+cBatf3);
		run("Green");
		run("Enhance Contrast", "saturated=0.35");
		run("Merge Channels...", "c1=dapi"+name+" c4=cd8"+name+" c5=batf3"+name+" create");
		rename("merge"+name);
		selectImage("merge"+name);
		saveAs("JPeg", OutDir+File.separator+"3Channel"+name);

	}
}
