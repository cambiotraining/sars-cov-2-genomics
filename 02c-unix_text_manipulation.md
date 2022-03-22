---
pagetitle: "SARS-CoV-2 Genomics"
---

# The Unix Shell: Text Manipulation

:::highlight

**Questions**

- How can I inspect the content of and manipulate text files?
- How can I find and replace text patterns within files?

**Learning Objectives**

- Inspect the content of text files (`head`, `tail`, `cat`, `zcat`, `less`).
- Use the `*` wildcard to work with multiple files at once.
- Redirect the output of a command to a file (`>`, `>>`).
- Find a pattern in a text file (`grep`) and do basic pattern replacement (`sed`).

:::

:::note
This section has an accompanying <a href="https://docs.google.com/presentation/d/1lhN16pFpphxz2oO1T9x8xnSj6JRHeV9PLNXhK0FJZ2c/edit?usp=sharing" target="_blank">slide deck</a>.
:::

## Looking Inside Files

Often we want to investigate the content of a file, without having to open it in a text editor. 
This is especially useful if the file is very large (as is often the case in bioinformatic applications). 

For example, let's take a look at the file `artic_primers_pool1.bed`. 
We will start by printing the whole content of the file with the `cat` command, which stands for "concatenate" (we will see why it's called this way in a little while):

```console
$ cat artic_primers_pool1.bed
```

This outputs a lot of text, because the file is quite long!

Instead, it is often more useful to look only at the top few lines of the file. 
We can do this with the `head` command:

```console
$ head artic_primers_pool1.bed
```

```
MN908947.3	30	54	nCoV-2019_1_LEFT	1	+
MN908947.3	385	410	nCoV-2019_1_RIGHT	1	-
MN908947.3	642	664	nCoV-2019_3_LEFT	1	+
MN908947.3	1004	1028	nCoV-2019_3_RIGHT	1	-
MN908947.3	1242	1264	nCoV-2019_5_LEFT	1	+
MN908947.3	1623	1651	nCoV-2019_5_RIGHT	1	-
MN908947.3	1875	1897	nCoV-2019_7_LEFT	1	+
MN908947.3	1868	1890	nCoV-2019_7_LEFT_alt0	1	+
MN908947.3	2247	2269	nCoV-2019_7_RIGHT	1	-
MN908947.3	2242	2264	nCoV-2019_7_RIGHT_alt5	1	-
```

By default, `head` prints the first 10 lines of the file. 
We can change this using the `-n` option, followed by a number, for example: 

```console
$ head -n 2 artic_primers_pool1.bed
```

```
MN908947.3	30	54	nCoV-2019_1_LEFT	1	+
MN908947.3	385	410	nCoV-2019_1_RIGHT	1	-
```

Similarly, we can look at the _bottom_ few lines of a file with the `tail` command:

```console
$ tail -n 2 artic_primers_pool1.bed
```

```
MN908947.3	29288	29316	nCoV-2019_97_LEFT	1	+
MN908947.3	29665	29693	nCoV-2019_97_RIGHT	1	-
```

Finally, if we want to open the file and browse through it, we can use the `less` command: 

```console
$ less artic_primers_pool1.bed
```

`less` will open the file and you can use <kbd>↑</kbd> and <kbd>↓</kbd> to move line-by-line or the <kbd>Page Up</kbd> and <kbd>Page Down</kbd> keys to move page-by-page. 
You can exit `less` by pressing <kbd>Q</kbd> (for "quit"). 
This will bring you back to the console. 

Finally, it can sometimes be useful to _count_ how many lines, words and characters a file has.
We can use the `wc` command for this:

```console
wc artic_primers_pool*.bed
```

```
110  660 4961 artic_primers_pool1.bed
108  648 4878 artic_primers_pool2.bed
218 1308 9839 total
```

In this case, we used the `*` wildcard to count lines, words and characters (in that order, left-to-right) of both our primer files. 
Often, we only want to count one of these things, and `wc` has options for all of them:

- `-l` counts lines only.
- `-w` counts words only.
- `-c` counts characters only.

For example, if we just want to know how many primers we have (the number of lines in the files):

```console
wc -l artic_primers_pool*.bed
```

```
110  artic_primers_pool1.bed
108  artic_primers_pool2.bed
218  total
```

:::exercise

- Use the `less` command to look inside the file `data/reference_genome.fa`.
- How many lines does this file contain?
- Use the `less` command again but with the option `-S`. Can you understand what this option does?

<details><summary>Answer</summary>

We can investigate the content of the reference file using `less data/reference_genome.fa`.
From this view, it looks like this file contains several lines of content: the genome is almost 30kb long, so it's not surprising we see so much text!
We can use <kbd>Q</kbd> to quit and go back to the console. 

To check the number of lines in the file, we can use the `wc -l data/reference_genome.fa` command.
The answer is only 2.  

If we use `less -S data/reference_genome.fa` the display is different this time. 
We see only two lines in the output. 
If we use the <kbd>→</kbd> and <kbd>←</kbd> arrows we can see that the text now goes "out of the screen". 
So, what happens is that by default `less` will "wrap" long lines, so if a line of text is too long, it will continue it on the next line of the screen.
When we use the option `-S` it instead displays each line individually, and we can use the arrow keys to see the content that does not fit on the screen. 

</details>
:::


:::note
The primer files we just looked into are in a format called [BED](https://en.wikipedia.org/wiki/BED_(file_format)). 
This is a standard bioinformatic file format used to store coordinates of genomic regions. 
In this case, it corresponds to the coordinates of each primer start and end position in the SARS-CoV-2 reference genome (Wuhan-Hu-1).

In the exercise we looked at another standard file format called [FASTA](https://en.wikipedia.org/wiki/FASTA). 
This one is used to store nucleotide or amino acid sequences. 
In this case, the complete nucleotide sequence of the SARS-CoV-2 reference genome.

We will learn more about these files in [Intro to NGS](03-intro_ngs.html).
:::


## Combining several files

We said that the `cat` command we used above stands for "concatenate". 
This is because this command can be used to _concatenate_ (combine) several files together. 
For example, if we wanted to combine both sets of primer pools into a single file: 

```console
cat artic_primers_pool1.bed artic_primers_pool2.bed
```

## Redirecting Output

The `cat` command we just used printed the output to the screen. 
But what if we wanted to save it into a file? 
We can achieve this by sending (or _redirecting_) the output of the command to a file using the `>` operator. 

```console
cat artic_primers_pool1.bed artic_primers_pool2.bed > artic_primers.bed
```

Now, the output is not printed to the console, but instead sent to a new file. 
We can check that the file was created with `ls`. 

If we use `>` and the output file already exists, its content will be replaced. 
If what we want to do is _append_ the result of the command to the existing file, we should use `>>` instead. 
Let's see this in practice in the next exercise. 

:::exercise

1. List the files in the `data/sequencing_run1/` directory. Save the output in a file called "sequencing_files.txt".
2. What happens if you run the command `ls data/sequencing_run2/ > sequencing_files.txt`?
3. The operator `>>` can be used to _append_ the output of a command to an existing file. Try re-running both of the previous commands, but instead using the `>>` operator. What happens now?

<details><summary>Answer</summary>

**Task 1**

To list the files in the directory we use `ls`, followed by `>` to save the output in a file:

```console
$ ls data/sequencing_run1/ > sequencing_files.txt
```

We can check the content of the file:

```console
$ cat sequencing_files.txt
```

```
sample1_run1.fastq
sample2_run1.fastq
sample3_run1.fastq
sample4_run1.fastq
```

----

**Task 2**

If we run `ls data/sequencing_run2/ > sequencing_files.txt`, we will replace the content of the file:

```console
$ cat sequencing_files.txt
```

```
sample1_run2.fastq
sample2_run2.fastq
sample3_run2.fastq
sample4_run2.fastq
sample5_run2.fastq
sample6_run2.fastq
```

----

**Task 3**

If we start again from the beggining, but instead use the `>>` operator the second time we run the command, we will append the output to the file instead of replacing it:

```console
$ ls data/sequencing_run1/ > sequencing_files.txt
$ ls data/sequencing_run2/ >> sequencing_files.txt
$ cat sequencing_files.txt
```

```
sample1_run1.fastq
sample2_run1.fastq
sample3_run1.fastq
sample4_run1.fastq
sample1_run2.fastq
sample2_run2.fastq
sample3_run2.fastq
sample4_run2.fastq
sample5_run2.fastq
sample6_run2.fastq
```

</details>
:::

## Finding Patterns

Something it can be very useful to find lines of a file that match a particular text pattern. 
We can use the tool `grep` ("global regular expression print") to achieve this. 
For example, let's find the word "nCoV-2019_46" in our primers file:

```console
$ grep "nCoV-2019_46" artic_primers.bed
```

```
MN908947.3	13599	13621	nCoV-2019_46_LEFT	2	+
MN908947.3	13602	13625	nCoV-2019_46_LEFT_alt1	2	+
MN908947.3	13962	13984	nCoV-2019_46_RIGHT	2	-
MN908947.3	13961	13984	nCoV-2019_46_RIGHT_alt2	2	-
```

We can see the result is all the lines that matched this word pattern. 

:::exercise

Consider the file we previously saved in `results/variants.tsv`.
(Note, if you don't have this file, run the following commands: `mkdir -p results; mv output.tsv results/variants.tsv`)

1. Create a new file called `results/alpha.tsv` that contains only the Alpha variant samples. <details><summary>Hint</summary>You can use `grep` to find a pattern in a file. You can use `>` to _redirect_ the output of a command to a new file.</details>
2. How many samples are you left with?

<details><summary>Answer</summary>

**Task 1**

We can use `grep` to find a pattern in our text file and use `>` to save the output in a new file:

```console
$ grep "Alpha" results/variants.tsv > results/alpha.tsv
```

We could investigate the output of our command using `less results/alpha.tsv`.

----

**Task 2**

We can use `wc` to count the lines of the newly created file:

```console
$ wc -l results/alpha.tsv
```

Giving us 31 as the result.

</details>
:::


## Text Replacement 

One of the most prominent text-processing utilities is the `sed` command, which is short for "stream editor".
A stream editor is used to perform basic text transformations on an input stream (a file or input from a pipeline). 

`sed` contains several sub-commands, but the main one we will use is the _substitute_ or `s` command. 
The syntax is:

```bash
sed 's/pattern/replacement/options'
```

Where `pattern` is the word we want to substitute and `replacement` is the new word we want to use instead. 
There are also other "options" added at the end of the command, which change the default behaviour of the text substitution. 
Some of the common options are:

- `g`: by default `sed` will only substitute the first match of the pattern. If we use the `g` option ("**g**lobal"), then `sed` will substitute all matching text.
- `i`:  by default `sed` matches the pattern in a case-sensitive manner. For example 'A' (Uppercase A) and 'a' (Lowercase A) are treated as different. If we use the `i` option ("case-**i**nsensitive") then `sed` will treat 'A' and 'a' as the same.

For example, let's create a file with some text inside it:

```console
$ echo "Hello world. How are you world?" > hello.txt
```

(Note: the `echo` command is used to print some text on the console. In this case we are sending that text to a file to use in our example.)

If we do:

```console
$ sed 's/world/participant/' hello.txt
```

This is the result

```
Hello participant. How are you world?
```

We can see that the first "world" word was replaced with "participant". 
This is the default behaviour of `sed`: only the first pattern it finds in a line of text is replaced with the new word. 
We can modify this by using the `g` option after the last `/`:

```console
$ sed 's/world/participant/g' hello.txt
```

```
Hello participant. How are you participant?
```

:::note
**Regular Expressions**

Finding patterns in text can be a very powerful skill to master. 
In our examples we have been finding a literal word and replacing it with another word. 
However, we can do more complex text substitutions by using special keywords that define a more general pattern. 
These are known as **regular expressions**. 

For example, in regular expression syntax, the character `.` stands for "any character". 
So, for example, the pattern `H.` would match a "H" followed by any character, and the expression: 

```console
$ sed 's/H./X/g' hello.txt
```

Results in:

```
Xllo world. Xw are you world?
```

Notice how both "He" (at the start of the word "Hello") and "Ho" (at the start of the word "How") are replaced with the letter "X".
Because both of them match the pattern "H followed by any character" (`H.`).

To learn more see this [Regular Expression Cheatsheet](https://www.keycdn.com/support/regex-cheatsheet).
:::

### The `\` Escape Character

You may have asked yourself, if the `/` character is used to separate parts of the `sed` substitute command, then how would we replace the "/" character itself in a piece of text?
For example, let's add a new line of text to our file:

```console
$ echo "Welcome to this workshop/course." >> hello.txt
```

Let's say we wanted to replace "workshop/course" with "tutorial" in this text. 
If we did:

```console
$ sed 's/workshop/course/tutorial/' hello.txt
```

We would get an error: 

```
sed: -e expression #1, char 5: unknown option to `s'
```

This is because we ended up with too many `/` in the command, and `sed` uses that to separate its different parts of the command. 
In this situation we need to tell `sed` to ignore that `/` as being a special character but instead treat it as the literal "/" character. 
To to this, we need to use `\` before `/`, which is called the "escape" character. 
That will tell `sed` to treat the `/` as a normal character rather than a separator of its commands.
So:

```console
$ sed 's/workshop\/course/tutorial/' hello.txt
                  ↑
             This / is "escaped" with \ beforehand
```

This looks a little strange, but the main thing to remember is that `\/` will be interpreted as the character "/" rather than the separator of `sed`'s substitute command. 


:::exercise

The file in `data/envelope_protein.fa` contains the amino acid sequence of the SARS-CoV-2 envelope protein for 4 patient samples. 

```console
$ cat data/envelope_protein.fa
```

```
>patient01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Patient02/incomplete
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFY...................
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

We will cover FASTA files in the following section, for now all we need to know is that each sequence has a name in a line that starts with the character `>`. 

Use `sed` to achive the following: 

1. Substitute the word `patient` with `sample`. <details><summary>Hint</summary>Similarly to how you can use the `g` option to go "global" substitution, you can also use the `i` option to do case-**i**nsensitive text substitution.</details>
1. Substitute the word `/incomplete` with `-missing`.
1. The character `.` is also a keyword used in _regular expressions_ to mean "any character". See what happens if you run the command `sed 's/./X/g' data/envelope_protein.fa`. How would you fix this command to literally only substitute the character `.` with `X`?


<details><summary>Answer</summary>

**Task 1**

To replace the word `patient` with `sample`, we can do:

```console
$ sed 's/patient/sample/i' data/envelope_protein.fa
```

```
>sample01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>sample02/incomplete
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFY...................
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

We have to use the option `i` to tell the `sed` that we want to match the word `patient` in case-insensitive manner. 

----

**Task 2**

For the second task, if we do:

```console
$ sed 's//incomplete/-missing/'  data/envelope_protein.fa
```

We will get an error. 
We need to use `\` to _escape_ the `/` keyword in our pattern, so:

```console
$ sed 's/\/incomplete/-missing/'  data/envelope_protein.fa
```

```
>patient01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Patient02-missing
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFY...................
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

----

**Task 3**

Finally, to replace the character `.`, if we do:

```console
$ sed 's/./X/g' data/envelope_protein.fa
```

```
XXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Everything becomes "X"! 
That's because `.` is a keyword used in _regular expressions_ to mean "any character". 
Because we are using the `g` option (for "global substitution"), we replaced every single character with "X".
To literally replace the character ".", we need to again use the `\` escape character, so: 

```console
$ sed 's/\./X/g' data/envelope_protein.fa
```

```
>patient01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Patient02/incomplete
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFYXXXXXXXXXXXXXXXXXXX
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

</details>


:::


## Summary

:::highlight
**Key Points**

- The `head` and `tail` commands can be used to look at the top or bottom of a file, respectively.
- The `less` command can be used to interactively investigate the content of a file. Use <kbd>↑</kbd> and <kbd>↓</kbd> to browse the file and <kbd>Q</kbd> to quit and return to the console.
- The `cat` command can be used to combine multiple files together. The `zcat` command can be used instead if the files are compressed.
- The `>` operator redirects the output of a command into a file. If the file already exists, it's content will be overwritten.
- The `>>` operator also redictects the output of a command into a file, but _appends_ it to any content that already exists. 
- The `grep` command can be used to find the lines in a text file that match a text pattern.
- The `sed` tool can be used for advanced text manipulation. The "substitute" command can be used to text replacement: `sed 's/pattern/replacement/options'`.
:::
