---
pagetitle: "The Unix Shell: sed - stream editor"
---

# The Unix Shell: `sed` - stream editor


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

Now we'll use `sed` replace 'hello' with 'world':

```bash
$ sed 's/hello/world/' input.txt  
```

```bash
# Output
world world
```
Just follow this tutorial we will explain all the magic which just happened.

## `sed` script commands

Let's take a closer look at the `sed` script command. In the above script (`s/hello/world`), 's' is called the `sed` command. There are many `sed` commands, but we mainly focus on the 's' command. To see a list of all `sed` commands, visit [https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html](https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html).

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

A regular expression is a pattern formed in a standardised way that helps search in a string. Regular expressions are useful for matching common patterns of string such as email addresses, phone numbers, URLs, etc. To learn more visit: [https://cheatography.com/davechild/cheat-sheets/regular-expressions/](https://cheatography.com/davechild/cheat-sheets/regular-expressions/)
:::

The third one is the replacement. So, if `sed` finds the match, it will replace the matched text/pattern with the replacement text.

So, the basic concept of the 's' command is: it attempts to match the pattern in a line, if the match is successful, then that portion of the pattern is replaced with *replacement*.

At the last of the 's' command, you can see [flags]. [flags] are optional. An 's' command can have zero or more flags. Some of the common flags are:

- **g**: By default `sed` command will only substitute the first match. If the line has more than one match, all will not get replaced. It replaces only the first match. But, if we use the **g** flag, then the `sed` command will replace all matching text.

- **i**:  `sed` matches the regular expression in a case-sensitive manner. It means 'A' (Uppercase A) and 'a' (Lowercase A) are different. But, if we use the **i** flag, then the `sed` will match the regular expression in a case-insensitive manner. This means now the `sed` will treat 'A' and 'a'.

To learn more about the 's' command visit [https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html](https://www.gnu.org/software/sed/manual/html_node/The-_0022s_0022-Command.html).


## Using the 's' command

Let's go back to our first example.
```bash
$ sed 's/hello/world' input.txt
```
Now it is clear what is happening. The `sed` is substituting 'hello' with 'world' at every line. And we are getting the input from a file called 'input.txt'.

Create a new file 'input2.txt' and write the following text in it:

```txt
Hello, this is a test line. This is a very short line.
This is test line two. In this line, we have two occurrences of the test.
This line has many occurrences of the Test with different cases. test tEst TesT.
```

Now try to replace 'test' with 'hello'. We can do something like this:

```bash
$ sed 's/test/hello/' input2.txt
```

```output
Hello, this is a hello line. This is a very short line.
This is hello line two. In this line, we have two occurrences of the test.
This line has many occurrences of the Test with different case. hello tEst TesT.
```

You may have noticed that lines two and three still have 'test'. This is because we ask the `sed` to only replace the first text which matches. To replace all the matches, we have to use **g** flag. Let's try with **g** flag.


```bash
$ sed 's/test/hello/g' input2.txt
```

```output
Hello, this is a hello line. This is a very short line.
This is hello line two. In this line, we have two occurrences of the hello.
This line has many occurrences of the Test with different case. hello tEst TesT.
```

Ah, something is still wrong with the third line. It is not replacing 'Test', 'tEst' and 'TesT'. We have to do something to tell the `sed` that we want to replace all of them. We can do this by using **i** flag. Let's add one more flag:

```bash
$ sed 's/test/hello/gi' input2.txt
```

```output
Hello, this is a hello line. This is a very short line.
This is hello line two. In this line, we have two occurrences of the hello.
This line has many occurrences of the hello with different case. hello hello hello.
```

Wonderful! 

Let's say now we only want to replace all the occurrences of the 'test' at only line 3 or from line 2 to 3. Try to remember the basic syntax for the `sed` command. Remember! You can add the address of the line or a range of lines that you want to edit. Here is an example:

```bash
$ sed '3s/test/hello/gi' input2.txt
```

```output
Hello, this is a test line. This is a very short line.
This is test line two. In this line, we have two occurrences of the test.
This line has many occurrences of the hello with different case. hello hello hello.
```

See only the third line is executed by the `sed`. The first two lines are as it is. At the beginning of the 's' command, we are adding the line number which we want to edit. We can also add a range of lines. Here is one more example:


```bash
$ sed '2,3s/test/hello/gi' input2.txt
```

As you may have got the idea, it will edit lines 2 and 3. The output will be:

```output
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
Hello, this is a  world. This is a very short world.
This is  world two. In this world, we have two occurrences of the .
This world has many occurrences of the  with different case.   .
```

## Escape character

An escape character is a character that invokes an alternative interpretation of the following character. Sometimes it is also used to insert unallowed characters in a string. An escape character is a backslash '\' followed by a character (or characters).

Let's try to understand this with examples. For this tutorial, create a file 'input3.txt' and put the following text in it:
```
This software/application is a part of this workshop.
```

Now, what if we want to replace 'software/application' with 'material'. If we try to do something like: `sed 's/software/application/material/' input3.txt`, the `sed` will throw an error. Because '/' is a delimiter, sed will think it has to replace 'software' with 'application' but, why there is a third option. To solve this error, we have to escape one '/', we can do this by adding a '\' in front of '/'. It will tell the `sed` not to interpret '/' as a special character.

```bash
$ sed 's/software\/application/material/' input3.txt
```

```output
This material is a part of this workshop.
```

There is also another use of escape character. It provides a way of encoding non-printable characters in patterns in a visible manner. There is no restriction on the appearance of non-printing characters in the `sed` script. But, it is usually easier to use escape characters than the binary character it represents. The list of commonly used escape characters in the `sed` is as follows:

- `\n`: a newline.
- `\r`: a carriage return.
- `\t`: a horizontal tab.

For more details visit [https://www.gnu.org/software/sed/manual/sed.html#Escapes](https://www.gnu.org/software/sed/manual/sed.html#Escapes).
