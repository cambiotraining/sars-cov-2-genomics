---
pagetitle: "The Unix Shell: sed - stream editor"
---

# The Unix Shell: `sed` - stream editor

:::highlight

**Questions**

- What is `sed`? How to use `sed`?
- What is the `sed` script?
- What is the `s` command? How to use the `s` command?
- What is an escape character?
- How to use wildcards in the `sed`?

**Learning Objectives**

- Explain the basic usage of the `sed`.
- A closer look to `sed` script.
- Demonstrate the usage of the `sed` in processing text.

:::

## Introduction
The `sed` command is short for stream editor. A stream editor is used to perform basic text transformations on an input stream (a file or input from a pipeline). 

`sed` is one of the most prominent text-processing utilities on GNU/Linux. `sed` performs operations on text coming from standard input or a file. 

:::note
In this tutorial, we'll use the GNU version of `sed` (available on Ubuntu and other Linux operating systems). The macOS has the BSD version of `sed` which has different options and arguments. You can install the GNU version of `sed` with [Homebrew](https://brew.sh/) using `brew install gnu-sed`.
:::

## Basic Usage
There are many instances when we want to substitute a text in a line or filter out specific lines. In such cases, we can take advantage of `sed`. 
`sed` operates on a stream of text which it gets either from a text file or from standard input (STDIN). It means you can use the output of another command as the input of `sed` -- in short, you can combine `sed` with other commands.

By default, `sed` outputs everything to standard output (STDOUT). It means, unless redirected, `sed` will print its output onto the terminal/screen instead of saving it in a file.

:::note
`sed` edits line-by-line and in a non-interactive way.
:::

The basic usage of `sed`:

```bash
$ sed [OPTIONS] SCRIPT INPUT-FILES
```

To begin this tutorial, create a file 'input.txt' and write the following line and save.
```bash
hello world
```

Now we'll use the `sed` to replace 'hello' with 'world':

```bash
$ sed 's/hello/world/' input.txt  
```

```bash
# Output
world world
```
Just follow this tutorial we will explain all the magic which just happened.

## `sed` script commands

Let's take a closer look at the `sed` script command. In the above script (`s/hello/world`), 's' is called the `sed` command. There are many `sed` commands, but we'll mainly focus on the 's' command. To see a list of all `sed`'s commands, visit [https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html](https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html).

The basic syntax for a `sed` command is:
```bash
[ADDRESS]X[OPTION]
```

Here, 'X' is the single letter `sed` command. [ADDRESS] is optional. If [ADDRESS] is specified, the command X will be executed only on the matched lines. Now, [ADDRESS] can be a single line number, regular expression, or a range of lines. For some `sed` commands we use additional [OPTION].

## The 's' command

The 's' command, also known as substitute command, is probably the most important in `sed` and has a lot of different options. The basic syntax for 's' command is:

```bash
s/regexp/replacement/[flags]
```

As you might have guessed, 's' is for substitution. It will tell `sed` that we are going make some substitution. 's' is followed by '/' you can think of it as a delimiter. 

After that, we have *regexp*, which is short for the regular expression. We use the regular expression to match the pattern against the content of a line.

:::note
**What is a regular expression?**

A regular expression is a pattern formed in a standardised way that helps search in a string. Regular expressions are useful for matching common patterns of string such as email addresses, phone numbers, URLs, etc. To learn more visit: [https://www.keycdn.com/support/regex-cheatsheet](https://www.keycdn.com/support/regex-cheatsheet)
:::

The third one is the replacement. So, if `sed` finds the match, it will replace the matched text/pattern with the replacement text.

So, the basic concept of the 's' command is: it attempts to match the pattern in a line, if the match is successful, then that portion of the pattern is replaced with *replacement*.

At the last of the 's' command, you can see [flags]. [flags] are optional. An 's' command can have zero or more flags. Some of the common flags are:

- **g**: By default `sed` command will only substitute the first match. If the line has more than one match, all will not get replaced. It replaces only the first match. But, if we use the **g** flag, then the `sed` command will replace all matching text.

- **i**:  `sed` matches the regular expression in a case-sensitive manner. It means 'A' (Uppercase A) and 'a' (Lowercase A) are different. But, if we use the **i** flag, then the `sed` will match the regular expression in a case-insensitive manner. This means now the `sed` will treat 'A' and 'a' as same.

To learn more about the 's' command visit [https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html](https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html).


## Using the 's' command

Let's go back to our first example.
```bash
$ sed 's/hello/world' input.txt
```
Now, I guess it is somewhat clear to you what is happening here. The `sed` is substituting 'hello' with 'world' at every line. And we are getting the input from a file called 'input.txt'.

Create a new file 'input2.txt' and write the following text in it:

```bash
# Output

Hello, this is a test line. This is a very short line.
This is test line two. In this line, we have two occurrences of the test.
This line has many occurrences of the Test with different cases. test tEst TesT.
```

Now try to replace 'test' with 'hello'. We can do something like this:

```bash
$ sed 's/test/hello/' input2.txt
```

```bash
# Output

Hello, this is a hello line. This is a very short line.
This is hello line two. In this line, we have two occurrences of the test.
This line has many occurrences of the Test with different case. hello tEst TesT.
```

You may have noticed that lines two and three still have 'test'. This is because we ask the `sed` to only replace the first text which matches. To replace all the matches, we have to use **g** flag. Let's try with **g** flag.


```bash
$ sed 's/test/hello/g' input2.txt
```

```bash
# Output

Hello, this is a hello line. This is a very short line.
This is hello line two. In this line, we have two occurrences of the hello.
This line has many occurrences of the Test with different case. hello tEst TesT.
```

Ah, something is still wrong with the third line. It is not replacing 'Test', 'tEst' and 'TesT'. We have to do something to tell the `sed` that we want to replace all of them. We can do this by using **i** flag. Let's add one more flag:

```bash
$ sed 's/test/hello/gi' input2.txt
```

```bash
# Output

Hello, this is a hello line. This is a very short line.
This is hello line two. In this line, we have two occurrences of the hello.
This line has many occurrences of the hello with different case. hello hello hello.
```

Wonderful! 

Let's say now we only want to replace all the occurrences of the 'test' at only line 3 or from line 2 to 3. Try to remember the basic syntax for the `sed` command. Remember! You can add the address of the line or a range of lines that you want to edit. Here is an example:

```bash
$ sed '3s/test/hello/gi' input2.txt
```

```bash
# Output

Hello, this is a test line. This is a very short line.
This is test line two. In this line, we have two occurrences of the test.
This line has many occurrences of the hello with different case. hello hello hello.
```

See only the third line is executed by the `sed`. The first two lines are as it is. At the beginning of the 's' command, we are adding the line number which we want to edit. We can also add a range of lines. Here is one more example:


```bash
$ sed '2,3s/test/hello/gi' input2.txt
```

As you may have got the idea, it will edit lines 2 and 3. The output will be:

```bash
# Output

Hello, this is a test line. This is a very short line.
This is hello line two. In this line, we have two occurrences of the hello.
This line has many occurrences of the hello with different case. hello hello hello.
```


## Combining `sed` commands

You can combine multiple `sed` commands. Let's say in the 'input2.txt' we first want to remove all the occurrences of 'test', then we want to replace 'line' with 'world'. Here it is clear that we have to do two substitutions. One for removing 'test' and one for replacing 'line'. We can do something like this:

```bash
$ sed 's/test//gi' input2.txt | sed 's/line/world/gi'
```

Here first we are removing 'test' with empty text, and then we are passing the output of first `sed` as the input of second `sed`. The second `sed` is replacing 'line' with 'world'. You will get an output like this:

```bash
# Output

Hello, this is a  world. This is a very short world.
This is  world two. In this world, we have two occurrences of the .
This world has many occurrences of the  with different case.   .
```

## Escape character

An escape character is a character that invokes an alternative interpretation of the following character. Sometimes it is also used to insert unallowed characters in a string. An escape character is a backslash `\` followed by a character (or characters). Some of the keywords/characters which you want to escape are as follows:

- `*`: Asterisk.
- `.`: Dot.
- `[`: Left square bracket.
- `]`: Right square bracket.
- `?`: Question mark.
- `$`: Dollar sign.
- `^`: Caret
- `/`: Forward slash
- `\`: Backward slash

Let's try to understand this with examples. For this tutorial, create a file 'input3.txt' and put the following text in it:
```
This software/application is a part of this workshop.
```

Now, what if we want to replace 'software/application' with 'material'. If we try to do something like: `sed 's/software/application/material/' input3.txt`, the `sed` will throw an error. Because here we are using '/' as delimiter, sed will think it has to replace 'software' with 'application' but, why there is a third option. To solve this error, we have to escape one '/', we can do this by adding a `\` in front of '/'. It will tell the `sed` not to interpret '/' as a special character.

```bash
$ sed 's/software\/application/material/' input3.txt
```

```bash
# Output

This material is a part of this workshop.
```

Escape characters are also used to provide visual representations of non-printing characters and characters that usually have special meanings. The list of commonly used escape characters in the `sed` is as follows:

- `\n`: a newline.
- `\r`: a carriage return.
- `\t`: a horizontal tab.

For more details visit [https://www.gnu.org/software/sed/manual/sed.html#Escapes](https://www.gnu.org/software/sed/manual/sed.html#Escapes).


## Wildcards in `sed`

We have already covered wildcards on the "[Basic Commands](./02-unix-basic-commands.html#Using_wildcards_for_accessing_multiple_files_at_once)" page; here, we will discuss the use of `.`, `*` and `?` in the `sed`. These wildcards are part of the regular expression. 

- You can use `.` as a placeholder for any character except newline (`\n`) or empty text. For example, if you use `.` in your regular expression like `x.z` then it will match to strings like `xaz`, `xbz`, `x1z`, `xzz`, etc., but, it will not match to `xz`.

- You can use `*` to match 0 or more occurrences of the previous character. For example, `xy*z` will match to strings like `xz` (0 occurrences of y), `xyz` (1 occurrence of y), `xyyz` and so on.

- `?` is a bit similar to `*`. The difference is it will only match for 0 or 1 occurrence of the previous character. For example, `xy?z` will match to strings like `xz` (0 occurrences of y), `xyz` (1 occurrence of y) but not to `xyyz`.

Now, let's do some coding. Create a file 'input4.txt' and copy the following sequence:
```bash
ATGCCTGATTGGGCTACGTCGTAAGCGATGGCTAGGTATCGTAAAGGGGTTTGGGAACCCCAATCACTAGCT
```

Let's say we want to replace anything between `A` and `G` with `U`. We can do this using the `sed`:

```bash
$ sed 's/A.G/AUG/g' input4.txt
```
```bash
#Output

AUGCCTGATTGGGCTAUGTCGTAUGCGAUGGCTAUGTATCGTAAUGGGGTTTGGGAACCCCAATCACTAGCT
```


:::exercise

**Replace Me**

Click on the following link to download the fasta file containing the protein sequence for one of the SARS-CoV-2, <a href="assets/exercise/envelope_gene.fa" download>`envelope_gene.fa`</a>. You have four tasks to do on this file. They are:

- Replace the word `patient` with `sample`. Make sure to replace all words matching to `patient` in a case insensitive manner.
- Replace all the `.` with `X`.
- Remove `/incomplete` from one of the sample names.
- Save the out to `envelope_gene_processed.fa`.

<details>
<summary>Answer</summary>

We will walk through the solution step by step. At first, to replace the word `patient` with `sample`, we can do something like this:

```bash
$ sed 's/patient/sample/i' envelope_gene.fa
```
```bash
# Output

>sample01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>sample02/incomplete
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFY...................
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

We have to use the flag `i` to tell the `sed` that we want to match the word `patient` in case insensitive manner. 

Second we have to replace all the `.` with `X`. Remember the `.` is a keyword (or has special meaning in the `sed`). So, to have the literal meaning of `.`, we have to escape the `.` with `\`. We can replace all the `.` as follows:

```bash
$ sed 's/\./X/g' envelope_gene.fa 
```
```bash
# Output

>patient01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Patient02/incomplete
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFYXXXXXXXXXXXXXXXXXXX
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

In line 4, you can see that all the `.` is replaced by `X`. Note that to replace all the `.` we also have to use `g` flag. 

Third, we have remove `\incomplete`. Again `/` is a keyword in the `sed`. We have to do something similar to the previous step.

```bash
$ sed 's/\/incomplete//' envelope_gene.fa
```
```bash
# Output

>patient01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Patient02
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFY...................
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

Now, we have to combine all three steps (this we can do by using pipe`|`) and then redirect the output to a file rather than the default output.

```bash
$ sed 's/patient/sample/i' < envelope_gene.fa | sed 's/\./X/g' | sed 's/\/incomplete//' > envelope_gene_processed.fa
```

```bash
# You will see no output in the terminal. But you will see a new file
# `envelope_gene_processed.fa`, which will look similar to the following

>sample01
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>sample02
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNLSLVKPSFYXXXXXXXXXXXXXXXXXXX
>sample04
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
>Sample05
MYSFVSEETGTLIVNSVLLFLAFVVFLLVTLAILTALRLCAYCCNIVNVSLVKPSFYVYSRVKNLNSSRVPDLLV*
```

</details>
:::

## Resources

To learn more about sed visit [https://www.gnu.org/software/sed/manual/sed.html](https://www.gnu.org/software/sed/manual/sed.html) 
