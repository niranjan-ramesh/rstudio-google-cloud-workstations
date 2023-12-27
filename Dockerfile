FROM docker.io/rocker/rstudio

ENV RUNROOTLESS "true"
ENV USERID 0
ENV GROUPID 0
# Notebooks are already behind authenticated gateway.
ENV DISABLE_AUTH "true"

# Set default working directory
RUN echo "setwd(\"/home/\")" >> $R_HOME/etc/Rprofile.site

WORKDIR /home/