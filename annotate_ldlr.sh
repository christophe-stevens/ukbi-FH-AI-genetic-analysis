# run this script
# dx download "/GeneticAnalysis/Chr19/scripts/annotate_ldlr.sh"
# ./annotate_ldlr.sh

# Install tools
sudo apt install -f default-jre 
sudo apt install -f plink1.9
sudo apt install -f bcftools
wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
unzip snpEff_latest_core.zip

# Download original BED files
dx download "/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - interim 450k release/ukb23149_c19_b0_v1.bed"
dx download "/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - interim 450k release/ukb23149_c19_b0_v1.bim"
dx download "/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - interim 450k release/ukb23149_c19_b0_v1.fam"

# Multiple actions in one command
# 1 Filter around gene location to speed-up annotation process (between 11000000 and 11200000); 
# 2 Remove withdrawn participants (manually checked -1 to -46) 
# 3 generate a VCF file
echo -e "19\t11000000\t11200000\trangeLDLR" > GENELOC_INTERVAL_GRCH38.txt
for i in {1..46}; do echo -e "-$i -$i" >> removeFAM.txt;  done;
plink1.9 --bfile ukb23149_c19_b0_v1  --extract range GENELOC_INTERVAL_GRCH38.txt  --remove-fam removeFAM.txt --recode vcf --out chr19

# Annotate variant using snpEff ==> http://pcingola.github.io/SnpEff/se_introduction/
java -Xmx12g -jar ~/snpEff/snpEff.jar hg38 chr19.vcf -v -noStats > chr19.snpEff.vcf

# Filter only LDLR variants/transcripts
java -Xmx12g -jar ~/snpEff/SnpSift.jar filter "(  ANN[*].GENE has 'LDLR' )" chr19.snpEff.vcf >  chr19.ldlr.snpEff.vcf

# Annotate Minor Alleles Frequencies (MAF)
bcftools +fill-tags chr19.ldlr.snpEff.vcf -- -t AF > chr19.ldlr.snpEff.allinfo.vcf
bcftools +fill-tags chr19.ldlr.snpEff.allinfo.vcf >  chr19.ldlr.snpEff.maf.vcf

# Download database Annotation (dbNSFP) and annotate ==> https://sites.google.com/site/jpopgen/dbNSFP
dx download "/GeneticAnalysis/databases/dbNSFP4.3a_variant.chr19.gz"
java -Xmx12g -jar ~/snpEff/SnpSift.jar dbnsfp  -v -db dbNSFP4.3a_variant.chr19.gz -f rs_dbSNP,clinvar_id,clinvar_review,clinvar_trait,clinvar_clnsig,clinvar_hgvs,gnomAD_genomes_POPMAX_AF,REVEL_score chr19.ldlr.snpEff.maf.vcf > chr19.ldlr.snpEff.maf.dbNSFP.vcf

# Upload final VCF to Project
dx upload chr19.ldlr.snpEff.maf.dbNSFP.vcf --path "/GeneticAnalysis/Chr19/"

## test
java -jar ~/snpEff/SnpSift.jar extractFields   -s "," -e "." chr19.ldlr.snpEff.maf.dbNSFP.vcf CHROM POS REF ALT "ANN[*].GENE" "ANN[0].EFFECT" "ANN[*].RANK" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "dbNSFP_REVEL_score[*]" dbNSFP_rs_dbSNP dbNSFP_clinvar_id dbNSFP_clinvar_review dbNSFP_clinvar_trait dbNSFP_clinvar_clnsig dbNSFP_clinvar_hgvs dbNSFP_gnomAD_genomes_POPMAX_AF  > chr19.ldlr.snpEff.txt
dx upload chr19.ldlr.snpEff.txt --path "/GeneticAnalysis/Chr19/"