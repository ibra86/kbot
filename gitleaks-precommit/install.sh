#!/bin/sh

GITLEAKS_BASE_DIR=gitleaks-precommit

mkdir $GITLEAKS_BASE_DIR
cd $GITLEAKS_BASE_DIR
git clone https://github.com/gitleaks/gitleaks.git
cd gitleaks
make build

mkdir $GITLEAKS_BASE_DIR/bin
PATH=$GITLEAKS_BASE_DIR/bin:$PATH

# add githook pre-commit
# add option: git config --bool hooks.gitleaks

echo 'gitleaks is installed'

