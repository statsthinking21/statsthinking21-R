# Dockerfile for ThinkStats

FROM r-base:latest

LABEL org.opencontainers.image.source="https://github.com/statsthinking21/statsthinking21-R" \
      org.opencontainers.image.vendor="Statsthinking21" \
      org.opencontainers.image.authors="Russ Poldrack <poldrack@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean all
RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove

# RUN apt-get update && apt-get install -y --no-install-recommends libcurl4-openssl-dev \
#   libssl-dev libfontconfig1-dev libxml2-dev libharfbuzz-dev libfribidi-dev \
#   libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

RUN apt-get update && apt-get install -y make git ssh jags libudunits2-0
RUN apt-get update && apt-get install -y texlive-full

# # installing R packages
# ENV R_LIBS_SITE=${R_LIBS_SITE-'/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library'}

# RUN echo 'install.packages("https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.5-4.tar.gz",\
#   repos=NULL,dependencies=TRUE)' > /tmp/packages2.R  && Rscript /tmp/packages2.R

# RUN echo 'install.packages("https://cran.r-project.org/src/contrib/Archive/lme4/lme4_1.1-34.tar.gz",\
#   repos=NULL,dependencies=TRUE)' > /tmp/packages.R  && Rscript /tmp/packages.R

RUN apt-get update && apt-get install -y r-cran-tidyverse r-cran-ggplot2 r-cran-ggfortify 

RUN apt-get update && apt-get install -y r-cran-igraph r-cran-sfsmisc r-cran-bookdown r-cran-emmeans \
  r-cran-mapproj r-cran-pwr r-cran-bayesfactor r-cran-reshape2 r-cran-brms \
  r-cran-gmodels r-cran-lsmeans cmake r-cran-nloptr pandoc r-cran-cowplot \
  r-cran-svglite r-cran-caret r-cran-multcomp r-cran-multcompview r-cran-pander \
  r-cran-bayestestr r-cran-webshot r-cran-ggdendro r-cran-psych r-cran-factoextra \
  r-cran-viridis r-cran-mclust

ADD install_lme4.R /tmp/install_lme4.R 
RUN Rscript /tmp/install_lme4.R


RUN echo 'install.packages(c( \
  "kableExtra", \
  "DiagrammeR", \
  "NHANES", \
  "pdist", \
  "janitor", \
  "fivethirtyeight", \
  "lmerTest"), \
    repos="http://cran.us.r-project.org", dependencies=TRUE)' > /tmp/packages.R && \
    Rscript /tmp/packages.R

# fiftystater was removed from CRAN so must be installed from the archive
RUN echo 'install.packages("https://cran.r-project.org/src/contrib/Archive/fiftystater/fiftystater_1.0.1.tar.gz",\
  repos=NULL,dependencies=TRUE)' > /tmp/packages2.R  && Rscript /tmp/packages2.R

# python setup for jupyter notebooks
# after https://gist.github.com/pangyuteng/f5b00fe63ac31a27be00c56996197597
ARG CONDA_VER=latest
ARG OS_TYPE=x86_64
ARG PY_VER=3.8.11

RUN apt-get update && apt-get install -yq wget jq vim
# Use the above args during building https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG CONDA_VER
ARG OS_TYPE
# Install miniconda to /miniconda
RUN wget "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh"
RUN bash Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh -p /miniconda -b
RUN rm Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

RUN pip install importlib-metadata==4.13.0 jupyter jupyterlab ipython jupyter-book \
  matplotlib seaborn numpy pandas scikit-learn nhanes jupytext

CMD ["/bin/bash"]
