from ij.io import DirectoryChooser  
import os
from ij import IJ  

InDir = DirectoryChooser("Choose a folder")  
folder = InDir.getDirectory()
list=os.listdir(folder)

for j in list:
	if j.endswith(".tif"):
		IJ.run("Bio-Formats Importer", "open="+folder+j+" autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
		IJ.run ('Rename...', 'title=orig-'+j)
		IJ.run("Make Composite", "display=Composite");
		IJ.run("Duplicate...", "title=dapi"+j+" duplicate channels=1");
		IJ.run("Blue");
		IJ.run("Enhance Contrast", "saturated=0.35");
		IJ.selectImage("orig-"+j);
		IJ.run("Duplicate...", "title=cd8"+j+" duplicate channels=4");
		IJ.run("Red");
		IJ.run("Enhance Contrast", "saturated=0.35");
		IJ.selectImage("orig-"+j);
		IJ.run("Duplicate...", "title=batf3"+j+" duplicate channels=5");
		IJ.run("Green");
		IJ.run("Enhance Contrast", "saturated=0.35");
		IJ.run("Merge Channels...", "c1=dapi"+j+" c4=cd8"+j+" c5=batf3"+j+" create");
		IJ.run('Rename...', 'title=merge-'+j)
		IJ.selectImage("merge-"+j);




