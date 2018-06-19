#!/bin/bash
# echo $@
source /dx-toolkit/dx-toolkit/environment; 
dx login --token ${DX_KIPOI_TEST_TOKEN} --noprojects; 
dx select kipoi_model_zoo; 
cd /dx-toolkit/kipoi_model_zoo_dx/kipoi_score_variants/test; 
cat test-${MODLE}.sh | sed -e "s/--allow-ssh//" | bash
