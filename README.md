[![Stories in Ready](https://badge.waffle.io/enspiral-dev-academy/curator.png?label=ready&title=Ready)](https://waffle.io/enspiral-dev-academy/curator)
##curator

**npm install -g eda-curator**

Tool for building language specific curriculum readme files for challenge repos.

The curator can initialize a directory with given languages, say ruby and c#; this will produce a _templates directory with one template.md file, an rb directory and a cs directory:

`name_of_directory/_templates/rb/`

`name_of_directory/_templates/cs/`

`name_of_directory/_templates/template.md`

Inside each of the language directories you can put any language specific files, it gets initialized with a default file selection of code.md,links.md and text.md:

`name_of_directory/_templates/rb/code.md`

`name_of_directory/_templates/rb/links.md`

`name_of_directory/_templates/rb/text.md`


If you have a challenge that needs two separate examples of code, one for ruby and one for c#, put the code you want for each inside the `name_of_directory/_templates/rb/code.md` and `name_of_directory/_templates/cs/code.md`.

Next up in the template.md put the language agnostic information, e.g the challenge name and it's brief.

To include the language specific code that you put into the code.md files just put `include:code:` on the next line. When you build curator with rb and c# it will scan the template file for `include:*:`, create a readme-rb.md and a readme-cs.md and then replace `include:code:` with the contents of the `name_of_directory/_templates/rb/code.md` file and copy that into the readme-rb.md file and the same for c# into the readme-cs.md.

Any `include:*:` in the template.md file will be replaced with the corresponding *.md file from the language directory. If you have multiple code examples or language specific text for the challenge then just create a file for each one in the language directory and put include:< file name >: in the template.md file. 


Note: if you have `include:code_one:` and `include:code_two:` and one of the languages only has code_one.md, don't worry it will just replace `include:code_two:` with a blank :)


##init

curator init < language name >

- run from the root directory of a repo

- initializes the current directory with the given languages

```
curator init rb cs js
```

- to get current available language options run **curator languages**

- creates a _template folder in current directory, with sub folders for each language, each with code, text and links files. template.md is also created for the language agnostic readme content

```
curator init -A
```

- initializes ruby and c#


##build

curator build < language name >

- run from the root directory of a repo

- build the readmes for the given languages

```
curator build rb cs js
```

- to get current available language options run **curator languages**

- creates a readme-rb.md file, a readme-cs.md file and a readme-js.md file with their language specific content scraped from the relevant language directory. Also creates a README.md file with links to the language specific readmes.

- **warning** be careful not to run curator build straight after curator init or before you have inserted the correct data into the template.md and relevant language directories and files; it will override the existing readme with links to the individual readmes.

```
curator build -A
```

- builds ruby and c#
