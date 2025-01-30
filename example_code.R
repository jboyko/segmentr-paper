# library(SegmentR)
library(imager)
library(recolorize)
setwd("~/SegmentR/")
devtools::load_all()

##### EXAMPLE 1
results <- run_grounded_segmentation("~/segmentr-paper/extdata/images/other_images/HornedBream.jpg", labels = c("a fish.", "a fin."))
results <- get_segmentation_paths("~/segmentr-paper/extdata/images/other_images/HornedBream.jpg")
seg_res <- load_segmentation_results(results$image_path)
seg_tbl <- create_segmentation_table(seg_res)
seg_res <- remove_mask(seg_res, 2)
export_transparent_png(input = seg_res, output_path = "~/segmentr-paper/extdata/exported_segments/", remove_overlap = TRUE, crop = TRUE)
export_transparent_png(input = seg_res, prefix = "full_bream", output_path = "~/segmentr-paper/extdata/exported_segments/", remove_overlap = FALSE, crop = TRUE)

img <- readImage(results$image_path, resize = NULL, rotate = NULL)
pdf("~/segmentr-paper/figures/in-progress/example-1-original.pdf", width = 10, height = 7)
plotImageArray(img, main = "")
dev.off()

pdf("~/segmentr-paper/figures/in-progress/example-1-segmented.pdf", width = 10, height = 7)
plot_seg_results(seg_res, main = "")
dev.off()


##### EXAMPLE 2

init <- Sys.time()

run_grounded_segmentation("~/segmentr-paper/extdata/images", labels = c("an individual flower"))
results <- get_segmentation_paths("~/segmentr-paper/extdata/images")
seg_res <- load_segmentation_results(results$summary$source_directory)
for(i in 1:(length(seg_res)-1)){
  focal <- seg_res[[i]]
  export_transparent_png(input = focal, 
    output_path = "~/segmentr-paper/extdata/exported_segments/", remove_overlap = TRUE, crop = TRUE)
}

fin <- Sys.time()

fin - init

pdf(file = "~/segmentr-paper/figures/in-progress/example-2.pdf", width = 20, height = 15)
layout(matrix(1:20, nrow = 5), heights = c(1,1,1,1,0.25))
par(mar = c(1, 0, 1, 0))
# i = 1
for(i in 4:1){
  img_path <- seg_res[[i]]$paths$image
  img <- readImage(img_path, resize = NULL, rotate = NULL)
  plotImageArray(img, main = "Original image", cex.main = 5)
  img_tbl <- create_segmentation_table(seg_res[[i]])
  plot_seg_results(seg_res[[i]], mask_alpha = 0.1, show_label = FALSE, show_score = FALSE, main = "Object detection")
  flower_name <- sub("\\..*$", "",basename(img_path))
  crop_dir <- dir("~/segmentr-paper/extdata/exported_segments/chosen_examples/", full.names = TRUE)
  crop_path <- crop_dir[grep(flower_name, crop_dir)]
  crop_img <- readImage(crop_path, resize = NULL, rotate = NULL)
  plotImageArray(crop_img, main = "Segmentation and cropping")
  init_fit <- recolorize(img = crop_img, plotting = FALSE)
  recluster_results <- recluster(init_fit, cutoff = 45, plot_hclust = FALSE, plot_final = FALSE)
  recolored_img <- constructImage(recluster_results$pixel_assignments, recluster_results$centers)
  plotImageArray(recolored_img, main = "Recolored image")
  plotColorPalette(recluster_results$centers)
}
dev.off()
