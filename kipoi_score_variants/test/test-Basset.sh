dx run kipoi_score_variants -i fasta_file=/references/ucsc_hg19_upper.fa.gz \
                            -i vcf_file=/clinvar_20180429_noMT.filtered.vcf.gz \
			    -i model=Basset \
			    -i output_prefix=Basset_clinvar_20180429_noMT_GPU_test2 \
			    -i batch_size=512 \
			    -i num_workers=8 \
			    --instance-type mem3_ssd1_gpu_x8 \
			    --wait \
                            --destination test_out --allow-ssh --brief -y 

