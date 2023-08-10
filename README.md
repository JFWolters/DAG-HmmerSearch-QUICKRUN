# DAG-HmmerSearch-QUICKRUN  
Search a target set of proteins using hmmer. QUICKRUN version preconfigured for use on scarcity.  
  
Search a target set of proteins for a given set of queries using HMMER using HTCondor's job submission tools.  
Runs hmmer, extracts protein hits, and then extracts cds hits from provided DNA.  
It also aligns the resulting hits, produces a gene tree, and prepares various files for displaying hit scores on itol.  
   
Note that extracting cds hits assumes the protein id is contained in the cds id.  
If this not true, e.g. for the annotations from Shen et al. 2018, then renaming is required.  
  
## Input  
Takes as input (tab delimited) for each parallel protein/cds dataset:  
1)Arbitrary subject ID  
2)full path to protein sequences  
3)full path to matching CDS sequences  
  
For each query, takes as input (tab delimited):  
1)Arbitrary query ID  
2)Full path to protein sequence alignment  
  
## To Run:  
To run, modify the vars.config, then run   
bash makeDAG.sh  
  
The pipeline is split into three DAG submits: the hmmer search, combining the results, and generating the gene tree and related output.  
  
### Hmmer search  
First, run as:  
  
condor_submit_dag annot_prot_search.dag  
  
Summary of output files for hmmer search:  
Each input generates one folder in isr which labeled for the query ID  
In each of those folders, there will be a folder for each subject ID  
Hmmer output files  
See hmmer docs for full details  
*.hmmer_results.txt    
*.hmmer_results.aligned.txt  
*.table.txt  
Same as above but with extraneous lines removed  
*.table.fixed.tab  
Sequence files  
Protein sequences matching the hmmer hits from the input, before and after score filtering  
*.protein_hits.fasta  
*.protein_hits.filtered.fasta  
Matching cds sequences from the input  
*.CDS.fasta  
*.CDS.filtered.fasta  
Table of scores for each hit  
*.score_table.tab  
Table of CDS hit sizes  
*.CDS.filtered.sequence_sizes.tab  
Table of Protein hit sizes  
*.protein_hits.filtered.species_id.sequence_sizes.tab  
#log files are in the main folder  
prot_search_[job_id].out,.log,.err  
  
### Combine gene results  
Second, to combine the results for each query, run as:  
  
condor_submit_dag get_genes.dag  
  
Summary of output files for each gene, now found in [base_dir]/gene_trees/[query_id]:  
Combined CDS/Prot Hits  
[gene_id].cds.fasta  
[gene_id].prot.fasta  
Combined sizes summaries:  
[gene_id].CDS.sizes.tab  
[gene_id].protein_hits.sizes.tab  
Number of Hits for each subject:  
[gene_id].hit_counts.txt  
Number of hits formatted for itol display:  
[gene_id].gene_count_iTOL.txt  
Table of hmmer scores:  
[gene_id].score_table.tab  
Histogram of hmmer scores:  
[gene_id].score_table.histogram.pdf  
Scores formatted for display as an iTOL heatmap  
[gene_id].scores.iTOL.txt  
log files:  
get_genes__[job_id].err,.log,.out  
  
  
### Prepare gene tree  
Lastly, to make the gene trees, run as:  
  
condor_submit_dag align_cds.dag  
  
Summary of output files for hit aligmennt:  
Protein sequence alignment of hits  
[gene_id].prot.aligned.fasta  
After trimming  
[gene_id].prot.aligned.trimmed.fasta  
Protein sequence tree, the iTOl files from the above step can be displayed on this tree  
[gene_id].prot.aligned.trimmed.fasttree  
  
Finally, review the results, and if desired modify the variables and rerun to refine the cutoffs  
To make rerunning faster, there is a cleanup script in the main directory that deletes all results files  
Run this and start over at step 1 if desired:  
bash cleanup.sh  
