#!bin/bash
sample=$1
	perl /datapool/bioinfo/chenchen/032416YFV/RNAseq/select_fastq.pl 2 ./${sample}/${sample}_1.fq 30 > ${sample}/trim10.1.fq
	perl /datapool/bioinfo/chenchen/032416YFV/RNAseq/select_fastq.pl 2 ./${sample}/${sample}_2.fq 29 > ${sample}/trim10.2.fq
	/datapool/bioinfo/chenchen/bin/sickle-master/sickle pe -f ${sample}/trim10.1.fq -r ${sample}/trim10.2.fq -o ${sample}/sickle.1.highq.fastq -p ${sample}/sickle.2.highq.fastq -s ${sample}/sickle.single.highq.fastq -t sanger -q 20 -l 104 > ${sample}/stat.lis
	/datapool/bioinfo/chenchen/bin/SPAdes-3.7.1-Linux/bin/spades.py --only-error-correction --disable-gzip-output -o ${sample}/out --pe1-1 ${sample}/sickle.1.highq.fastq --pe1-2 ${sample}/sickle.2.highq.fastq --pe1-s ${sample}/sickle.single.highq.fastq -t 4 -m 4 >> ${sample}/spade.log 
	cat ${sample}/out/corrected/*.fastq > ${sample}/correct.fastq
	perl /datapool/stu/chenzhen/project/tool/Fq2fa_new.pl ./${sample}/correct.fastq  ${sample} ./${sample}/${sample}.fa
	pick_open_reference_otus.py -i ./${sample}/${sample}.fa -f -o ./${sample}/otu_${sample}
	biom convert -i ./${sample}/otu_${sample}/otu_table_mc2_w_tax_no_pynast_failures.biom -o ./${sample}/otu_${sample}/otu_table_mc2_w_tax_no_pynast_failures.txt --table-type "Taxon table" --to-tsv --header-key taxonomy
	alpha_diversity.py -i ./${sample}/otu_${sample}/otu_table_mc2.biom -m simpson,shannon,PD_whole_tree,chao1,observed_species,goods_coverage -o ./${sample}/otu_${sample}/adiv  -t ./${sample}/otu_${sample}/rep_set.tre
