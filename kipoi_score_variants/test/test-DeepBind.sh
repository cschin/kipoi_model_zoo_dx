dx run kipoi_score_variants -i fasta_file=/references/ucsc_hg19_upper.fa.gz \
                            -i vcf_file=/clinvar_20180429_noMT.filtered.vcf.gz \
			    -i model=DeepBind/D00001.001 \
			    -i output_prefix=deep_bind_clinvar_20180429_noMT \
                            --destination test_out --allow-ssh --brief -y 

