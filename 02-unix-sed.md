---
pagetitle: "The Unix Shell: sed - stream editor"
---

# The Unix Shell: sed - stream editor


## Introduction
The `sed` command is short for stream editor. A stream editor is used to perform basic text transformations on an input stream (a file or input from a pipeline). 

`sed` is one of the most prominent text-processing utilities on GNU/Linux. `sed` performs operations on text coming from standard input or a file. 

:::note
In this tutorial, we'll use the GNU version of `sed` (available on Ubuntu and other Linux operating systems). The macOS has the BSD version of `sed` which has different options and arguments. You can install the GNU version of `sed` with [Homebrew](https://brew.sh/) using `brew install gnu-sed`.
:::

## Basic Usage
There are many instances when we want to substitute a text in a line or filter out specific lines. In such cases, we can take advantage of `sed`. 
`sed` operates on a stream of text which it gets either from a text file or from standard input (STDIN). It means you can use the output of another command as the input of `sed` -- in short, you can combine `sed` with other commands.

By default, `sed` outputs everything to standard output (STDOUT). It means, unless redirected, `sed` will print its output to the terminal/screen instead of saving it in a file.

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

Now we'll replace 'hello' with 'world':

```bash
$ sed 's/hello/world/' input.txt
```

```bash
# Output
world world
```
