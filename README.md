# Cellpose-Fiji
ImageJ1 macros to run Cellpose within Fiji (using the BIOP-EPFL plugin) and to match label values in independent labelmaps of nuclei and cell bodies.

_**NOTE**: These macros will not work with the latest version of the BIOP Cellpose Wrapper! In the comings weeks we will (hopefully find the time to) update this repository._

## runCellpose_2D.ijm
ImageJ1 macro to run Cellpose on an image or active (rectangular) selection and display the segmentation as colored overlay.
Labels are also added to the ROI Manager.

Input: 2D image or 2D timelapse.

Output: (timelapse) labelmap, ROIs

Requirements:
- A working [Cellpose Python environment](https://github.com/MouseLand/cellpose#local-installation).
- Fiji Update Site: PTBIOP
- Follow the [Enable conda command outside conda prompt](https://github.com/BIOP/ijl-utilities-wrappers#-enable-conda-command-outside-conda-prompt-) part of the instructions on https://github.com/BIOP/ijl-utilities-wrappers

Note that the hard work has been done by others, namely the Cellpose authors and the BIOP at EPFL.

Please cite the [Cellpose article](https://www.nature.com/articles/s41592-020-01018-x) if you use this macro in a publication.

N.B. In this macro the 'cyto2' model currently does not work on 2-channel images (cells and nuclei). This should be fixed very soon.

![image](https://user-images.githubusercontent.com/33119248/137392416-88a7b8cf-25ee-4116-8b54-b582459e9443.png)

## match_cells_and_nuclei_labelmaps.ijm
Macro to match the label values of a nuclei labelmap with a cell body labelmap.
Cells can have multiple nuclei. Nuclei without a cell body are removed.

Input: Two 2D labelmaps.

Output:
- labelmap with nuclei labels reassigned to match the cells
- labelmap of the cytoplasm (cell body minus nuclei)
- labelmap of cells without an assigned nucleus (empty cells)
- labelmap of cells without an assigned nucleus minus any other nuclei that overlap, but are assigned to another cell
- (Not yet available) labelmap of nuclei without a cell body

Requirements:
- Fiji Update sites: CLIJ and CLIJ2

Please cite the [CLIJ](https://www.nature.com/articles/s41592-019-0650-1) article if you use this macro in a publication.

Input label images: nuclei and cells (label values do not match - colors are different):

![image](https://user-images.githubusercontent.com/33119248/138616840-4ec7daf7-b312-4b33-9da2-3575ce8c05e3.png)

Output label images: reassigned nuclei, cytoplasm, empty cells with nuclei overlap removed:

![image](https://user-images.githubusercontent.com/33119248/138616883-3c390fcc-e729-4942-b3fc-4bc1ed8fbd4c.png)

