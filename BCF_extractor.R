# This script assumes that bcftools are installed and that the directory containing a dataset with .PED and .BCF files. 
setwd("/mnt/d/1000genomes/") # path to the directory with a dataset
rm(list = ls())
library(tools)
mainDir <- getwd()
subDir <- "output"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
ped_file <- read.table(list.files(".", pattern = "*.ped"), header=T, sep="\t")
subset <- as.character(ped_file$Individual.ID[ped_file$Gender == "2" & ped_file$Population == "GBR"])
capture.output(cat(subset, sep="\n", fill=FALSE), file="subset.txt")
file.names <- list.files(pattern = "\\.bcf$")
for(i in 1:length(file.names)){
  x <- paste("bcftools view -S subset.txt --force-samples ", file.names[i], " > ./", subDir ,"/output_", file_path_sans_ext(file.names[i]),".vcf", sep="")
  system(x)
} 
# system ("cd ./output/ && for file in *.vcf; do vcftools --vcf ${file%}  --out ${file%.*}.ped --plink; done") # VCF to PED
# system("find . -name '*.vcf' | parallel bgzip && ls | grep -E '\.gz$' | parallel bcftools index {}")
# system("bcftools merge --force-samples *vcf.gz > combined_genotypes.vcf") # doesn't work for so many files
