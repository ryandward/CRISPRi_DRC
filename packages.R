# Load required packages
require("pacman")
require(conflicted)
require(progress)

# Load packages from GitHub
p_load_current_gh("DoseResponse/drcData", "ryandward/drc")

# Load packages using pacman
p_load(
  broom,
  colourpicker,
  data.table,
  dplyr,
  drc,
  edgeR,
  ggplot2,
  ggrepel,
  gtools,
  Hmisc,
  lmtest,
  magrittr,
  modelr,
  poolr,
  purrr,
  R.utils,
  RColorBrewer,
  Rtsne,
  scales,
  statmod,
  svglite,
  tidyr,
  tidyverse,
  vegan
)

# Resolve conflicts using the conflicted package
conflicted::conflicts_prefer(
  gtools::permute,
  dplyr::filter,
  dplyr::select,
  drc::gaussian,
  tidyr::extract
)

# # Update file_names lists with the new DRC objects entry
# # File names for full model parameters, i.e. hormesis/Brain-Cousens model
# message("Updating file_names lists...\n")
# file_names_full <- list(
#   vuln_summary = "hormetic_vulnerability_summary_full.tsv.gz",
#   fit_predictions = "hormetic_fit_predictions_full.tsv.gz",
#   fit_points = "hormetic_fit_points_full.tsv.gz",
#   model_performance = "hormetic_performance_full.tsv.gz",
#   model_parameters = "hormetic_parameters_full.tsv.gz",
#   drc_fits = "drc_fits_full.RDS"
# )

# # File names for reduced model parameters, i.e. No hormesis model
# file_names_reduced <- list(
#   vuln_summary = "hormetic_vulnerability_summary_reduced.tsv.gz",
#   fit_predictions = "hormetic_fit_predictions_reduced.tsv.gz",
#   fit_points = "hormetic_fit_points_reduced.tsv.gz",
#   model_performance = "hormetic_performance_reduced.tsv.gz",
#   model_parameters = "hormetic_parameters_reduced.tsv.gz",
#   drc_fits = "drc_fits_reduced.RDS"
# )

# message("File_names lists updated.\n")
