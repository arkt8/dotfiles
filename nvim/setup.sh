#!/bin/bash
extdir=$HOME/.local/share/nvim-ext

# Babel minify for Javascript
mkdir -p "$extdir/js"
cd "$extdir/js"
npm init --force -y
npm install babel-minify

# Php Stan
mkdir -p "$extdir/php"
cd "$extdir/php"
composer require phpstan/phpstan
composer install
