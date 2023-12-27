FROM docker.io/rocker/rstudio

ENV RUNROOTLESS "true"
# Set default working directory
ENV EDITOR_FOCUS_DIR "/home/"
RUN mkdir -p "$EDITOR_FOCUS_DIR"
