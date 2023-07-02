#!/bin/sh

GITLEAKS_BASE_DIR=gitleaks-precommit
GITLEAKS_REPO=https://github.com/gitleaks/gitleaks.git
REPO_DIR=gitleaks

mkdir -p $GITLEAKS_BASE_DIR
cd $GITLEAKS_BASE_DIR

if [ -d $REPO_DIR ]; then
    echo "removing existing directory '$REPO_DIR'"
    rm -rf $REPO_DIR
fi

git clone $GITLEAKS_REPO
cd $REPO_DIR
make build

chmod +x gitleaks
echo "installing gitleaks"
mv gitleaks /usr/local/bin/

cp scripts/pre-commit.py ../../.git/hooks/pre-commit
chmod +x ../../.git/hooks/pre-commit
git config --global --bool hooks.gitleaks true

echo 'gitleaks is installed'
