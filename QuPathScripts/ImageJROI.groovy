import ij.plugin.frame.RoiManager

def imageData = getCurrentImageData()
def name = GeneralTools.getNameWithoutExtension(imageData.getServer().getMetadata().getName())

def path = buildFilePath('C:/Users/msang/OneDrive - UPNA/Imágenes TFM/ROIs', "ROIs"+name+".zip")

def annotations = getAnnotationObjects()
def roiMan = new RoiManager(false)
double x = 0
double y = 0
double downsample = 1 // Increase if you want to export to work at a lower resolution
annotations.each {
  def roi = IJTools.convertToIJRoi(it.getROI(), x, y, downsample)
  roiMan.addRoi(roi)
}
roiMan.runCommand("Save", path)