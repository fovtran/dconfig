#!/bin/bash

curl -i -u "fovtran:CTBg5\`MSop|t" \
   -d '{ \
        "name": "blog", \
        "auto_init": true, \
        "private": true, \
        "gitignore_template": "nanoc" \
      }' \
    https://api.github.com/user/repos

git init
git add .
git config --global user.email "dcadogan@live.com.ar"
git config --global user.name "Diego Cadogan"
git commit -am "First commit"

client_id=b16a27a36cc2e8f9c557

ghp_mBkypLB81CUx7nNabW2c4fAUUaqStwOfIekE

curl -v -i -u "fovtran:CTBg5\`MSop|t" -c /tmp/cookiejar -d '{"scopes": ["public_repo"]}' https://github.com/authorization


