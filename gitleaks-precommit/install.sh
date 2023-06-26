#!/bin/sh

mkdir gitleaks-precommit
cd gitleaks-precommit
git clone https://github.com/gitleaks/gitleaks.git
cd gitleaks
make build

echo 'gitleaks is installed'

