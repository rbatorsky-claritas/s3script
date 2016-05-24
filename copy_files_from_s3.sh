#!/bin/bash

## run this script in the directory where you would like the coverage files to appear

numofargs=$#
if [ $numofargs -eq 1 ]; then
        acc=$1
        if [[ ${#acc} == 14 ]]; then
		echo "Searching for files"
        else
                echo "Input should be full accession number with dashes, e.g. XX-XX-XX-XXXX"
								echo $1
                exit 1
        fi
else
        echo "Input should be full accession number with dashes, e.g. XX-XX-XX-XXXX"
        exit 1
fi

high_cov=$(aws s3 ls --recursive claritas-prod-workspace | grep $acc | grep highCoverageByRefSeqGene.txt$ | awk '{print $4}')
low_cov=$(aws s3 ls --recursive claritas-prod-workspace | grep $acc | grep low_coverage_regions.amplicons.bed$ | awk '{print $4}')
qc=$(aws s3 ls --recursive claritas-prod-workspace | grep $acc| grep VariantQCResult.txt$ | awk '{print $4}')

aws s3 cp "s3://claritas-prod-workspace/$high_cov" "${acc}_highCoverageByRefSeqGene.txt"
aws s3 cp "s3://claritas-prod-workspace/$low_cov" "${acc}_low_coverage_regions.amplicons.bed"
aws s3 cp "s3://claritas-prod-workspace/$qc" "${acc}_VariantQCResult.txt"
