FROM continuumio/miniconda
MAINTAINER Jeff Li <jeff.li@mackenzieinvestments.com>

RUN apt-get update -y
RUN pip install --upgrade pip

# install dependencies for pdf generations
RUN apt-get install -y pandoc texlive texlive-latex-extra
# install pyodbc dependenices
RUN apt-get install -y unixodbc unixodbc-dev tdsodbc freetds-dev sqsh

RUN pip install jupyter
RUN conda install -c conda-forge ipywidgets

# install tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# use bash instead of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# generate configs for jupyter
RUN jupyter notebook --generate-config --allow-root

# create kernels for jupyter
COPY environment.yml /tmp/.
RUN conda env create -f /tmp/environment.yml
RUN source activate py3 && python -m ipykernel install --user --name py3 --display-name "Python 3.6" && source deactivate py3

RUN apt-get clean
RUN rm -rf /tmp/*

EXPOSE 8888

WORKDIR /workspace

VOLUME /workspace

ENTRYPOINT ["/tini", "--"]

CMD ["jupyter", "notebook", "--allow-root", "--no-browser", "--ip=0.0.0.0"]
