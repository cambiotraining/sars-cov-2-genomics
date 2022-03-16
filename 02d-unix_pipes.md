---
pagetitle: "SARS-CoV-2 Genomics"
---

# The Unix Shell: Combining Commands

:::highlight

**Questions**

- How can I combine existing commands to do new things?
- How can I save and re-use commands?

**Learning Objectives**

- Construct command pipelines with two or more stages.
- Create files from the command line using a text editor.
- Write a shell script that runs a command or series of commands for a fixed set of files.
- Run a shell script from the command line.
- Customise shell scripts to work with inputs defined by the user. 

:::

:::note
This section has an accompanying <a href="https://docs.google.com/presentation/d/1lhN16pFpphxz2oO1T9x8xnSj6JRHeV9PLNXhK0FJZ2c/edit?usp=sharing" target="_blank">slide deck</a>.
:::

## The `|` Pipe

Now that we know a few basic commands, we can finally look at the shell's most powerful feature: the ease with which it lets us combine existing programs in new ways.

If we wanted to count how many files we have in the `data/sequencing_run1/` directory, we could do it in two steps:

```console
$ ls data/sequencing_run1/ > sequencing_files.txt
$ wc -l sequencing_files.txt
```

- Used the `ls` command to list the files and save the output in a text file (with the `>` redirect operator).
- And then count the lines in the resulting file. 

But what if we wanted to do this without creating the file?
It turns out we can send the output of one command and pass it on to another using a special operator `|` called the **pipe**.
Like this:

```console
$ ls data/sequencing_run1/ | wc -l
```

```
4
```

What happened there is that the output of `ls` was sent "through the pipe" to the `wc` command. 

:::exercise

Let's go back to our primer files: 

```console
$ ls artic_primers_pool*.bed
```

Using the `|` pipe, write a chain of commands that does the following:

- Combine (or "concatenate") both primer files. <details><summary>Hint</summary>Use the `cat` command.</details>
- Search for lines with the pattern "LEFT". <details><summary>Hint</summary>Use the `grep` command.</details>
- Count the number of lines of the output.

<details><summary>Answer</summary>

The three commands we want to use to achieve this are:

- `cat` to _concatenate_ the files.
- `grep` to only print the lines that match "LEFT".
- `wc -l` to count the number of lines. 

We can chain all the commands together like this:

```console
$ cat artic_primers_pool*.bed | grep "LEFT" | wc -l
```

```
109
```

</details>

:::


:::exercise

If you had the following two text files:

```console
cat animals_1.txt
```

```
deer
rabbit
raccoon
rabbit
```

```console
cat animals_2.txt
```

```
deer
fox
rabbit
bear
```

What would be the result of the following command?

```console
cat animals*.txt | head -n 6 | tail -n 1
```

<details><summary>Answer</summary>

The result would be "fox". 
Let's go through this step-by-step.

`cat animals*.txt` would combine the content of both files:

```
deer
rabbit
raccoon
rabbit
deer
fox
rabbit
bear
```

`head -n 6` would then print the first six lines of the combined file, so:

```
deer
rabbit
raccoon
rabbit
deer
fox
```

And finally `tail -n 1` would return the last line of this output:

```
fox
```

</details>
:::


## Shell Scripts

So far we have been running commands directly on the console, in an interactive way. 
However, to re-run a series of commands (or an analysis), we can save the commands in a file so that we can re-run all those operations again later by typing a single command. 
The file containing the commands is usually called a **shell script** (you can think of them as small programs).

For example, let's create a shell script that counts the number of sequences in one of our FASTA files in the `data` directory. 
We could achieve this with the following command: 

```console
$ cat data/envelope_protein.fa | grep ">" | wc -l
```

To write a shell script we save this command within a text file. 
But how do we create a text file from within the command line?

### Creating Files

There are many text editors available for programming, but we will use a simple one that can be used from the command line, called `nano`. 

First let's create a directory to save our script:

```console
$ mkdir scripts/
```

Now we can create a file with _Nano_ in the following way:

```console
$ nano scripts/count_fasta_sequences.sh
```

This opens a text editor, where you can type the commands you want to save in the file. 
Once we're happy with our text, we can press <kbd>Ctrl</kbd>+<kbd>O</kbd> (press the Ctrl or Control key and, while holding it down, press the O key) to write our data to disk. 
We'll be asked what file we want to save this to: press <kbd>Return</kbd> to accept the suggested default of `scripts/count_fasta_sequences.sh`.
Once our file is saved, we can use <kbd>Ctrl</kbd>+<kbd>X</kbd> to quit the editor and return to the shell.

We can check with `ls scripts/` that our new file is there. 

![Screenshot of the command line text editor _Nano_. In this example, we also included `!#/bin/bash` in the first line of the script. This is called a [_shebang_](https://en.wikipedia.org/wiki/Shebang_(Unix)) and is a way to inform that this script uses the program `bash` to run the script.](images/nano.png)

Note that because we saved our file with `.sh` extension (the conventional extension used for shell scripts), _Nano_ does some colouring of our commands (this is called _syntax highlighting_) to make it easier to read the code. 

:::note
**Text Editors**

When we say, "`nano` is a text editor," we really do mean "text": it can only work with plain character data, not tables, images, or any other human-friendly media. 
We use it in examples because it is one of the least complex text editors. 
However, because of this trait, it may not be powerful enough or flexible enough for the work you need to do after this workshop. 

On Unix systems (such as Linux and Mac OS X), many programmers use [Emacs](http://www.gnu.org/software/emacs/) or [Vim](http://www.vim.org/). 
Both of these run from the terminal and have very advanced features, but require more time to learn. 

Alternatively, programmers also use graphical editors, such as [Visual Studio Code](105-vs_code.md).
This software offers many advanced capabilities and extensions and works on Windows, Mac OS and Linux. 
:::


### Running Scripts

Now that we have our script, we can run it using the program `bash`:

```console
$ bash scripts/count_fasta_sequences.fa
```

Which will print the result on our screen. 


### Customising Scripts

The script we wrote so far works on a specific FASTA file (in our example `data/envelope_protein.fa`). 
But what if we wanted to give it as input a file of our choice? 
We can make our script more versatile by using a special _shell variable_ that means "the first argument on the command line".
Here is our modified script:

```bash
#!/bin/bash

echo "Processing file: $1"

cat "$1" | grep ">" | wc -l
```

We have done two things: 

- We use the variable `$1` to indicate the file that we want to process will be given from the command line.
- We use the `echo` command to print an informative message to the user.

If we run our new script, this is the result: 

```console
$ bash   scripts/count_fasta_sequences.sh   data/envelope_protein.fa
```

```
Processing file: data/envelope_protein.fa
4
```

## Summary

:::highlight

**Key Points**

- The `|` pipe allows to chain several commands together. The output of the command on the left of the pipe is sent as input to the command on the right.
- The `nano` text editor can be used to create or edit files from the command line. 
- We can save commands in a text file, which we call a _shell script_. Shell scripts have extension `.sh`.
- We can run a shell script using the program `bash`. 
- We can use custom inputs to our script using the special variable `$1`.

:::
