/*
* Description:
*     Assemble with Unicycler
* Keywords:
*     assembly
* Tools:
*     Unicycler:
*         homepage: https://github.com/rrwick/Unicycler
*         documentation: https://github.com/rrwick/Unicycler
*         description: Unicycler is an assembly pipeline for bacterial genomes.
*                      It can assemble Illumina-only read sets where it functions
*                      as a SPAdes-optimiser. It can also assembly long-read-only
*                      sets (PacBio or Nanopore) where it runs a miniasm+Racon
*                      pipeline. For the best possible assemblies, give it both
*                      Illumina reads and long reads, and it will conduct a hybrid
*                      assembly.
*/
process unicycler_assemble {
    tag "$sample_id"
    publishDir "${params.outdir}/unicycler_assemblies", mode: 'copy', pattern: "*assembly.fasta"

    input:
    set val(sample_id), file(read_1), file(read_2), file(read_l)

    output:
    file('*_assembly.fasta')

    script:
    if( read_l.name =~ /^input.\d/ )
        """
        unicycler \
        --threads 16 \
        -1 $read_1 \
        -2 $read_2 \
        -o .
        cp assembly.fasta ${sample_id}_assembly.fasta
        
        unicycler --version &> unicycler.version.txt
        """
    else
	"""
        unicycler \
        --threads 16 \
        -1 $read_1 \
        -2 $read_2 \
        -l $read_l \
        -o .
        cp assembly.fasta ${sample_id}_assembly.fasta

        unicycler --version &> unicycler.version.txt
        """
}
