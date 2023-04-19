# run this script
# dx download "/GeneticAnalysis/Chr1/scripts/annotate_pcsk9.sh"
# ./annotate_pcsk9.sh

# Install tools
sudo apt install -f default-jre 
sudo apt install -f plink1.9
sudo apt install -f bcftools
wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
unzip snpEff_latest_core.zip

# Download original BED files
dx download "/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - interim 450k release/ukb23149_c1_b0_v1.bed"
dx download "/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - interim 450k release/ukb23149_c1_b0_v1.bim"
dx download "/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - interim 450k release/ukb23149_c1_b0_v1.fam"

# Multiple actions in one command
# 1 Filter around gene location to speed-up annotation process (between 11000000 and 11200000); 
# 2 Remove withdrawn participants (manually checked -1 to -46) 
# 3 generate a VCF file
echo -e "1\t55000000\t55100000\trangePCSK9" > GENELOC_INTERVAL_GRCH38.txt
for i in {1..46}; do echo -e "-$i -$i" >> removeFAM.txt;  done;
plink1.9 --bfile ukb23149_c1_b0_v1  --extract range GENELOC_INTERVAL_GRCH38.txt  --remove-fam removeFAM.txt --recode vcf --out chr1

# Annotate variant using snpEff ==> http://pcingola.github.io/SnpEff/se_introduction/
java -Xmx12g -jar ~/snpEff/snpEff.jar hg38 chr1.vcf -v -noStats > chr1.snpEff.vcf

# Filter only PCSK9 variants/transcripts
java -Xmx12g -jar ~/snpEff/SnpSift.jar filter "(  ANN[*].GENE has 'PCSK9' )" chr1.snpEff.vcf >  chr1.pcsk9.snpEff.vcf

# Annotate Minor Alleles Frequencies (MAF)
bcftools +fill-tags chr1.pcsk9.snpEff.vcf -- -t AF > chr1.pcsk9.snpEff.allinfo.vcf
bcftools +fill-tags chr1.pcsk9.snpEff.allinfo.vcf >  chr1.pcsk9.snpEff.maf.vcf

# Download database Annotation (dbNSFP) and annotate ==> https://sites.google.com/site/jpopgen/dbNSFP
dx download "/GeneticAnalysis/databases/dbNSFP4.3a_variant.chr1.gz"
java -Xmx12g -jar ~/snpEff/SnpSift.jar dbnsfp  -v -db dbNSFP4.3a_variant.chr1.gz -f rs_dbSNP,clinvar_id,clinvar_review,clinvar_trait,clinvar_clnsig,clinvar_hgvs,gnomAD_genomes_POPMAX_AF,REVEL_score chr1.pcsk9.snpEff.maf.vcf > chr1.pcsk9.snpEff.maf.dbNSFP.vcf

# Upload final VCF to Project
dx upload chr1.pcsk9.snpEff.maf.dbNSFP.vcf --path "/GeneticAnalysis/Chr1/"

## test
java -jar ~/snpEff/SnpSift.jar extractFields   -s "," -e "." chr1.pcsk9.snpEff.maf.dbNSFP.vcf CHROM POS REF ALT "ANN[*].GENE" "ANN[0].EFFECT" "ANN[*].RANK" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "dbNSFP_REVEL_score[*]" dbNSFP_rs_dbSNP dbNSFP_clinvar_id dbNSFP_clinvar_review dbNSFP_clinvar_trait dbNSFP_clinvar_clnsig dbNSFP_clinvar_hgvs dbNSFP_gnomAD_genomes_POPMAX_AF  > chr1.pcsk9.snpEff.txt
dx upload chr1.pcsk9.snpEff.txt --path "/GeneticAnalysis/Chr1/"