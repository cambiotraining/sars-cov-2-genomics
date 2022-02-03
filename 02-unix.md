---
pagetitle: "The Unix Shell"
---

# The Unix Shell

:::highlight

## Questions

- Why is the Unix command line useful for bioinformatics? 
- What is the general structure and usage of a command line tool?
- How can I navigate a filesystem and work with files from the command line?
- How can I find and count text patterns within files?
- How can I write and run basic scripts?
- (Maybe as an extra?) How can I connect and work on a remote server?

## Learning Objectives

- Navigate filesystem (`cd`, `ls`, `pwd`, `mkdir`, `rmdir`, `rm`, `cp`, `mv`).
- Working with files (`head`, `tail`, `cat`, `zcat`, `less`).
- Pipe commands `|`.
- Find a pattern in a file (`grep`) and do basic string replacement (`sed` and `awk`).
- Wildcards (`*`).
- Redirecting output (`>`, `>>`).
- Use a text editor to create basic shell scripts and run them with `bash`.
- (Maybe as an extra?) Use `ssh` to connect to a remote server. Use `scp` and/or _Filezilla_ to move files in/out of a remote server.

:::

<!--
:::exercise

- How many sequences are there? The problem with this one is that it wouldn't work for gz files :( 

```bash
wc *.r1.fq | sort -n
```

- Look for the presence of primers in the sequences? Using `grep` or something simple like that. 
  - `zcat data/illumina/ERR4687822_1.fastq.gz | grep "CATTTGCATCAGAGGCTGCTCG" | wc -l`
  - concatenate several fasta files
  - adjust fasta file headers (e.g. add metadata to header with some fancy `awk` or `sed`?)

:::


## Summary

:::highlight

**Key Points**

- one
- two

:::
-->
