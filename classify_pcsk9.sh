# run this script
# dx download "/GeneticAnalysis/Chr19/scripts/classify_pcsk9.sh"
# ./classify_pcsk9.sh

sudo apt install -y default-jre 
sudo apt install -y plink1.9 
wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
unzip snpEff_latest_core.zip
dx download  /GeneticAnalysis/Chr1/chr1.pcsk9.snpEff.maf.dbNSFP.vcf

		
export clinvarTrait="(dbNSFP_clinvar_trait=~'Familial_hypercholesterolemia')"
export clinvarReview="(dbNSFP_clinvar_review has 'criteria_provided' | dbNSFP_clinvar_review has 'reviewed_by_expert_panel')"
export clinvarPatho="(dbNSFP_clinvar_clnsig has 'Pathogenic'  | dbNSFP_clinvar_clnsig has 'Pathogenic/Likely_pathogenic' | dbNSFP_clinvar_clnsig has 'Likely_pathogenic')"
export clinvarBenign="(dbNSFP_clinvar_clnsig has 'Benign'  | dbNSFP_clinvar_clnsig has 'Benign/Likely_benign' | dbNSFP_clinvar_clnsig has 'Likely_benign')"

				  
#CLINVAR
# Patho
java -jar ~/snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarPatho}"  chr1.pcsk9.snpEff.maf.dbNSFP.vcf > clinvar.pathogenic.vcf;
java -jar ~/snpEff/SnpSift.jar filter "${missenseOnly}"  clinvar.pathogenic.vcf > clinvar.missense.pathogenic.vcf;
java -jar ~/snpEff/SnpSift.jar filter "! ${missenseOnly}" clinvar.pathogenic.vcf > clinvar.nonmissense.pathogenic.vcf;

# Benign					
java -jar ~/snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarBenign}"   chr1.pcsk9.snpEff.maf.dbNSFP.vcf > clinvar.benign.vcf;
java -jar ~/snpEff/SnpSift.jar filter "${missenseOnly}"  clinvar.benign.vcf > clinvar.missense.benign.vcf;
java -jar ~/snpEff/SnpSift.jar filter "! ${missenseOnly}"  clinvar.benign.vcf > clinvar.nonmissense.benign.vcf;

# VUS
java -jar ~/snpEff/SnpSift.jar filter "${clinvarTrait}"  chr1.pcsk9.snpEff.maf.dbNSFP.vcf > remainer0.clinvar.vus.vcf;
java -jar ~/snpEff/SnpSift.jar filter --inverse "${clinvarPatho}"  remainer0.clinvar.vus.vcf > remainer1.clinvar.vus.vcf;
java -jar ~/snpEff/SnpSift.jar filter --inverse "${clinvarBenign}"  remainer1.clinvar.vus.vcf > clinvar.VUS.vcf;
						


## Generate tables and bed files
for file in "clinvar.pathogenic" "clinvar.benign" "clinvar.VUS"
do
	java -jar ~/snpEff/SnpSift.jar extractFields   -s "," -e "." $file.vcf CHROM POS REF ALT "ANN[*].GENE" "ANN[0].EFFECT" "ANN[*].RANK" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "dbNSFP_REVEL_score[*]" dbNSFP_rs_dbSNP dbNSFP_clinvar_id dbNSFP_clinvar_review dbNSFP_clinvar_trait dbNSFP_clinvar_clnsig dbNSFP_clinvar_hgvs dbNSFP_gnomAD_genomes_POPMAX_AF > $file.txt
	plink1.9 --vcf $file.vcf --make-bed  --out "$file.participants";
done


mkdir -p output/txt
mkdir -p output/vcf
mkdir -p output/bed

mv *.bed *.bim *.log *.fam *.nosex output/bed
mv *.vcf output/vcf
mv *.txt output/txt

dx upload -r output --path "/GeneticAnalysis/Chr1/"
