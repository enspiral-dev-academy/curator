[![Stories in Ready](https://badge.waffle.io/enspiral-dev-academy/curator.png?label=ready&title=Ready)](https://waffle.io/enspiral-dev-academy/curator)
# curator
tool for building curriculum

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

- will initialize all currently available languages



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

- will build all currently available languages
