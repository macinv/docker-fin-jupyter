FROM continuumio/miniconda
MAINTAINER Jeff Li <jeff.li@mackenzieinvestments.com>

ARG BBG_CPP_VERSION=3.8.18.1
ARG BBG_PYTHON_VERSION=3.5.5

RUN apt-get update -y
RUN pip install --upgrade pip
RUN pip install jupyter

# install dependencies for pdf generations
RUN apt-get install -y pandoc texlive texlive-latex-extra
# install Bloomberg API dependenices
RUN apt-get install -y python-dev build-essential gcc libatlas-base-dev libfreetype6-dev libx11-dev libxft-dev
# install pyodbc dependenices
RUN apt-get install -y unixodbc unixodbc-dev tdsodbc freetds-dev sqsh

# Install Bloomberg C++ API
RUN wget --directory-prefix=/tmp/ https://bloomberg.bintray.com/BLPAPI-Stable-Generic/blpapi_cpp_$BBG_CPP_VERSION-linux.tar.gz
RUN tar -xvzf /tmp/blpapi_cpp* -C /opt
RUN mv /opt/blpapi_cpp_$BBG_CPP_VERSION/ /opt/blpapi_cpp/
ENV BLPAPI_ROOT="/opt/blpapi_cpp"
ENV LD_LIBRARY_PATH="/opt/blpapi_cpp/Linux"
RUN ldconfig

# Install Bloomberg Python API
RUN wget --directory-prefix=/tmp/ https://bloomberg.bintray.com/BLPAPI-Stable-Generic/blpapi_python_$BBG_PYTHON_VERSION.tar.gz
RUN pip install /tmp/blpapi_python_$BBG_PYTHON_VERSION.tar.gz

# install tini
ENV TINI_VERSION v0.13.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# use bash instead of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# generate configs for jupyter
RUN jupyter notebook --generate-config

# create kernels for jupyter
COPY environments/* /tmp/
RUN conda env create -f /tmp/env-py3.yml
RUN conda env create -f /tmp/env-py2.yml
RUN source activate py3 && python -m ipykernel install --user --name py3 --display-name "Python 3" && source deactivate py3
RUN source activate py2 && python -m ipykernel install --user --name py2 --display-name "Python 2" && source deactivate py2

RUN apt-get clean
RUN mv -rf /tmp/*

EXPOSE 8888

WORKDIR /workspace

VOLUME /workspace

ENTRYPOINT ["/tini", "--"]

CMD ["jupyter", "notebook"]
