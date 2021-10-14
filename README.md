# cellpose-FIJI
ImageJ1 macro to run Cellpose on an image or active (rectangular) selection and display the segmentation as colored overlay.
Labels are also added to the ROI Manager. Works on 2D timelapses as well.

Requirements:
- A working Cellpose Python environment.
- Fiji Update Site: PTBIOP
- Follow the instructions on https://github.com/BIOP/ijl-utilities-wrappers

Note that the hard work has been done by others, namely the Cellpose authors and the BIOP at EPFL.

Please cite the [Cellpose article](https://www.nature.com/articles/s41592-020-01018-x) if you use this macro in a publication.

N.B. In this macro the 'cyto2' model currently does not work on 2-channel images (cells and nuclei). This should be fixed very soon.

![image](https://user-images.githubusercontent.com/33119248/137392416-88a7b8cf-25ee-4116-8b54-b582459e9443.png)
