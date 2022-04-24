# Bash functions

## Open references
Open a book, lecture notes or a paper using their biblatex alphabetic style citation. For example,
```
$ b har77
```
would open the book published by Hartshorne in 1977. If there are several options available, say
```
$ p ser55
```
for a paper published by Serre in 1955, then the output will say so and give the list of all available options.

### Prerequisites:

- Having all references named accordingly inside folders $HOME/books, $HOME/notes and $HOME/papers respectively.

## Create LaTeX documents with GitHub repositories
The documents are created from the templates in [this repository](https://github.com/pedro-nlb/latex-templates).
The available templates are:

- **Notes**: to take notes during a talk or lecture.
- **Script**: to write scripts for talks, lectures, etc.
- **Beamer**: for beamer presentations.
- **Blurb**: for short expository notes about a specific topic. Both the name and the idea are inspired by [Keith Conrad's expository papers](https://kconrad.math.uconn.edu/blurbs/). Many thanks to him for these nice writings, I've used them many times!
- **Solutions**: to write down solutions to exercises.

### Prerequisites:

- Cloning the GitHub repository [pedro-nlb/latex-templates](https://github.com/pedro-nlb/latex-templates) into a folder $HOME/git.
- Having [hub](https://github.com/github/hub) installed.
- Create a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for hub.

## Create exercise sheets with GitHub repositories
The exercise sheets are created from a local template.
The command
```
$ sheet 2 13.05.2022
```
creates exercise sheet number 2, whose deadline is 13th of May 2022.

### Prerequisites

- Having the local desired templates for gitignore, main.tex and README.md in a folder inside $HOME/Templates. In my case they are in a folder called eg-ss-22.
- Having [hub](https://github.com/github/hub) installed.
- Create a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for hub.
