#!/bin/bash
# echo $@
source /dx-toolkit/dx-toolkit/environment; 
dx login --token $1 --noprojects; 
dx select kipoi_model_zoo; 
cd /dx-toolkit/kipoi_model_zoo_dx/kipoi_score_variants/test; 
cat test-$2.sh | sed -e "s/--allow-ssh//" | bash
