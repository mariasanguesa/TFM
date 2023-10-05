roiTotal = roiManager("count");
for (j=0; j<roiTotal; j++){
	roiManager("Select", j);
	num = 254 * random();
	RoiManager.setGroup(num);
}

