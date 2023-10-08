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
necessary to run Pyxu seamlessly. CPU-only and CPU+GPU environment receipes are provided.

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

   docker buildx build -t pyxu-env:<version> .

Running the Docker Container
============================
The container is designed for interactive use. Launching it involves a two-step process:

1. Launch the container in the background:
   use the following command to initiate the container and run it in the background:

   .. code-block:: bash

      docker run -d                          \
                 --name <ID>                 \
                 -v <host_dir>:/root/HOST/   \  # optional
                 --runtime=nvidia            \  # optional; for GPU builds only
                 --gpus all                  \  # optional; for GPU builds only
                 pyxu-env:<version>

   Here,

   - ``<ID>``: A unique identifier/name for your running container.
   - ``<host_dir>``: The path to the host directory that you want to mount into the container.

2. Connect to the running container:
   execute the following command to access the container's shell interactively:

   .. code-block:: bash

      docker exec -it <ID> bash
      docker exec -it <ID> tmux  # alternative, to open a pre-existing tmux session

   Replace ``<ID>`` with the identifier/name you provided when launching the container in step 1. You should have an
   interactive shell within the running Docker container. Simultaneous connections are possible.

Example
=======
To create/launch a CPU-only Pyxu container:

.. code-block:: bash

   git clone https://github.com/pyxu-org/pyxu_docker.git && cd ./pyxu_docker/
   git checkout devel-cpu-ubuntu20.04

   docker buildx build -t pyxu-env:v1 .
   docker run -d --name my_pyxu_env pyxu-env:v1
   docker exec -it my_pyxu_env bash

Note that these Docker receipes merely create the *environment* to run Pyxu: the user is still responsible to install
Pyxu as described in the `guide <https://pyxu-org.github.io/intro/installation.html>`_.

Contact
=======
- **Name:** Sepand KASHANI
- **Email:** contact@pyxu.org
