env GIT_DIR=/path/to/git/repo.git git show HEAD:filename.txt >filename.txt
git archive --remote=ssh://host/pathto/repo.git HEAD README.md | tar xO
git archive --remote=git://git.foo.com/project.git HEAD:path/to/directory filename | tar -x
$ git archive --remote=git@github.com:foo/bar.git --prefix=path/to/ HEAD:path/to/ |  tar xvf -

