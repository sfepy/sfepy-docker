# sfepy-docker
Experimental docker images for [SfePy](http://sfepy.org) (Simple finite elements in Python) project. All images
 are available from the Docker Hub 
 [Sfepy organization repositories](https://hub.docker.com/r/sfepy/sfepy-notebook).

# sfepy-notebook image

Docker container with a bootstrapped installation of official [Miniconda](http://conda.pydata.org/miniconda.html)
(based on Python 3.7) and [SfePy](https://anaconda.org/conda-forge/sfepy) releases that is ready to use.

The `Miniconda` distribution is installed into `/opt/conda` folder and ensures that the default user (`sfepy`) has
the `base` conda environment activated and `conda` command is in their path.

__Caution:__ this image is NOT size optimized (~2GB) and the pull may tike some time...

## Usage

You can pull image from Docker hub or just run this image interactively using the following command:

    docker run --rm -it -p 8888:8888 kejzlar/sfepy-notebook

You can also map any local folder (including `<problem_description_file>`) to docker image `/data` path and
run directly selected `SfePy` script (e.g. `simple.py`):

    docker run --rm -it -v $(pwd):/hoem/sfepy/data kejzlar/sfepy-notebook sfepy_run simple <problem_description_file>

Alternatively, you can start a Jupyter Notebook/Lab server and interact with `SfePy` via your browser:

    docker run --rm -it -p 8888:8888 kejzlar/sfepy-notebook

and from docker image prompt:

    $ jupyter notebook
or

    $ juppyter lab
    
Then open the Jupyter Notebook/Lab by opening `http://127.0.0.1:8888/?token=...` in your browser.

For further information see official [SfePy](http://sfepy.org/doc-devel/index.html#documentation) and
[Docker](https://docs.docker.com/) instructions.

## Installation and Limitations
### Installation

* Docker image is based on `debian:buster-slim`. You can install additional packages or change settings with `sudo`
  command (no password required),
* `conda` packages are installed into `/opt/conda` with user privileges, so you can install any package of your choice,
* `SfePy` sources can be found at `/opt/conda/lib/python3.7/site-packages/sfepy`.

### Limitations

* These images are still experimental and early stage development. Please use them with caution and forgiveness,
* only limited set of optional `SfePy` components (e.g. no MPI, IGA) is currently included,
* currently no graphical functions displaying visualization are supported from shell prompt inside docker image,
  but you still can:
  * run any computation in "headless" mode:

        $ sfepy-run postproc cylinder.vtk -o cylinder.png -n
  
  * embed interactive `mayavi` 3D plotting into Jupyter notebook:
  
        from mayavi import mlab
        mlab.init_notebook()
        mlab.test_contour3d()


__Contact:__ Please send any suggestions, comments or questions to 
[SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org). Any contributions are welcome at
[sfepy-docker](https://github.com/sfepy/sfepy-docker) on Github.