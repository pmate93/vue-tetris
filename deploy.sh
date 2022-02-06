#!/usr/bin/env sh

set -e

npm run build

cd dist

git init
git add -A
git commit -m 'deployment'
git push -f https://github.com/pmate93/vue-tetris.git master:gh-pages

cd -