#!/bin/bash
# run this script
dx download "/GeneticAnalysis/Chr1/scripts/classify_pcsk9.sh"
# ./classify_pcsk9.sh
apt-get update
apt-get install -y default-jre 
apt-get install -y plink1.9 
wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
unzip snpEff_latest_core.zip
dx download  /GeneticAnalysis/Chr1/chr1.pcsk9.snpEff.maf.dbNSFP.vcf
export clinvarTrait="(dbNSFP_clinvar_trait=~'Familial_hypercholesterolemia')"
export clinvarReview="(dbNSFP_clinvar_review has 'criteria_provided' | dbNSFP_clinvar_review has 'reviewed_by_expert_panel')"
export clinvarPatho="(dbNSFP_clinvar_clnsig has 'Pathogenic'  | dbNSFP_clinvar_clnsig has 'Pathogenic/Likely_pathogenic' | dbNSFP_clinvar_clnsig has 'Likely_pathogenic')"
export clinvarBenign="(dbNSFP_clinvar_clnsig has 'Benign'  | dbNSFP_clinvar_clnsig has 'Benign/Likely_benign' | dbNSFP_clinvar_clnsig has 'Likely_benign')"
export clinvarVUS="(dbNSFP_clinvar_clnsig has 'Uncertain_significance')"
#CLINVAR
# Patho
java -jar ./snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarPatho}"  chr1.pcsk9.snpEff.maf.dbNSFP.vcf > clinvar.pathogenic.vcf;
# Benign
java -jar ./snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarBenign}"   chr1.pcsk9.snpEff.maf.dbNSFP.vcf > clinvar.benign.vcf;
# VUS
java -jar ./snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarVUS}"  chr1.pcsk9.snpEff.maf.dbNSFP.vcf > clinvar.vus.vcf;
# Remainer
java -jar ./snpEff/SnpSift.jar filter --inverse "${clinvarBenign}"  chr1.pcsk9.snpEff.maf.dbNSFP.vcf  > remainer1.clinvar.vcf;
java -jar ./snpEff/SnpSift.jar filter --inverse "${clinvarPatho}"   remainer1.clinvar.vcf > remainer2.clinvar.vcf;
java -jar ./snpEff/SnpSift.jar filter --inverse "${clinvarVUS}"     remainer2.clinvar.vcf > clinvar.remainer.vcf;
## Generate tables and bed files
for file in "clinvar.pathogenic" "clinvar.benign" "clinvar.vus" "clinvar.remainer"
do
	java -jar ./snpEff/SnpSift.jar extractFields   -s "," -e "." $file.vcf CHROM POS REF ALT "ANN[*].GENE" "ANN[0].EFFECT" "ANN[*].RANK" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "dbNSFP_REVEL_score[*]" dbNSFP_rs_dbSNP dbNSFP_clinvar_id dbNSFP_clinvar_review dbNSFP_clinvar_trait dbNSFP_clinvar_clnsig dbNSFP_clinvar_hgvs dbNSFP_gnomAD_genomes_POPMAX_AF > $file.txt
	plink1.9 --vcf $file.vcf --make-bed  --out "$file.participants";
done
mkdir -p output/txt
mkdir -p output/vcf
mkdir -p output/bed
mv *.bed *.bim *.log *.fam *.nosex output_corrected/bed
mv *.vcf output_corrected/vcf
mv *.txt output_corrected/txt
