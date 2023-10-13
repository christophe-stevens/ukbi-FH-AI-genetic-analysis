# run this script
# dx download "/GeneticAnalysis/Chr19/scripts/classify_ldlr.sh"
# ./classify_ldlr.sh
# sudo apt install -y default-jre 
# sudo apt install -y plink1.9 
# wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip
# unzip snpEff_latest_core.zip
# dx download  /GeneticAnalysis/Chr19/chr19.ldlr.snpEff.maf.dbNSFP.vcf

export filterPredictedPathoMissense="(((ANN[0].GENE has 'LDLR'  &  ANN[0].EFFECT has 'missense_variant' & ( ANN[0].RANK has '4' |  ANN[0].HGVS_P=~'p.Cys') & dbNSFP_REVEL_score[0]>=0.75) | \
						        (ANN[1].GENE has 'LDLR'  &  ANN[1].EFFECT has 'missense_variant' & ( ANN[1].RANK has '4' |  ANN[1].HGVS_P=~'p.Cys') & dbNSFP_REVEL_score[1]>=0.75) | \
						        (ANN[2].GENE has 'LDLR'  &  ANN[2].EFFECT has 'missense_variant' & ( ANN[2].RANK has '4' |  ANN[2].HGVS_P=~'p.Cys') & dbNSFP_REVEL_score[2]>=0.75) | \
						        (ANN[3].GENE has 'LDLR'  &  ANN[3].EFFECT has 'missense_variant' & ( ANN[3].RANK has '4' |  ANN[3].HGVS_P=~'p.Cys') & dbNSFP_REVEL_score[3]>=0.75) | \
						        (ANN[4].GENE has 'LDLR'  &  ANN[4].EFFECT has 'missense_variant' & ( ANN[4].RANK has '4' |  ANN[4].HGVS_P=~'p.Cys') & dbNSFP_REVEL_score[4]>=0.75) | \
						        (ANN[5].GENE has 'LDLR'  &  ANN[5].EFFECT has 'missense_variant' & ( ANN[5].RANK has '4' |  ANN[5].HGVS_P=~'p.Cys') & dbNSFP_REVEL_score[5]>=0.75)) & \
                               MAF<0.0002)";
export filterPredictedPathoNonMissense="(((ANN[0].GENE has 'LDLR' & (ANN[0].EFFECT has 'stop_gained' | ANN[0].EFFECT has 'frameshift_variant' | ANN[0].EFFECT has 'splice_acceptor_variant' | ANN[0].EFFECT has 'splice_donor_variant' | ANN[0].EFFECT has 'inframe_deletion' | ANN[0].EFFECT has 'disruptive_inframe_deletion' | ANN[0].EFFECT has 'duplication' )) | \
								   (ANN[1].GENE has 'LDLR' & (ANN[1].EFFECT has 'stop_gained' | ANN[1].EFFECT has 'frameshift_variant' | ANN[1].EFFECT has 'splice_acceptor_variant' | ANN[1].EFFECT has 'splice_donor_variant' | ANN[1].EFFECT has 'inframe_deletion' | ANN[1].EFFECT has 'disruptive_inframe_deletion' | ANN[1].EFFECT has 'duplication' )) | \
								   (ANN[2].GENE has 'LDLR' & (ANN[2].EFFECT has 'stop_gained' | ANN[2].EFFECT has 'frameshift_variant' | ANN[2].EFFECT has 'splice_acceptor_variant' | ANN[2].EFFECT has 'splice_donor_variant' | ANN[2].EFFECT has 'inframe_deletion' | ANN[2].EFFECT has 'disruptive_inframe_deletion' | ANN[2].EFFECT has 'duplication' )) | \
								   (ANN[3].GENE has 'LDLR' & (ANN[3].EFFECT has 'stop_gained' | ANN[3].EFFECT has 'frameshift_variant' | ANN[3].EFFECT has 'splice_acceptor_variant' | ANN[3].EFFECT has 'splice_donor_variant' | ANN[3].EFFECT has 'inframe_deletion' | ANN[3].EFFECT has 'disruptive_inframe_deletion' | ANN[3].EFFECT has 'duplication' )) | \
								   (ANN[4].GENE has 'LDLR' & (ANN[4].EFFECT has 'stop_gained' | ANN[4].EFFECT has 'frameshift_variant' | ANN[4].EFFECT has 'splice_acceptor_variant' | ANN[4].EFFECT has 'splice_donor_variant' | ANN[4].EFFECT has 'inframe_deletion' | ANN[4].EFFECT has 'disruptive_inframe_deletion' | ANN[4].EFFECT has 'duplication' )) | \
								   (ANN[5].GENE has 'LDLR' & (ANN[5].EFFECT has 'stop_gained' | ANN[5].EFFECT has 'frameshift_variant' | ANN[5].EFFECT has 'splice_acceptor_variant' | ANN[5].EFFECT has 'splice_donor_variant' | ANN[5].EFFECT has 'inframe_deletion' | ANN[5].EFFECT has 'disruptive_inframe_deletion' | ANN[5].EFFECT has 'duplication' ))) & \
							      MAF<0.0002)";
export filterPredictedBenignMissense="((ANN[0].GENE has 'LDLR' & (ANN[0].EFFECT has 'missense_variant' & (( dbNSFP_REVEL_score[0]<=0.5 & MAF>=0.002) |  MAF>=0.005))) | \
							    (ANN[1].GENE has 'LDLR' & (ANN[1].EFFECT has 'missense_variant' & (( dbNSFP_REVEL_score[1]<=0.5 & MAF>=0.002) |  MAF>=0.005))) | \
							    (ANN[2].GENE has 'LDLR' & (ANN[2].EFFECT has 'missense_variant' & (( dbNSFP_REVEL_score[2]<=0.5 & MAF>=0.002) |  MAF>=0.005))) | \
							    (ANN[3].GENE has 'LDLR' & (ANN[3].EFFECT has 'missense_variant' & (( dbNSFP_REVEL_score[3]<=0.5 & MAF>=0.002) |  MAF>=0.005))) | \
								(ANN[4].GENE has 'LDLR' & (ANN[4].EFFECT has 'missense_variant' & (( dbNSFP_REVEL_score[4]<=0.5 & MAF>=0.002) |  MAF>=0.005))) | \
							    (ANN[5].GENE has 'LDLR' & (ANN[5].EFFECT has 'missense_variant' & (( dbNSFP_REVEL_score[5]<=0.5 & MAF>=0.002) |  MAF>=0.005))))";
export filterPredictedBenignNonMissense="((ANN[0].GENE has 'LDLR' & ANN[0].EFFECT!='missense_variant') & \
								   (ANN[1].GENE has 'LDLR' & ANN[1].EFFECT!='missense_variant') & \
								   (ANN[2].GENE has 'LDLR' & ANN[2].EFFECT!='missense_variant') & \
								   (ANN[3].GENE has 'LDLR' & ANN[3].EFFECT!='missense_variant') & \
								   (ANN[4].GENE has 'LDLR' & ANN[4].EFFECT!='missense_variant') & \
								   (ANN[5].GENE has 'LDLR' & ANN[5].EFFECT!='missense_variant') & \
								    MAF>=0.005)";
export missenseOnly="((ANN[0].GENE has 'LDLR'  &  ANN[0].EFFECT has 'missense_variant') | \
			   (ANN[1].GENE has 'LDLR'  &  ANN[1].EFFECT has 'missense_variant') | \
			   (ANN[2].GENE has 'LDLR'  &  ANN[2].EFFECT has 'missense_variant') | \
			   (ANN[3].GENE has 'LDLR'  &  ANN[3].EFFECT has 'missense_variant') | \
			   (ANN[4].GENE has 'LDLR'  &  ANN[4].EFFECT has 'missense_variant') | \
			   (ANN[5].GENE has 'LDLR'  &  ANN[5].EFFECT has 'missense_variant'))";
		
export clinvarTrait="(dbNSFP_clinvar_trait=~'Familial_hypercholesterolemia')"
export clinvarReview="(dbNSFP_clinvar_review has 'criteria_provided' | dbNSFP_clinvar_review has 'reviewed_by_expert_panel')"
export clinvarPatho="(dbNSFP_clinvar_clnsig has 'Pathogenic'  | dbNSFP_clinvar_clnsig has 'Pathogenic/Likely_pathogenic' | dbNSFP_clinvar_clnsig has 'Likely_pathogenic')"
export clinvarBenign="(dbNSFP_clinvar_clnsig has 'Benign'  | dbNSFP_clinvar_clnsig has 'Benign/Likely_benign' | dbNSFP_clinvar_clnsig has 'Likely_benign')"
export clinvarVUS="(dbNSFP_clinvar_clnsig has 'Uncertain_significance')"

## PRED
# Predicted Pathogenic	
java -jar ./snpEff/SnpSift.jar filter "${filterPredictedPathoMissense} | ${filterPredictedPathoNonMissense}" chr19.ldlr.snpEff.maf.dbNSFP.vcf > predicted.pathogenic.vcf
# Predicted Benign		
java -jar ./snpEff/SnpSift.jar filter " ${filterPredictedBenignMissense} | ${filterPredictedBenignNonMissense}" chr19.ldlr.snpEff.maf.dbNSFP.vcf > predicted.benign.vcf
# Predicted None
java -jar ./snpEff/SnpSift.jar filter --inverse "${filterPredictedPathoMissense} | ${filterPredictedPathoNonMissense}" chr19.ldlr.snpEff.maf.dbNSFP.vcf > remainer1.none.VCF
java -jar ./snpEff/SnpSift.jar filter --inverse "${filterPredictedBenignMissense} | ${filterPredictedBenignNonMissense}" remainer1.none.VCF > predicted.remainer.vcf					  
#CLINVAR
# Patho
java -jar ./snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarPatho}"  chr19.ldlr.snpEff.maf.dbNSFP.vcf > clinvar.pathogenic.vcf;
# Benign					
java -jar ./snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarBenign}"   chr19.ldlr.snpEff.maf.dbNSFP.vcf > clinvar.benign.vcf;
# VUS
java -jar ./snpEff/SnpSift.jar filter "${clinvarTrait} & ${clinvarReview} & ${clinvarVUS}"  chr19.ldlr.snpEff.maf.dbNSFP.vcf > clinvar.vus.vcf;
# Remainer
java -jar ./snpEff/SnpSift.jar filter "${clinvarTrait}"  chr19.ldlr.snpEff.maf.dbNSFP.vcf > remainer0.clinvar.vcf;
java -jar ./snpEff/SnpSift.jar filter --inverse "${clinvarReview} & ${clinvarBenign}"  remainer0.clinvar.vcf > remainer1.clinvar.vcf;
java -jar ./snpEff/SnpSift.jar filter --inverse "${clinvarReview} & ${clinvarPatho}"   remainer1.clinvar.vcf > remainer2.clinvar.vcf;
java -jar ./snpEff/SnpSift.jar filter --inverse "${clinvarReview} & ${clinvarVUS}"     remainer2.clinvar.vcf > clinvar.remainer.vcf;

## Generate tables and bed files
for file in "predicted.pathogenic" "predicted.benign" "predicted.remainer" "clinvar.pathogenic" "clinvar.benign" "clinvar.vus" "clinvar.remainer"
do
	java -jar ./snpEff/SnpSift.jar extractFields   -s "," -e "." $file.vcf CHROM POS REF ALT "ANN[*].GENE" "ANN[0].EFFECT" "ANN[*].RANK" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "dbNSFP_REVEL_score[*]" dbNSFP_rs_dbSNP dbNSFP_clinvar_id dbNSFP_clinvar_review dbNSFP_clinvar_trait dbNSFP_clinvar_clnsig dbNSFP_clinvar_hgvs dbNSFP_gnomAD_genomes_POPMAX_AF > $file.txt
	plink1.9 --vcf $file.vcf --make-bed  --out "$file.participants";
done

## Merge BED for each type
for patho in "pathogenic" "benign" "vus" "remainer" 
do
	echo -e "predicted.${patho}.participants\nclinvar.${patho}.participants" > mergeList.txt
	plink1.9 --merge-list mergeList.txt --make-bed --out $patho
done

mkdir -p output/txt
mkdir -p output/vcf
mkdir -p output/bed

mv *.bed *.bim *.log *.fam *.nosex output/bed
mv *.vcf output/vcf
mv *.txt output/txt

dx upload -r output --path "/GeneticAnalysis/Chr19/"
