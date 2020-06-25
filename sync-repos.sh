#!/bin/bash

# asusmption is that the Github is the origin remote and bitbucket is the sync remote
# remote 1: origin https://github.com/costezki/model2owl
# remote 2: synch https://citnet.tech.ec.europa.eu/CITnet/stash/scm/tedepo/owl-project.git

# anotehr assumption is that the bitbucket is only updated after the github is up to date;
# i.e. changes are commited to github and then once in a while they are forwarded to bitbucket

# recommendation on how to synchronise is covered here https://gist.github.com/derick-montague/534572db76b30d9d9fd97c10b7aaf61d

git remote -v

git checkout master
git push -u sync master
git push -u origin master
