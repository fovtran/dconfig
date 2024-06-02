#!/bin/bash
#

curl https://api.github.com

curl --user "fovtran:asdasd" https://api.github.com/gists/starred
curl --user "fovtran:asdasd" https://api.github.com/users/fovtran

#qcurl --user "fovtran:asdasd" --request POST --data '{"description":"Created via API","public":"true","files":{"file1.txt":{"content":"Demo"}}' https://api.github.com/gists
#curl --user "fovtran:asdasd" -X POST --data '{"description":"Created via API","public":"true","files":{"file1.txt":{"content":"Demo"}}' https://api.github.com/gists

curl -u "fovtran:dasdasd" https://api.github.com/user
curl -u "fovtran:asdasd" https://api.github.com/users/fovtran/repos

curl -i "https://api.github.com/repos/vmg/redcarpet/issues?state=closed"
curl -i -u "fovtran:asdasd" -d '{"scopes":["public_repo"]}' https://api.github.com/authorizations

#Authorization token
curl -i -u fovtran -d '{"scopes": ["repo", "user"], "note": "getting-started"}' https://api.github.com/authorizations

# Authentication
#Basic
curl -u "username" https://api.github.com
# X-Header
curl -H "Authorization: token OAUTH-TOKEN" https://api.github.com
# Parameter
curl https://api.github.com/?access_token=OAUTH-TOKEN
# Key Secret
curl 'https://api.github.com/users/whatever?client_id=xxxx&client_secret=yyyy'

# create a repo
curl -i -H 'Authorization: token asdasdasdasd' \
    -d '{ \
        "name": "blog", \
        "auto_init": true, \
        "private": true, \
        "gitignore_template": "nanoc" \
      }' \
    https://api.github.com/user/repos

git init
git add .
git config --global user.email "asdasdasdasd@live.com.ar"
git config --global user.name "Diego"
git commit -am "First commit"

