# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:percent
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.16.1
#   kernelspec:
#     display_name: scipy
#     language: python
#     name: python3
# ---

# %%
import os
import re
import ast
import pandas as pd
import argparse


# %%
# https://stackoverflow.com/a/71112312/5023162
def ranged_type(value_type, min_value, max_value):
    """
    Return function handle of an argument type function for ArgumentParser checking a range:
        min_value <= arg <= max_value

    Parameters
    ----------
    value_type  - value-type to convert arg to
    min_value   - minimum acceptable argument
    max_value   - maximum acceptable argument

    Returns
    -------
    function handle of an argument type function for ArgumentParser


    Usage
    -----
        ranged_type(float, 0.0, 1.0)

    """

    def range_checker(arg: str):
        try:
            f = value_type(arg)
        except ValueError:
            raise argparse.ArgumentTypeError(f'must be a valid {value_type}')
        if f < min_value or f > max_value:
            raise argparse.ArgumentTypeError(f'must be within [{min_value}, {max_value}]')
        return f

    # Return function handle to checking function
    return range_checker

def parse_arguments():
  """Parse input arguments"""
  
  parser = argparse.ArgumentParser(description="Aggregate the Freyja results output by the nf-core/viralrecon pipeline.")

  parser.add_argument("--viralrecon_results", required=True, help="Path to the directory with the viralrecon results. The script will automatically read the files from their relevant sub-directories.")

  parser.add_argument("--outdir", required=True, help="Output directory name, which will be created if it does not exist. Two files will be saved, named 'lineage_abundances.csv' and 'vocs_abundances.csv'")

  parser.add_argument("--prefix", default="", help="Optional prefix for output file names.")

  parser.add_argument("--metadata", default="", help="Optional metadata file. The first column is assumed to contain the sample names, and will be used to merge with the Freyja results.")
  
  parser.add_argument("--metadata_sep", default=",", help = "Separator character for metadata file. If your file is tab-delimited (TSV) use '\t'. Default is CSV: ','.")
      
  parser.add_argument("--mincov", default="75", type = ranged_type(float, 0.0, 100.0),
                      help="Minimum percentage of the genome covered at 10x read depth. Samples with less than this value will not be included in the output. Default: 75")

  args = parser.parse_args()
  return args


# %%
def parse_demix_coverage(file_path):
  """Get coverage value from demix output file"""
  with open(file_path) as f:
    f = f.read().split("\n")
    
    # coverage stored in last line of the file
    coverage = f[5].split("\t")[1]
    coverage = float(coverage)
    
    return coverage

def parse_demix_lineages(file_path):
  """Get lineage abundances from `freyja demix` output file"""
  with open(file_path) as f:
    f = f.read().split("\n")
    
    # get individual lineage values - these are stored across two lines in the file
    lineage_names = f[2].split("\t")[1].split(" ")
    lineage_abundances = f[3].split("\t")[1].split(" ")
    
    # convert to list of tuples
    lineages = list(zip(lineage_names, lineage_abundances))
    
    # convert to data frame
    lineages_df = pd.DataFrame(lineages, columns=["name", "abundance"])
    
    return lineages_df
    
def parse_demix_summarised(file_path):
  """Get summarised abundances from `freyja demix` output file"""
  with open(file_path) as f:
    f = f.read().split("\n")
    
    # get summarised values - these are stored as a string representing a list of tuples
    summarised = ast.literal_eval(f[1].split("\t")[1])
    # convert to data frame
    summarised = pd.DataFrame(summarised, columns=["name", "abundance"])
    
    return summarised

def parse_bootstrap(file_path):
  """Get bootstrap estimates from `freyja boot` output file"""
  with open(file_path) as f:
    f = f.read().split("\n")
    
    # get lineage names (first line)
    lineage_names = f[0].split(",")[1:]
    
    # get a few of the quantiles for 95% CI
    q1 = f[1].split(",")[1:]  # 2.5%
    q7 = f[7].split(",")[1:]  # 97.5%
    
    # zip them up
    boot = list(zip(lineage_names, q1, q7))
    # convert to data frame
    boot_df = pd.DataFrame(boot, columns=["name", "boot_lo", "boot_hi"])
    
    return boot_df


# %%
def main():

  args = parse_arguments()

  dir_path = args.viralrecon_results
  mincov = args.mincov
  output_directory = args.outdir
  output_prefix = args.prefix
  
  # extract sample IDs from file names
  sample_ids = os.listdir(os.path.join(dir_path, "variants/freyja/demix"))
  sample_ids = [i.replace(".tsv", "") for i in sample_ids]
  
  # lists for output
  lineages_list = []
  summarised_list = []
  
  # loop through
  for sample_id in sample_ids[1:20]:
    # check coverage and skip if below threshold
    coverage = parse_demix_coverage(os.path.join(dir_path, 
                                                 "variants/freyja/demix", 
                                                 f"{sample_id}.tsv"))
    if coverage < mincov:
      print(f"Warning: skipping {sample_id} with coverage {coverage}")
      continue
    
    # get lineages results
    lineages = parse_demix_lineages(os.path.join(dir_path, 
                                                 "variants/freyja/demix", 
                                                 f"{sample_id}.tsv"))
    lineages_boot = parse_bootstrap(os.path.join(dir_path, 
                                                 "variants/freyja/bootstrap", 
                                                 f"{sample_id}_lineages.csv"))
    lineages = pd.merge(lineages, lineages_boot, on="name", how="inner")
    lineages.insert(0, "sample", sample_id)
    lineages_list.append(lineages)
    
    # get summarised results
    summarised = parse_demix_summarised(os.path.join(dir_path, 
                                                     "variants/freyja/demix", 
                                                     f"{sample_id}.tsv"))
    summarised_boot = parse_bootstrap(os.path.join(dir_path, 
                                                   "variants/freyja/bootstrap", 
                                                   f"{sample_id}_summarized.csv"))
    summarised = pd.merge(summarised, summarised_boot, on="name", how="inner")
    summarised.insert(0, "sample", sample_id)
    summarised_list.append(summarised)
  
  # bind results
  lineages_out = pd.concat(lineages_list, ignore_index=True)
  summarised_out = pd.concat(summarised_list, ignore_index=True)
  
  # merge with metadata
  if args.metadata != "":
    meta = pd.read_csv(args.metadata, sep = args.metadata_sep)
    lineages_out = pd.merge(lineages_out, meta, left_on = "sample", right_on = meta.columns[0], how = "left")
    summarised_out = pd.merge(summarised_out, meta, left_on = "sample", right_on = meta.columns[0], how = "left")
  
  #### save outputs ####
  # create output directory
  os.makedirs(output_directory, exist_ok=True)
  
  # if prefix is given add a "_" separator
  if output_prefix != "":
    output_prefix = f"{output_prefix}_"
  
  lineages_out.to_csv(os.path.join(output_directory, output_prefix, "lineage_abundances.csv"), index=False)
  summarised_out.to_csv(os.path.join(output_directory, output_prefix, "vocs_abundances.csv"), index=False)


# %%
if __name__ == "__main__":
  main()
