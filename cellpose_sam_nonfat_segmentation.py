
##------------------------------
# Cellpose-SAM DAPI Segmentation 
##------------------------------
    # Run using cellpose conda environment 
import numpy as np
from cellpose import models, core, io, plot
from pathlib import Path
from tqdm import trange
import matplotlib.pyplot as plt
from natsort import natsorted
import os 
import re 
import pandas as pd 
io.logger_setup() 
model = models.CellposeModel(gpu=False)
print("Loaded model")

mem_marker_list = ["CD3e", "HLA-A"]
human_dir = "/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/"
#block_dirs = [os.path.join(human_dir, block_dir) for block_dir in os.listdir(human_dir) if os.path.isdir(os.path.join(human_dir, block_dir))]
# Specifying block order b/c I want to prioritize block6 and block2
# block_dirs = ['/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/block6_patches', 
#               '/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/block2_patches', 
#               '/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/block3_patches', 
#               '/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/block4_patches', 
#               '/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/block5_patches', 
#               '/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/block1_patches']
block_dirs = ['/stor/scratch/Ehrlich/MxIF/aging_thymus/human_images/human_blocks/block5_patches']
for block_dir in block_dirs: 
    print(f"Staring {block_dir}")
    img_dirs = [os.path.join(block_dir, block_file) for block_file in os.listdir(block_dir) if not re.search("markers", block_file)]
    for img_dir in img_dirs:
        print(f"Starting {img_dir}")
        all_img = io.imread(os.path.join(img_dir, "image.ome.tif")).astype("uint8")
        
        # Make all thymus membrane channel
        marker_df = pd.read_csv(os.path.join(img_dir, "markers.csv"))
        mem_channel_indices = marker_df.loc[marker_df["marker_name"].isin(mem_marker_list), "row_num"].values.tolist()
        img_cp = np.stack((all_img[mem_channel_indices].sum(axis=0), all_img[0]), axis=0).astype("uint8") # Taken from cellpose doc https://cellpose.readthedocs.io/en/latest/settings.html#channels
        
        # Run segmentation 
        masks, flows, styles = model.eval(img_cp, cellprob_threshold = -6, flow_threshold = 1)
        io.imsave(os.path.join(img_dir, "nonfat_cell_mask.tif"), masks)
