source vars.config

#fix your pythonpath to include pydagman
export PYTHONPATH=$PYTHONPATH:$pydagman_location

$python2 $pipeline_dir/makeDAG.py

$python2 $pipeline_dir/cds_align.makeDAG.py

$python2 $pipeline_dir/get_genes.makeDAG.py
