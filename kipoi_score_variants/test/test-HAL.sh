dx run kipoi_score_variants -i gtf_file=/Homo_sapiens.GRCh37.75.filtered.gtf \
                                    -i fasta_file=/references/hs37d5.fa.gz \
                                    -i vcf_file=/clinvar_20180429_noMT.filtered.vcf.gz \
				    -i model=HAL \
			            -i output_prefix=HAL_clinvar_20180429_noMT \
				    --wait \
                                    --destination test_out --allow-ssh --brief -y

