# library(SegColR)
library(imager)

# introduction
## what is object detection?
## what is instance segmentation?
## what are pretrained models?
### grounding dino and segment anything
## color extraction process

list.files(system.file(package = "SegColR"))

# 10 worked examples
example_data <- load_segcolr_example_data()

### Example 1 - basic description
img_path <- example_data$image_paths[2]
labels <- "a fish."
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")


ground_results <- grounded_segmentation_cli(img_path,
  labels,
  output_json = "/home/jboyko/BioSegment/",
  output_plot = "/home/jboyko/BioSegment/")
json_path = ground_results$json_path


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

# Assuming 'original_image' is your input image
# corrected_image <- remove_shadows(seg_results$image)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels,
  exclude_labels = NULL,
  score_threshold = 0.5,
  custom_colors = NULL
)

full_col <- color_results$color_info$dominant_color_info$hex_color

color_results_c <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels,
  exclude_labels = NULL,
  score_threshold = 0.5,
  custom_colors = full_col
)

plot_color_info(color_results_c, horiz = FALSE, repainted = TRUE)
par(mfrow=c(1,2))
plot_repainted_mask(
  image = color_results_k$image,
  final_mask = color_results_k$final_mask,
  color_info = color_results_k$color_info)

plot_repainted_mask(
  image = color_results_c$image,
  final_mask = color_results_c$final_mask,
  color_info = color_results_c$color_info)

### Example 2
img_path <- example_data$image_paths[1]
labels <- c("a flower.", "a bee.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, TRUE, TRUE)
plot_repainted_mask(color_results$image, color_results$final_mask, color_results$color_info)

### Example 3
img_path <- example_data$image_paths[3]
labels <- c("a flower.", "a bee.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, TRUE)

### Example 4
img_path <- example_data$image_paths[4]
labels <- c("a fish.", "the fins of a fish.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    c("a fish.", "the fins of a fish."),
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}

seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0,
  exclude_boxes = 2,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels,
  # exclude_labels = labels[2],
  # exclude_boxes = 2,
  score_threshold = 0,
  n_colors = 5
)

plot_color_info(color_results, FALSE, TRUE)
plot(as.cimg(seg_results$image), axes = FALSE)

plot_repainted_mask(
  image = color_results$image,
  final_mask = color_results$final_mask,
  color_info = color_results$color_info)

### Example 5
img_path <- example_data$image_paths[5]
labels <- c("a gecko.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, TRUE)

### Example 6
img_path <- example_data$image_paths[6]
labels <- c("a bird.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, FALSE, TRUE)

### Example 7
img_path <- example_data$image_paths[7]
labels <- c("a frog.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, FALSE, TRUE)

### Example 8
img_path <- example_data$image_paths[8]
labels <- c("a mammal.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, TRUE)

### Example 9
img_path <- example_data$image_paths[9]
labels <- c("doe. a deer. a female deer.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, TRUE)

### Example 10
img_path <- example_data$image_paths[10]
labels <- c("a camera.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/SegColR/inst/extdata/json/",
    output_plot = "/home/jboyko/SegColR/inst/extdata/plot/")
  json_path = ground_results$json_path
}


seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.5,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)

color_results <- process_masks_and_extract_colors(
  image = seg_results$image,
  masks = seg_results$mask,
  scores = seg_results$score,
  labels = seg_results$label,
  include_labels = labels[1],
  exclude_labels = labels[2],
  score_threshold = 0.5,
  n_colors = 5
)

plot_color_info(color_results, TRUE)


### Example XX - basic description
img_path <- "/home/jboyko/Downloads/Screenshot 2024-07-28 at 5.41.35 AM.png"
labels <- c("a bee.", "a ruler.")
file_name <- basename(img_path)
file_name <- sub("\\.[^.]*$", "", file_name)
directory <- dirname(img_path)
json_path <- paste0(gsub("images", "json/", directory), "segcolr_output_", file_name, ".json")

if(!file.exists(json_path)){
  ground_results <- grounded_segmentation_cli(img_path,
    labels,
    output_json = "/home/jboyko/BioSegment/extdata/json/",
    output_plot = "/home/jboyko/BioSegment/extdata/plot/")
  json_path = ground_results$json_path
}

seg_results <- load_segmentation_results(
  image_path = img_path,
  json_path = json_path
)

plot_seg_results(
  seg_results = seg_results,
  mask_colors = "Set1",
  background = "grayscale",
  show_label = TRUE,
  show_score = TRUE,
  show_bbox = TRUE,
  score_threshold = 0.1,
  label_size = 1.2,
  bbox_thickness = 2,
  mask_alpha = 0.3
)
