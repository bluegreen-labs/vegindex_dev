# Command line vegindex docker image

# Use miniconda
FROM continuumio/miniconda3

# copy package content
COPY environment.yml .

# copy processing script
COPY process_vegindex.sh .

# install libraries for common
# image format decoding etc
RUN apt-get update && apt-get install nano libgl1 \
 libavcodec-dev libavformat-dev libswscale-dev \
 libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
 libgtk2.0-dev libgtk-3-dev \
 libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev -y

# recreate and activate the environment
RUN conda env create -f environment.yml
RUN echo "source activate vegindex" > ~/.bashrc
ENV PATH=/opt/conda/envs/env/bin:$PATH
