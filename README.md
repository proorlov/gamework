gamework
========

## Разворачивание

```sh
$ git clone git@github.com:proorlov/gamework.git
$ cd gamework/
$ npm install
$ gulp
```

## Структура проекта

```

|
|-- node_modules/ - npm пакеты | должен быть добавлен в .gitignore
|
|-- pulic/
|	|
|	|-- css/ - скомпилированные файлы из /src/scss   		| должен быть добавлен в .gitignore
|	|-- js/ - скомпилированные файлы из /src/coffee			| должен быть добавлен в .gitignore
|	|-- index.html - скомпилирован из /src/haml/index.haml	| должен быть добавлен в .gitignore
|	|
|	|-- res/ - ресурсы игры
|	|-- vendor/ - внешние библиотеки
|	|-- img/ - изображения не относящиеся к игре
|
|-- src/
|	|
|	|-- coffee/ - основные файлы игры
|	|	|
|	|	|-- gamework/ - базовый функционал игры | изменять только в master ветке!
|	|	|-- simplegame/ - реализация простейшей игры | изменять только в master ветке!
|	|	|-- professions/ - реализация данной игры | должна иметь имя ветки
|	|	|-- config.coffee - конфиг игры
|	|	|-- main.coffee - инициализация игры, подключение файлов
|	|
|	|-- haml/
|	|	|
|	|	|-- index.haml
|	|
|	|-- scss/
|	|	|
|	|	|-- gamework.scss
|
|-- gulpfile.js - таски gulp
|-- package.json

```

## Build

```sh

$ gulp build
$ gulp uglify

```

После "gulp uglify" будет создан gamework.min.js в директории /public/js/build.
