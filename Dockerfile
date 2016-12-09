FROM continuumio/anaconda
MAINTAINER Jeff Li <jeff.li@mackenzieinvestments.com>

ENV JUPYTER_HOME /home/jupyter

ARG user=jupyter
ARG group=jupyter
ARG uid=1000
ARG gid=1000

# run the jupyter notebook with user `jupyter`, uid = 1000
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JUPYTER_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

VOLUME $JUPYTER_HOME

ARG BBG_CPP_VERSION=3.8.18.1
ARG BBG_PYTHON_VERSION=3.5.5

RUN apt-get update -y
RUN pip install --upgrade pip

# install dependencies for pdf generations
RUN apt-get install pandoc texlive texlive-latex-extra -y
# install Bloomberg API dependenices
RUN apt-get install -y python-dev build-essential gcc libatlas-base-dev libfreetype6-dev libx11-dev
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

# use bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

USER ${user}
# generate configs for jupyter
RUN jupyter notebook --generate-config

USER root
# create kernels for jupyter
COPY environments/* /tmp/
RUN conda env create -f /tmp/env-py3.yml
RUN conda env create -f /tmp/env-py2.yml
USER ${user}
RUN source activate py3 && python -m ipykernel install --user --name py3 --display-name "Python 3" && source deactivate py3
RUN source activate py2 && python -m ipykernel install --user --name py2 --display-name "Python 2" && source deactivate py2

EXPOSE 8888

WORKDIR $JUPYTER_HOME

ENTRYPOINT ["/tini", "--"]

CMD ["jupyter", "notebook"]
