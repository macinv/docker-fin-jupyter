# docker-fin-jupyter

[![](https://images.microbadger.com/badges/image/macinv/fin-jupyter.svg)](https://microbadger.com/images/macinv/fin-jupyter "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/macinv/fin-jupyter.svg)](https://microbadger.com/images/macinv/fin-jupyter "Get your own version badge on microbadger.com")

[![Docker Repository on Quay](https://quay.io/repository/macinv/docker-fin-jupyter/status "Docker Repository on Quay")](https://quay.io/repository/macinv/docker-fin-jupyter)

[![Build Status](https://travis-ci.org/macinv/docker-fin-jupyter.svg?branch=master)](https://travis-ci.org/macinv/docker-fin-jupyter)

Jupyter notebook for Finance

## Run
To run with the default configuration:

    docker run -p 8888:8888 macinv/fin-jupyter

The configuration can be set by linking an external configuration file:

    docker run -p 8888:8888 -v jupyter_notebook_config.py:/jupyter/.jupyter/jupyter_notebook_config.py:ro macinv/fin-jupyter
