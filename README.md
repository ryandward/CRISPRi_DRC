**IMPORTANT**: If your data is not adjusted (e.g., if LFC values are not correctly normalized or baseline-corrected), the script may fail or produce meaningless results. The modeling here is highly sensitive to subtle changes in fitness. Because this pipeline analyzes data globally rather than focusing on single outliers, using properly normalized data is critical for reliable outcomes.

# CRISPRi_DRC Workflow

This repository provides a workflow for conducting dose-response curve (DRC) analyses on CRISPR interference (CRISPRi) data. Below is a detailed walkthrough of how to set up and execute the pipeline, along with explanations of the most critical functions and files.

---

## Overview of Workflows

1. **Data Loading**  
   - The script "multiple_fit_testing.R" reads several data tables, such as "guide_key.tsv" and "tags_to_genes.tsv."  
   - It merges these data to generate a combined dataset ready for model fitting.

2. **Maximum Dose Estimation**  
   - The script computes the highest supplied dosage (max_y_pred) from "guide_key.tsv" columns, used to constrain upper limits in model fitting.  

3. **Model Fitting**  
   - The code identifies “mismatch” versus “perfect” guides for genes of interest and conditions of interest.  
   - It compares two Brain-Cousens (BC.5) models (with or without hormesis, plus sign constraints) to find the best fit per gene-condition pair.

4. **Storing and Loading Results**  
   - Once fitting is complete, results are saved to various *.tsv.gz files for easy retrieval without rerunning lengthy model fits.  
   - On subsequent runs, the script first checks if these results exist (via the "check_files_exist" function). If so, it loads them; otherwise, it refits the models.

5. **Comparing Full and Reduced Models**  
   - A separate function "compare_models" uses likelihood ratio tests on stored fits, determining whether a hormetic (full) model is statistically favored over a reduced model.

6. **Creating Final Outputs**  
   - Once both full and reduced models have been fit, the script calls "check_and_load_model_comparisons" to secure or create a final comparisons table.  
   - It then constructs data frames for intermediate phenotypes and merges them with critical results to produce meaningful final summaries.

---

## Packages Overview

The code uses pacman to manage loading multiple R packages succinctly. Key packages include:
• dplyr and tidyr for data manipulation.  
• drc for dose-response curve fitting.  
• data.table for efficient reading and writing of data.  
• purrr for mapping functions over lists.  
• broom for tidying model outputs.  

This repository uses a more memory-efficient fork of the “drc” package, hosted at “ryandward/drc,” because the default drc library typically is not optimized for fitting tens of thousands of models simultaneously.

Several utility packages such as progress, conflicted, and others help in controlling function conflicts and monitoring progress.

---

## File Descriptions

1. **packages.R**  
   - Installs and loads the required R packages.  
   - Defines any conflict resolution for package functions with overlapping names.

2. **drc_logistic_functions.R**  
   - Implements specialized logistic (Brain-Cousens) model definitions and constraints.  
   - Provides helper functions to extract predictions, summarize vulnerabilities, compute performance metrics, and compare models via LRT.

3. **multiple_fit_testing.R**  
   - Serves as the main script orchestrating data loading, model fitting, result storing, and final comparisons.  
   - Uses straightforward checks to decide whether to read previous model results or re-fit from scratch.  
   - Produces p-value-based filtering outputs and final results that can then be written to disk.

4. **guide_key.tsv and tags_to_genes.tsv**  
   - Example data used to create “genes_of_interest” and “edges” for analysis.  
   - Not part of the committed code, but expected to be in the same directory.

5. **edgeR_results.tsv**  
   - Contains preliminarily processed expression data on which the models are built.

---

## Running the Workflow

1. **Clone or Download This Repository**  
   - Ensure that the folder structure remains consistent.

2. **Install/Load Dependencies**  
   - Launch R in the project directory.  
   - Run `source("packages.R")` to install and load all packages.

3. **Execute the Main Script**  
   - Run `source("multiple_fit_testing.R")`.  
   - If previously fitted model files exist, they will be loaded automatically; else new models will be fit.  
   - The script checks each major step and halts with an error if something fails, ensuring robust error handling.

4. **Inspect Outputs**  
   - Check the "Results" directory (or your designated output folder) for generated .tsv or .RDS files.  
   - Look at “model_comparisons.tsv” and “model_comparisons_hormesis.tsv” for evidence of hormesis significance.

---

## Key Outputs

• model_comparisons.tsv – Compares the likelihood (logLik) of full vs. reduced models for each gene-condition pair.  
• model_comparisons_hormesis.tsv – Includes additional details for hormesis-related parameters.  
• hormetic_vulnerability_summary_*.tsv.gz – Summaries of gene vulnerabilities based on Brain-Cousens fits.  
• hormetic_fit_points_*.tsv.gz – Points used in model plotting, matching each gene-condition to predicted curves.  
• hormetic_parameters_*.tsv.gz – Model parameters (e.g., kd_50, shape, hormesis) for deeper analysis.  

These files are compressed (zipped) TSV outputs. They can be found in the "Results" folder and are stored alongside in-memory objects to save time when re-running extensive model fits.

---

## Key Highlights

- **Likely Errors**: If your input files are missing, or if certain packages aren’t installed, the script will stop.  
- **Hyperparameters**: The constraints for the Brain-Cousens logistic model are managed in “drc_logistic_functions.R.” Adjust them if your data needs unusual parameter bounds.  
- **Parallelization**: The current code uses straightforward “dplyr” and “purrr::map” loops. For large-scale sets, consider parallelizing or distributing computations.  

---

## Support and Contributions

- For questions or issues, please open a GitHub issue or contact the author(s) listed in the code.
- Pull requests improving the pipeline or documentation (without duplicating existing code) are welcome.

## Additional Notes

This code is provided as committed template code, allowing you to plug in your own data for dose-response curve analyses. While “edgeR_results.tsv” is supplied as an example, you are expected to replace it (and other references) with your own data sources as needed.

In the pipeline, “LFC.adj” is used as the key fitness measurement because it accounts for the baseline differences observed when working with non-targeting guides. Always ensure your data contains a comparable column with adjusted log-fold changes for accurate model fitting.

Because the fitting process can be time-consuming, this repository stores partial or full model results on disk and keeps them in memory once loaded. The helper scripts first check if any existing results match the current data and parameter setup to avoid refitting. If stored results are found, they are loaded directly from memory or disk, skipping repetitive computations.

**REMINDER**: It is safe to completely remove the "Results/" folder at any time, especially before re-running the pipeline. If you are using new data (e.g., a different edgeR_results.tsv), you must delete previously generated model files and relaunch R (or clear your environment) because they can be memory-intensive.

