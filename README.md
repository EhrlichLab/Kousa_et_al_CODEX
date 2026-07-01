# Kousa_et_al_CODEX
Code for analyzing CODEX multiplex immunofluorescence imaging in Kousa et al., 2026


## Analysis scripts 
1. cellpose_sam_segmentation.py -- Segmentation of CODEX images using Cellpose SAM based on DAPI, CD3E, and HLA-A.

2. make_channel_names_for_human_images.ipynb -- Extract marker name metadata from images.

3. creating_binary_marker_masks.ipynb -- Apply minimum and maximum thresholds for each marker per batch of images.

4. mcquant_on_mask_filt_images.sh -- Quantify thresholded marker expression per cell using the Cellpose-SAM segmentation masks. 

5. make_anndata_from_binary_filt_mean.ipynb -- Make anndata objects using mean normalized marker expression per cell.

6. binary_mask_filt_mean_leiden_clustering_2026-01-26.ipynb -- Leiden clustering of representative image to determine cell types.

7. overlay_and_combine_clusters_w_squidpy_2026-01-26.ipynb -- Visualization of leiden clusters to determine cell type based on marker expression and spatial location.

8. SPACEc_cell_annotation_ml_human_codex.ipynb -- Training machine learning classifier using manually annotated cell types based on leiden clusters to annotate remaining CODEX images.

## Plotting code
10. thymocyte_annotation_plots_Kousa_2026.ipynb -- Code for thymocyte annotation plots in Kousa et al., 2026.

11. thymocyte_DP_P_Q_freq_plot.qmd -- Code for thymocyte annotation plots in Kousa et al., 2026

## Code environment details

- kousa_2026_codex_env.yml -- Conda environment used to run python code except for Cellpose segmentation. 

- cellpose_env.yml -- Conda environment used to run Cellpose.

- spacec_gpu_build.dockerfile -- Dockerfile used to run SPACEc.

- Kousa_2026_R_session_info.txt -- R sessionInfo() output used to run thymocyte_DP_P_Q_freq_plot.qmd.

- Images were visualized using QuPath version 0.5.1. 
