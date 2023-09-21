from ij.io import DirectoryChooser  
import os
from ij import IJ  

InDir = DirectoryChooser("Choose a folder")  
folder = InDir.getDirectory()
list=os.listdir(folder)

for j in list:
	if j.endswith(".tif"):
		imp = IJ.openImage(folder+"/"+j)
		IJ.run("Bio-Formats Importer", "open="+folder+j+" autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
		imp.setTitle("orig"+j);

