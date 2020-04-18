#!/usr/bin/env bash
set -eux -o pipefail
COVID19_FOLDER=$(cd $(dirname $0); pwd)
WEBPAGE_FOLDER=${COVID19_FOLDER}/../kwulffert.github.io
YESTERDAY=$(date -v -1d +%F)

# Update webpage git
cd ${WEBPAGE_FOLDER}
git reset --hard
git checkout master
git pull

cd ${COVID19_FOLDER}

# Update covid19 git
git reset --hard
git checkout master
git pull

# Activate virtual environment
. .venv-af/bin/activate

# Execute and convert notebooks for the worldwide and Italy analysis
jupyter nbconvert --to notebook --execute covid-19_analysis.ipynb
mv covid-19_analysis.nbconvert.ipynb covid-19_analysis.ipynb
jupyter nbconvert covid-19_analysis.ipynb --no-input --no-prompt
jupyter nbconvert --to notebook --execute covid19_italy.ipynb
mv covid19_italy.nbconvert.ipynb covid19_italy.ipynb
jupyter nbconvert covid19_italy.ipynb --no-input --no-prompt

# Copy updated notebook as html to the webpage folder
cp covid-19_analysis.html ${WEBPAGE_FOLDER}/
cp covid19_italy.html ${WEBPAGE_FOLDER}/
cp Italy_reg.png ${WEBPAGE_FOLDER}/images/

# Create branch and commit changes to master
git add covid-19_analysis.ipynb covid19_italy.ipynb
git commit -m "Update from ${YESTERDAY}"
git push origin master

# Update WEBPAGE_FOLDER
cd ${WEBPAGE_FOLDER}

# Create branch and commit changes to master
git add covid-19_analysis.html covid19_italy.html images/Italy_reg.png
git commit -m "Update from ${YESTERDAY}"
git push origin master
