[![Stories in Ready](https://badge.waffle.io/enspiral-dev-academy/curator.png?label=ready&title=Ready)](https://waffle.io/enspiral-dev-academy/curator)
# curator
Tool for building language specific curriculum readme files.
The curator can initialize a directory with given languages, say ruby and c#; this will produce a _templates directory with one template.md file, an rb directory and a cs directory:

`name_of_directory/_templates/rb/`
`name_of_directory/_templates/cs/`
`name_of_directory/_templates/template.md`

Inside each of the language directories you can put any language specific files, it gets initialized with a default file selection of code.md,links.md and text.md:

`name_of_directory/_templates/rb/code.md`

`name_of_directory/_templates/rb/links.md`

`name_of_directory/_templates/rb/text.md`


If you have a challenge that needs two separate examples of code for ruby, create a code_one.md and a code_two.md file in the rb directory and put the code you want inside each of them. Next up in the template.md put the language agnostic information, e.g the challenge name and it's brief, then to include the ruby specific code_one.md code just put `include:code_one:` on the next line. When you build curator with rb and c# it will scan the template file for `:include:*:` and then replace `:include:code_one:` with the contents of the code_one.md file from the each of language directories and create a readme-rb.md and a readme-cs.md.

Any `include:*:` in the template.md file will be replaced with the corresponding *.md file from the language directory. Note: if that file only exists in the rb directory and not in the c#, don't worry it will just leave that line blank :)

**npm install -g eda-curator**

#init

curator init < language name >

- initializes the current directory with the given languages

```
curator init rb cs js
```

- to get current available language options run **curator languages**

- creates a _template folder in current directory, with sub folders for each language, each with code, text and links files. Template.md is also created for the language agnostic readme content

```
curator init .
```

- will initialize ruby and c#



#build

curator build < language name >

- build the readmes for the given languages

```
curator build rb cs js
```

- to get current available language options run **curator languages**

- creates a _template folder in current directory, with sub folders for each language, each with code, text and links files. Template.md is also created for the language agnostic readme content

```
curator build .
```

- will build ruby and c#
