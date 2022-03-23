---
pagetitle: "SARS-CoV-2 Genomics"
---

# Common File Formats

This page lists some common file formats used in Bioinformatics (listed alphabetically).
The heading of each file links to a page with more details about each format. 

Generally, files can be classified into two categories: text files and binary files.

* **Text files** can be opened with standard text editors, and manipulated using command-line tools (such as `head`, `less`, `grep`, `cat`, etc.). However, many of the standard files listed in this page can be opened with specific software that displays their content in a more user-friendly way. For example, the NEWICK format is used to store phylogenetic trees and, although it can be opened in a text editor, it is better used with a software such as _FigTree_ to visualise the tree as a graph. 
* **Binary files** are often used to store data more efficiently. Typically, specific tools need to be used with those files. For example, the BAM format is used to store sequences aligned to a reference genome and can be manipulated with dedicated software such as `samtools`.

Very often, text files may be **compressed** to save storage space. 
A common compression format used in bioinformatics is _gzip_ with has extension `.gz`. 
Many bioinformatic tools support compressed files. 
For example, FASTQ files (used to store NGS sequencing data) are often compressed with format `.fq.gz`.


## [BAM](https://en.wikipedia.org/wiki/Binary_Alignment_Map) ("Binary Alignment Map")

* Binary file.
* Same as a SAM file but compressed in binary form.
* File extensions: `.bam`


## [BED](https://en.wikipedia.org/wiki/BED_(file_format)) ("Browser Extensible Data")

* Text file.
* Stores coordinates of genomic regions.
* File extension: `.bed`


## [CSV](https://en.wikipedia.org/wiki/Comma-separated_values#Example) ("Comma Separated Values")

* Text file.
* Stores tabular data in a text file. (also see TSV format)
* File extensions: `.csv`

These files can be opened with spreadsheet programs (such as _Microsoft Excel_).
They can also be created from spreadsheet programs by going to <kbd>File > Save As...</kbd> and select "CSV (Comma delimited)" as the file format.


## [FAST5](https://github.com/mw55309/EG_MinION_2016/blob/master/02_Data_Extraction_QC.md)

* Binary file. More specifically, this is a Hierarchical Data Format (HDF5) file. 
* Used by Nanopore platforms to store the called sequences (in FASTQ format) as well as the raw electrical signal data from the pore.
* File extensions: `.fast5`


## [FASTA](https://en.wikipedia.org/wiki/FASTA)

* Text file.
* Stores nucleotide or amino acid sequences.
* File extensions: `.fa` or `.fas` or `.fasta`


## [FASTQ](https://en.wikipedia.org/wiki/FASTQ_format)

* Text file, but often compressed with _gzip_.
* Stores sequences and their quality scores.
* File extensions: `.fq` or `.fastq` (compressed as `.fq.gz` or `.fastq.gz`) 


## [GFF](https://en.wikipedia.org/wiki/General_feature_format) ("General Feature Format")

* Text file.
* Stores gene coordinates and other features.
* File extension: `.gff`


## [NEWICK](https://en.wikipedia.org/wiki/Newick_format)

* Text file.
* Stores phylogenetic trees including nodes names and edge lengths.
* File extensions: `.tree` or `.treefile`


## [SAM](https://en.wikipedia.org/wiki/SAM_(file_format)) ("Sequence Alignment Map")

* Text file.
* Stores sequences aligned to a reference genome. (also see BAM format)
* File extensions: `.sam` 


## [TSV](https://en.wikipedia.org/wiki/Tab-separated_values#Example) ("Tab-Separated Values")

* Text file.
* Stores tabular data in a text file. (also see CSV format)
* File extensions: `.tsv` or `.txt`

These files can be opened with spreadsheet programs (such as _Microsoft Excel_).
They can also be created from spreadsheet programs by going to <kbd>File > Save As...</kbd> and select "Text (Tab delimited)" as the file format.


## [VCF](https://en.wikipedia.org/wiki/Variant_Call_Format) ("Variant Calling Format")

* Text file but often compressed with _gzip_.
* Stores SNP/Indel variants
* File extension: `.vcf` (or compressed as `.vcf.gz`)
