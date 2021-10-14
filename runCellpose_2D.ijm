/*  Macro to run Cellpose on a 2D image or active (rectangular) selection and display the segmentation as colored overlay.
 *  Labels are also added to the ROI Manager.
 *  
 *  Input: 2D image or 2D time-lapse image.
 *  Output: (timelapse) Labelmap and ROIs
 *  
 *  Requirements:
 *  - A working Cellpose Python environment.
 *  - Fiji Update Site: PTBIOP
 *  - Follow the instructions on https://github.com/BIOP/ijl-utilities-wrappers
 *  
 *  Author: Bram van den Broek, The Netherlands Cancer Institute.
 *  Note that the hard work has been done by others, namely the Cellpose authors and the BIOP at EPFL.
 *  
 *  Please cite the Cellpose article if you use this macro in a publication:
 *  https://www.nature.com/articles/s41592-020-01018-x.
 */

#@ String (label = "Cellpose model", choices={"cyto", "cyto2", "nuclei"}, style="listBox") cellposeModel
#@ Integer(label="Cell diameter", value=20) cellposeDiameter
#@ Float(label="Cell flow error threshold", style="slider", value=1, min=0, max=3, stepSize=0.1) cellposeFlowThreshold
#@ Float(label="Cell probability threshold", style="slider", value=0, min=-6, max=6, stepSize=0.25) cellposeProbability
#@ Integer(label="Cytoplasm channel (-1 means not present)", value=1, min=-1) cytoChannel
#@ Integer(label="Nucleus channel (-1 means not present)", value=-1, min=-1) nucChannel
#@ Boolean(label="Display segmentation as colored overlay on the image?", value=true) displayOverlay

image = getTitle();
run("Remove Overlay");
useSelection = false;
if(selectionType==0) {
	useSelection = true;
	getSelectionBounds(x, y, width, height);
}
run("Cellpose Advanced", "diameter="+cellposeDiameter+" cellproba_threshold="+cellposeProbability+" flow_threshold="+cellposeFlowThreshold+" model="+cellposeModel+" nuclei_channel="+nucChannel+" cyto_channel="+cytoChannel+" dimensionmode=2D");
setBatchMode(true);
getMinAndMax(min, max);
if(max < 255) setMinAndMax(0, 255);
print(max + " objects found.");
segmentation = getTitle();
if(!endsWith(segmentation, "-cellpose")) exit("Cellpose did not return a labelmap");
rename(segmentation + "__" + cellposeModel + "_diam_" + cellposeDiameter + "_flowTH_" + cellposeFlowThreshold + "_cellProb_" + cellposeProbability);
labelmap = getTitle;
run("glasbey_on_dark");
roiManager("reset");
setBatchMode(true);
selectWindow(labelmap);
run("Label image to ROIs", "rm=[RoiManager[visible=true]]");
roiManager("show none");
setBatchMode(false);
selectWindow(image);
if(displayOverlay == true) {
	run("Add Image...", "image="+labelmap+" x=0 y=0 opacity=33 zero");
	if(useSelection == true) {
		Overlay.moveSelection(0, x, y);	//Move the overlay to the location of the rectangular selection 
		for (i = 0; i < roiManager("count"); i++) {
			roiManager("select", i);
			Roi.getBounds(x_roi, y_roi, width_roi, height_roi);
			Roi.move(x + x_roi, y + y_roi);
			roiManager("Set Color", "gray");
			roiManager("update");
		}
	}
}
roiManager("Associate", "true");
roiManager("Show All without labels");
if(useSelection == true) makeRectangle(x, y, width, height);
