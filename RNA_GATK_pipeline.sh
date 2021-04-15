sample=$1

java -jar ~/Bioinformatics/Tools/Tool/picard/build/libs/picard.jar AddOrReplaceReadGroups \
TMP_DIR=TEMP_PICARD VALIDATION_STRINGENCY=LENIENT SORT_ORDER=coordinate \
I=04.Align/GR-${sample}/GR-${sample}_Aligned.out.sam \
O=04.Align/GR-${sample}/GR-${sample}_sorted.bam \
RGID=GR-${sample} RGLB=Truseq RGPL=Illumina RGPU=unit1 RGSM=GR-${sample} CREATE_INDEX=true


java -jar ~/Bioinformatics/Tools/Tool/picard/build/libs/picard.jar MarkDuplicates \
TMP_DIR=TEMP_PICARD VALIDATION_STRINGENCY=LENIENT \
I=04.Align/GR-${sample}/GR-${sample}_sorted.bam \
O=04.Align/GR-${sample}/GR-${sample}_marked_duplicates.sam \
M=04.Align/GR-${sample}/GR-${sample}.duplicate_metrics \
REMOVE_DUPLICATES=true AS=true

java -jar ~/Bioinformatics/Tools/Tool/picard/build/libs/picard.jar SortSam \
TMP_DIR=TEMP_PICARD VALIDATION_STRINGENCY=LENIENT \
SORT_ORDER=coordinate \
I=04.Align/GR-${sample}/GR-${sample}_marked_duplicates.sam \
O=04.Align/GR-${sample}/GR-${sample}_marked_duplicates.bam \
CREATE_INDEX=true

java -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar IndexFeatureFile -I references_hg38_v0_Homo_sapiens_assembly38.dbsnp138.vcf

java -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar IndexFeatureFile -I references_hg38_v0_Homo_sapiens_assembly38.known_indels.vcf

java -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar SplitNCigarReads -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -I 04.Align/GR-${sample}/GR-${sample}_marked_duplicates.bam -O 04.Align/GR-${sample}/GR-${sample}_marked_duplicates_out.bam

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar BaseRecalibrator -I 04.Align/GR-${sample}/GR-${sample}_marked_duplicates_out.bam -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta --known-sites /home/pickyu2/Bioinformatics/Reference/dbSNP/references_hg38_v0_Homo_sapiens_assembly38.dbsnp138.vcf --known-sites /home/pickyu2/Bioinformatics/Reference/Indel/references_hg38_v0_Homo_sapiens_assembly38.known_indels.vcf -O 04.Align/GR-${sample}/GR-${sample}_recal_pass1.table

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar ApplyBQSR -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -I 04.Align/GR-${sample}/GR-${sample}_marked_duplicates_out.bam --bqsr-recal-file 04.Align/GR-${sample}/GR-${sample}_recal_pass1.table -O 04.Align/GR-${sample}/GR-${sample}_recal_pass1.bam 

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar BaseRecalibrator	-I 04.Align/GR-${sample}/GR-${sample}_recal_pass1.bam -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta	--known-sites /home/pickyu2/Bioinformatics/Reference/dbSNP/references_hg38_v0_Homo_sapiens_assembly38.dbsnp138.vcf --known-sites /home/pickyu2/Bioinformatics/Reference/Indel/references_hg38_v0_Homo_sapiens_assembly38.known_indels.vcf -O 04.Align/GR-${sample}/GR-${sample}_recal_pass2.table

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar ApplyBQSR -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -I 04.Align/GR-${sample}/GR-${sample}_recal_pass1.bam --bqsr 04.Align/GR-${sample}/GR-${sample}_recal_pass2.table -O 04.Align/GR-${sample}/GR-${sample}_recal_pass2.bam

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar HaplotypeCaller -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -I 04.Align/GR-${sample}/GR-${sample}_recal_pass2.bam -O 04.Align/GR-${sample}/GR-${sample}.rawVariants.g.vcf -ERC GVCF --standard-min-confidence-threshold-for-calling 20

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar GenotypeGVCFs -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -V 04.Align/GR-${sample}/GR-${sample}.rawVariants.g.vcf -O 04.Align/GR-${sample}/GR-${sample}_genotype.vcf

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar SelectVariants -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -V 04.Align/GR-${sample}/GR-${sample}_genotype.vcf --select-type-to-include SNP -O 04.Align/GR-${sample}/GR-${sample}.rawSNPs.vcf

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar SelectVariants -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -V 04.Align/GR-${sample}/GR-${sample}_genotype.vcf --select-type-to-include INDEL -O 04.Align/GR-${sample}/GR-${sample}.rawINDELs.vcf


java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar  VariantFiltration -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -V 04.Align/GR-${sample}/GR-${sample}.rawSNPs.vcf -O 04.Align/GR-${sample}/GR-${sample}.rawSNPs.filtered.vcf  --filter-name "." --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || HaplotypeScore > 13.0 || MappingQualityRankSum < -12.5 || ReadPosRankSum < -8.0"

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar VariantFiltration -R /home/pickyu2/Bioinformatics/Reference/Fasta/Homo_sapiens_assembly38.fasta -V 04.Align/GR-${sample}/GR-${sample}.rawINDELs.vcf -O 04.Align/GR-${sample}/GR-${sample}.rawINDELs.filtered.vcf --filter-name "." --filter-expression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0"

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar SortVcf -I 04.Align/GR-${sample}/GR-${sample}.rawSNPs.filtered.vcf -I 04.Align/GR-${sample}/GR-${sample}.rawINDELs.filtered.vcf -O 04.Align/GR-${sample}/GR-${sample}.Filtered_gatk.variant.vcf

#java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/gatk/build/libs/gatk-package-4.2.0.0-2-g02b2f55-SNAPSHOT-local.jar MergeVcfs -I 04.Align/GR-${sample}/GR-${sample}.rawSNPs.filtered.vcf -I 04.Align/GR-${sample}/GR-${sample}.rawINDELs.filtered.vcf -O 04.Align/GR-${sample}/GR-${sample}.Filtered_gatk.variant.vcf

java -Xmx1024g -jar ~/Bioinformatics/Tools/Tool/picard/build/libs/picard.jar MergeVcfs I=04.Align/GR-${sample}/GR-${sample}.rawSNPs.filtered.vcf I=04.Align/GR-${sample}/GR-${sample}.rawINDELS.vcf O=04.Align/GR-${sample}/GR-${sample}.cohort.Filtered.variant2.vcf 
