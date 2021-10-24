/*  Macro to match the label numbers of a nuclei labelmap with a cell body labelmap.
 *  Cells can have multiple nuclei.
 *  
 *  Input: Two 2D labelmaps
 *  Output: - labelmap with nuclei labels reassigned to match the cells
 *          - labelmap of the cytoplasm (cell body minus nuclei)
 *          - labelmap of cells without an assigned nucleus (empty cells)
 *          - labelmap of cells without an assigned nucleus minus any other nuclei that overlap, but are assigned to another cell
 *          - (TO DO) labelmap of nuclei without a cell body
 *  
 *  Requirements:
 *  - Fiji Update sites: CLIJ and CLIJ2
 *  
 *  Author: Bram van den Broek, The Netherlands Cancer Institute. (b.vd.broek@nki.nl)
 *  
 *  Please cite the CLIJ article if you use this macro in a publication:
 *  https://www.nature.com/articles/s41592-019-0650-1.
 */


run("CLIJ2 Macro Extensions", "cl_device=");
Ext.CLIJ2_clear();

waitForUser("Select CELL label map and press OK");
labelmap_cells = getTitle();
waitForUser("Select NUCLEI label map and press OK");
labelmap_nuclei = getTitle();

Ext.CLIJ2_push(labelmap_cells);
Ext.CLIJ2_push(labelmap_nuclei);
Ext.CLIJ2_getMaximumOfAllPixels(labelmap_cells, nr_cells);
Ext.CLIJ2_getMaximumOfAllPixels(labelmap_nuclei, nr_nuclei);
print("nr of cells: "+nr_cells);
print("nr of nuclei: "+nr_nuclei);

//Compute the overlap index of each cell with each nucleus. Pair every cell to the nucleus with the largest overlap.
Ext.CLIJ2_generateJaccardIndexMatrix(labelmap_cells, labelmap_nuclei, jaccard_index_matrix);
Ext.CLIJ2_transposeXZ(jaccard_index_matrix, jaccard_index_matrix_transposed);
Ext.CLIJ2_argMaximumZProjection(jaccard_index_matrix_transposed, max_overlap, index_max_overlap);	//The index of the maximum is the nucleus with the largest overlap
Ext.CLIJ2_transposeXY(index_max_overlap, index_max_overlap_transposed);
labelmap_reassigned_nuclei = "labelmap_reassigned_nuclei";
Ext.CLIJ2_replaceIntensities(labelmap_nuclei, index_max_overlap_transposed, labelmap_reassigned_nuclei);
Ext.CLIJ2_pull(labelmap_reassigned_nuclei);
Ext.CLIJ2_release(jaccard_index_matrix_transposed);
Ext.CLIJ2_release(jaccard_index_matrix);
Ext.CLIJ2_release(index_max_overlap);
Ext.CLIJ2_release(max_overlap);
Ext.CLIJ2_release(index_max_overlap_transposed);

//Find missing values (cells without nuclei) and put them in a labelmap

//Create binary array of cells without a nucleus (empty cells)
selectWindow(labelmap_reassigned_nuclei);
resetMinAndMax();
run("Glasbey on dark");
getRawStatistics(nPixels, mean, min, max, std, histogram);	//histogram size is equal to the nucleus with largest label that overlaps with a cell.
empty_cells = Array.getSequence(nr_cells);
for (i = 0; i < nr_cells; i++) {
	if(i<=max) {
		if(histogram[i] != 0) empty_cells[i] = 0;
	}
}

//Create cytoplasm labelmap (cell minus reassigned nuclei)
labelmap_cytoplasm = "labelmap_cytoplasm";
Ext.CLIJ2_subtractImages(labelmap_cells, labelmap_reassigned_nuclei, labelmap_cytoplasm);
Ext.CLIJ2_pull(labelmap_cytoplasm);
run("Glasbey on dark");
setMinAndMax(0, nr_cells);	//Set LUT so that the colors match with the other label maps. 

Ext.CLIJ2_pushArray(empty_cells_image, empty_cells, nr_cells, 1, 1);
labelmap_empty_cells = "labelmap_empty_cells";
Ext.CLIJ2_replaceIntensities(labelmap_cells, empty_cells_image, labelmap_empty_cells);
Ext.CLIJ2_pull(labelmap_empty_cells);
run("Glasbey on dark");
setMinAndMax(0, nr_cells);	//Set LUT so that the colors match with the other label maps. 

//Mask part of empty cells that overlap with any nuclei
labelmap_empty_cells_masked = "labelmap_empty_cells_no_nuclei_overlap";
Ext.CLIJ2_mask(labelmap_reassigned_nuclei, labelmap_empty_cells, masked);
Ext.CLIJ2_binaryIntersection(labelmap_reassigned_nuclei, labelmap_empty_cells, mask);
Ext.CLIJ2_binaryNot(mask, mask_inverted);
Ext.CLIJ2_mask(labelmap_empty_cells, mask_inverted, labelmap_empty_cells_masked);
Ext.CLIJ2_pull(labelmap_empty_cells_masked);
resetMinAndMax();
run("Glasbey on dark");
setMinAndMax(0, nr_cells);	//Set LUT so that the colors match with the other label maps. 

selectWindow(labelmap_cytoplasm);
selectWindow(labelmap_reassigned_nuclei);
Ext.CLIJ2_clear();