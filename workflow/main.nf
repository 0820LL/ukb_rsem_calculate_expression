// Declare syntax version
nextflow.enable.dsl=2

process RSEM_CALCULATEEXPRESSION {

    container = "${projectDir}/../singularity-images/depot.galaxyproject.org-singularity-mulled-v2-cf0123ef83b3c38c13e3b0696a3f285d3f20f15b-64aad4a4e144878400649e71f42105311be7ed87-0.img"

    input:
    path reads
    path rsem_index

    output:
    path "*.genes.results"
    path "*.isoforms.results"

    script:
    """
    INDEX=`find -L ./ -name "*.grp" | sed 's/\\.grp\$//'`
    rsem-calculate-expression \\
        --num-threads ${params.threads_num} \\
        --temporary-folder ./tmp/ \\
        --paired-end \\
        --star --star-output-genome-bam --star-gzipped-read-file --estimate-rspd --seed 1 \\
        $reads \\
        \$INDEX \\
        ${params.prefix} 
    cp *results ${launchDir}/${params.outdir}/
    """
}

workflow{
    reads      = Channel.of(params.fastq1, params.fastq2).collect()
    rsem_index = Channel.of(params.rsem_index_path)
    RSEM_CALCULATEEXPRESSION(reads, rsem_index)
}

