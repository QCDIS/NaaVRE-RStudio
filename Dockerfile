FROM jupyter/r-notebook 
# or datascience-notebook

# install nbrsessionproxy extension
RUN conda install -yq -c conda-forge jupyter-rsession-proxy && conda clean -a

# install rstudio-server
USER root
RUN apt-get update && \
    curl --silent -L --fail https://download2.rstudio.org/server/focal/amd64/rstudio-server-2024.09.1-394-amd64.deb > /tmp/rstudio.deb && \
    echo '42243a86bd59bfa306feb7dbc2fb9c507f0c03e44621280cd0887dad58fb0185 /tmp/rstudio.deb' | sha256sum -c - && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    apt-get install -y libxml2-dev && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean
ENV PATH=$PATH:/usr/lib/rstudio-server/bin

# install RStudio extension CellContainerizer
COPY component.containerizer_0.0.5.tar.gz .
RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' > ~/.Rprofile
RUN Rscript -e "install.packages('devtools', lib=.Library)"
RUN Rscript -e "devtools::install_local('$PWD/component.containerizer_0.0.5.tar.gz', lib=.Library)"
