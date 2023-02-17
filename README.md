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

- Having [Okular](https://en.wikipedia.org/wiki/Okular) installed.
- Having all references named accordingly inside folders $HOME/books, $HOME/notes and $HOME/papers respectively.

## Create LaTeX documents with private GitHub repositories
The documents are created from the templates in [this repository](https://github.com/pedro-nunez/latex-templates).
The available templates are:

- **Notes**: to take notes during a talk or lecture.
- **Script**: to write scripts for talks, lectures, etc.
- **Beamer**: for beamer presentations.
- **Blurb**: for short expository notes about a specific topic. Both the name and the idea are inspired by [Keith Conrad's expository papers](https://kconrad.math.uconn.edu/blurbs/). Many thanks to him for these nice writings, I've used them many times!
- **Solutions**: to write down solutions to exercises.

For example, the command
```
$ new script title of the talk
```
will create a LaTeX document from the script template with a private GitHub repository called script-title-of-the-talk.

### Prerequisites:

- Cloning the GitHub repository [pedro-nunez/latex-templates](https://github.com/pedro-nunez/latex-templates) into a folder $HOME/git.
- Having [hub](https://github.com/github/hub) installed.
- Create a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for hub.

## Create exercise sheets with private GitHub repositories
The exercise sheets are created from a local template.
The command
```
$ sheet 2 13.05.2022
```
creates exercise sheet number 2, whose deadline is 13th of May 2022.

### Prerequisites

- Having the desired local templates for gitignore, main.tex and README.md in a folder inside $HOME/Templates. In my case they are in a folder called rf-ws-22.
- Having [hub](https://github.com/github/hub) installed.
- Create a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for hub.

## Push and pull shortcuts
These functions only make the process of pushing and pulling from GitHub a bit quicker. They should be called from the folder containing the repository's folder. For example, the command
```
$ push latex-templates updated blurb template
```
is equivalent to
```
$ cd latex-templates
$ git add .
$ git commit -m "updated blurb template"
$ git push origin master
$ cd ..
```
If no commit message is specified, "Some updates" is used by default.

## PhD updates
These are various functions to keep a journal with small updates on the various PhD projects.
For example, the command
```
$ p2
```
starts editing the journal in the current date with a tag corresponding to project number 2. If arguments are specified, then the argumets are added as a todo.txt task into the +P2 project.

### Prerequisites

- Having the LaTeX document in a repository $HOME/git/phd-2022 and probably some other similar set-up details that I am forgetting now.
- Using todo.txt for to-do lists.
