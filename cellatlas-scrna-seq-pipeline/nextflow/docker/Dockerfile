# Use an official Miniconda3 as a parent image
FROM continuumio/miniconda3

# Set environment variables
ENV NF_HOME=/opt/nextflow_template

# Create a directory for Nextflow
RUN mkdir -p $NF_HOME

# Set the working directory to /data
WORKDIR /nextflow_template

RUN conda create -n nextflow_env python=3.8 && \
    conda install -n nextflow_env -c bioconda nextflow && \
    conda install -n nextflow_env -c conda-forge jupyterlab && \
    echo "conda activate nextflow_env" >> ~/.bashrc

# Create a Conda environment and activate it
# RUN conda create -n nextflow_env python=3.8 && \
#     echo "conda activate nextflow_env" >> ~/.bashrc

# RUN conda activate nextflow_env
# # Install any Conda packages you need within the environment
# RUN conda install -c bioconda nextflow

# Install Jupyter Lab and other dependencies (if needed)
# RUN conda install -c conda-forge jupyterlab

# Copy your Nextflow script and any necessary files - this will happen with the WDL
COPY nf_processes /nextflow_template/nf_processes
COPY nf_data /nextflow_template/nf_data
COPY nf_workflow/nf_workflow_call_processes.nf /nextflow_template/nf_workflow/

# # FOR DEBUG on local machine
# Expose port 8888 for Jupyter Notebook
# EXPOSE 8888

# Start Jupyter Notebook on container startup
# CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

# OPTION 1: without wdl:
# 1. add the expose and the jupyter lab execution
# 2. docker build -t eilalan/igvf_wdl_nextflow .
# 3. docker run -it -p 8888:8888 eilalan/igvf_wdl_nextflow

# OPTION 2: with wdl:
# 1. take out the expose and the jupyter lab execution
# 2. docker build -t eilalan/igvf_wdl_nextflow .


# upload
# docker push eilalan/igvf_wdl_nextflow