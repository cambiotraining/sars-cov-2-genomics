---
pagetitle: "SARS-CoV-2 Genomics"
---

# The Unix Shell: Text Manipulation

:::highlight

**Questions**

- How can I combine existing commands to do new things?

**Learning Objectives**

- Construct command pipelines with two or more stages.
- Explain what usually happens if a program or pipeline isn't given any input to process.

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
