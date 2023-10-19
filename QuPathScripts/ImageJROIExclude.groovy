import ij.plugin.frame.RoiManager

def imageData = getCurrentImageData()
def name = GeneralTools.getNameWithoutExtension(imageData.getServer().getMetadata().getName())
MyTitle = name.split("-");
name = MyTitle[0];
// Cuidado con el nombre de usuario: cambiar segun el PC
def path = buildFilePath('C:/Users/maria.sanguesa/OneDrive - UPNA/Imágenes TFM/ROIsToExclude', "ROIs_exclude_"+name+".zip")

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