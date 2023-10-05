
open("C:/Users/maria.sanguesa/Desktop/8bittt.tif");
selectImage("8bittt.tif");
roiManager("Deselect");
run("To ROI Manager");
run("From ROI Manager");
run("Z Project...", "projection=[Max Intensity]");
selectImage("MAX_8bittt.tif");
run("Z Project...");
run("Multi-class mask(s) from Roi(s)", "show_mask(s) save_in=C:/Users/maria.sanguesa/Desktop/Pruebas/ suffix=[] save_mask_as=tif rm=[RoiManager[size=5466, visible=true]]");
close();
run("Images to Stack");
run("Z Project...");
run("Fill ROI holes");
run("From ROI Manager");
run("script:Macro.ijm.ijm");
run("From ROI Manager");
run("Multi-class mask(s) from Roi(s)", "show_mask(s) save_in=C:/Users/maria.sanguesa/Desktop/Pruebas/ suffix=[] save_mask_as=tif rm=[RoiManager[size=5466, visible=true]]");
