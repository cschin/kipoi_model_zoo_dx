dx run kipoi_score_variants -i gtf_file=/Homo_sapiens.GRCh37.75.filtered.gtf \
                                    -i fasta_file=/references/hs37d5.fa.gz \
                                    -i vcf_file=/clinvar_20180429_noMT.filtered.vcf.gz \
				    -i model=labranchor \
			            -i output_prefix=labranchor_clinvar_20180429_noMT \
				    --wait \
                                    --destination test_out --allow-ssh --brief -y   --debug-on All

