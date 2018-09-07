# docker-fin-jupyter

[![](https://images.microbadger.com/badges/image/macinv/fin-jupyter.svg)](https://microbadger.com/images/macinv/fin-jupyter "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/macinv/fin-jupyter.svg)](https://microbadger.com/images/macinv/fin-jupyter "Get your own version badge on microbadger.com")

[![Docker Repository on Quay](https://quay.io/repository/macinv/fin-jupyter/status "Docker Repository on Quay")](https://quay.io/repository/macinv/fin-jupyter)

[![Build Status](https://travis-ci.org/macinv/docker-fin-jupyter.svg?branch=master)](https://travis-ci.org/macinv/docker-fin-jupyter)

Jupyter notebook for Finance

## Pre-built kernel

* Python 3.6

This kernel comes with the following packages preinstalled:
- pandas
- blpapi (Bloomberg Open API)
- numpy
- scipy
- scikit-learn
- requests
- beautifulsoup4
- pymongo
- statsmodels
- lz4
- matplotlib
- ipython
- ipykernel 
- ipywidgets

## Also installed

* blpapi c++ and Python in conda's root environment
* depedencies for exporting notebooks as pdf files

## Run
Jupyter runs on 8888 by default, to run it with the default configurations:

    docker run -p 8888:8888 macinv/fin-jupyter

The configuration can be set by linking an external configuration file:

    docker run -p 8888:8888 -v jupyter_notebook_config.py:/jupyter/.jupyter/jupyter_notebook_config.py:ro macinv/fin-jupyter

Alternatively, override the configurations by running the command:

    docker run -p 9999:9999 -v macinv/fin-jupyter jupyter notebook --ip="*" --port=9999 --no-browser
