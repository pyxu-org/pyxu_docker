=======================
Pyxu Docker Environment
=======================

.. contents:: Table of Contents
   :depth: 3

Introduction
============
This repository contains Docker templates to create an isolated environment for the `Pyxu
<https://pyxu-org.github.io/>`_ computational imaging framework. It allows users to run, develop, and test Pyxu
applications in a controlled and replicable setting.

The Dockerfiles provided assist in creating a Docker image that encapsulates all system dependencies and configurations
necessary to run/develop Pyxu seamlessly. CPU-only and CPU+GPU environment receipes are provided.

Prerequisites
=============
- Docker
- Nvidia Container Toolkit. (Optional; required to use GPUs inside containers.)

Building the Docker Image
=========================

.. code-block:: bash

   git clone https://github.com/pyxu-org/pyxu_docker.git
   cd ./pyxu_docker/
   git checkout <branch>  # choose receipe of interest.

   docker buildx build -t pyxu:<version> .

Running the Docker Container
============================

User Images
-----------
These containers are designed for users who want to interact with Pyxu via a notebook interface.
They install the latest version of Pyxu available on PyPI, then provide a Jupyter interface to the framework.
Launching them is a two-step process:

1. Launch the container in the background:
   use the following command to initiate the container and run it in the background:

   .. code-block:: bash

      docker run -d                          \
                 -p <host_ip>:8888           \
                 -v <host_dir>:/root/HOST/   \  # optional
                 --runtime=nvidia            \  # optional; for GPU builds only
                 --gpus all                  \  # optional; for GPU builds only
                 pyxu:<version>

   Here,

   - ``<host_dir>``: path to a host directory which you want to mount into the container.
   - ``<host_ip>``: IP address on the host from which the Jupyter server is accessible.

2. Access the Jupyter interface from a web browser at ``http://localhost:<host_ip>``.

Developer Images
----------------
These containers are designed for interactive use, mainly to develop Pyxu.
They only prepare the environment, hence developers are responsible to install Pyxu as described in the `guide
<https://pyxu-org.github.io/intro/installation.html>`_ afterwards.
Launching them is a two-step process:

1. Launch the container in the background:
   use the following command to initiate the container and run it in the background:

   .. code-block:: bash

      docker run -d                          \
                 --name <ID>                 \
                 -v <host_dir>:/root/HOST/   \  # optional
                 --runtime=nvidia            \  # optional; for GPU builds only
                 --gpus all                  \  # optional; for GPU builds only
                 pyxu:<version>

   Here,

   - ``<ID>``: A unique identifier/name for your running container.
   - ``<host_dir>``: The path to the host directory that you want to mount into the container.

2. Connect to the running container:
   execute the following command to access the container's shell interactively:

   .. code-block:: bash

      docker exec -it <ID> bash
      docker exec -it <ID> tmux  # alternative, to open a pre-existing tmux session

   Replace ``<ID>`` with the identifier/name you provided when launching the container in step 1. You should have an
   interactive shell within the running Docker container.

Example
=======
To launch a CPU-only Jupyter environment to interact with Pyxu:

.. code-block:: bash

   git clone https://github.com/pyxu-org/pyxu_docker.git && cd ./pyxu_docker/
   git checkout jupyter-cpu-ubuntu20.04

   docker buildx build -t pyxu:v1 .
   docker run -d -p 8888:8888 pyxu:v1
   firefox http://localhost:8888

To launch a CPU-only Pyxu dev container:

.. code-block:: bash

   git clone https://github.com/pyxu-org/pyxu_docker.git && cd ./pyxu_docker/
   git checkout devel-cpu-ubuntu20.04

   docker buildx build -t pyxu:v1 .
   docker run -d --name pyxu_pod pyxu:v1
   docker exec -it pyxu_pod bash


Contact
=======
- **Name:** Sepand KASHANI
- **Email:** contact@pyxu.org
