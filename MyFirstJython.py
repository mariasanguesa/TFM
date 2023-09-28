from ij.io import DirectoryChooser  
import os
from ij import IJ  
from ij.plugin.frame import RoiManager

InDir = DirectoryChooser("Choose a folder")  
folder = InDir.getDirectory()
list=os.listdir(folder)

for j in list:
	if j.endswith(".tif"):
		roi_manager = RoiManager() 
		roi_manager.reset()

		orig = IJ.run("Bio-Formats Importer", "open="+folder+j+" autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_1");
		IJ.run(orig, "Make Composite", "display=Composite");
		origdup = IJ.run(orig,"Duplicate...", "title=dapi"+j+" duplicate channels=1");
		IJ.run(orig,"Blue");





