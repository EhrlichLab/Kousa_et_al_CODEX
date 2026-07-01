

# Mcquant quick guide 

# binary mask quant
mxif_dir="/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks"

# Only keeping tissues with usable stains. Some did not stain well or had no epithelial tissue in focus or no nuclear DAPI
b1_usable_dirs="block1_patches/P31_27F block1_patches/P32_46F block1_patches/P33_10M block1_patches/P37_62F block1_patches/T2008_7M block1_patches/T2033_9F block1_patches/T2066_8M"
b2_usable_dirs="block2_patches/P34_29F block2_patches/P35_38F block2_patches/P36_67F block2_patches/T2056-2_0.008M block2_patches/T2092-4_0.833M block2_patches/T2095-2_22M block2_patches/T2101-1_1M"
b3_usable_dirs="block3_patches/T2019-2_0.013F block3_patches/T2040-2_8F block3_patches/T2044-2_1.166F block3_patches/T2087-2_0.003M"
b4_usable_dirs="block4_patches/P41-E1_58F block4_patches/P52_21M block4_patches/T2018-3_0.3F block4_patches/T2036-3_7F block4_patches/T2049-1_0.013M block4_patches/T2077-1_0.013F block4_patches/T2083-1_0.917F"
b5_usable_dirs="block5_patches/T2047-1_0.333F block5_patches/T2037-3_1.583M block5_patches/A1_20wkM block5_patches/T2052-1_0.021M"
b6_usable_dirs="block6_patches/A3_18wkF block6_patches/P42_54F block6_patches/P44_64F block6_patches/P49_2M block6_patches/P57_17F block6_patches/T2110-1_0.025M"
usable_dirs="${b1_usable_dirs} ${b2_usable_dirs} ${b3_usable_dirs} ${b4_usable_dirs} ${b5_usable_dirs} ${b6_usable_dirs}"




script_dir="/stor/work/Ehrlich/Users/John/projects/perinatal_thymus/thymus_MxIF"
# conda activate mcquant 
for usable_dir in $usable_dirs; do 
    cd "${mxif_dir}/${usable_dir}"
    echo "${mxif_dir}/${usable_dir}"
    OME_TIFF_name=$(ls | grep thresh_full_auto_thresh_binary_filt_masks.ome.tif)
    marker_file="mask_filt_markers.csv"

    if [ ! -f "no_touch_nonfat_cell_mask.tif" ]; then
        echo "no_touch_nonfat_cell_mask.tif not found, making it now" 
        /stor/work/Ehrlich/Users/John/mamba/envs/mesmer_pypi/bin/python \
            $script_dir/remove_touching_edges.py \
            --directory ./ \
            --mask-file nonfat_cell_mask.tif \
            --kernel-size 2
    fi

    mcquant \
        --masks ./no_touch_nonfat_cell_mask.tif \
        --image ./$OME_TIFF_name \
        --output ./ \
        --channel_names ./$marker_file \
        --intensity_props intensity_mean

    echo "Done with ${usable_dir}"
done

