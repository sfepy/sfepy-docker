# sfepy-docker
Experimental docker containers for [SfePy](http://sfepy.org) (Simple finite elements in Python) project.
All containers are available from the Docker hub 
 [Sfepy organization](https://hub.docker.com/r/sfepy/sfepy-notebook) repositories.

## sfepy-notebook container

Docker container with a bootstrapped installation of official [Miniconda](http://conda.pydata.org/miniconda.html)
(based on Python 3.7) and [SfePy](https://anaconda.org/conda-forge/sfepy) releases that is ready to use.

The `Miniconda` distribution is installed into `/opt/conda` folder and ensures that the default user (`sfepy`) has
the `base` conda environment activated and `conda` command is in their path.

### Usage

#### Container Parameters

You can run this container interactively using the following command:

    docker run --rm -it -p 8888:8888 sfepy/sfepy-notebook

You can also map any local folder (including `<problem_description_file>`) to docker container and
run directly selected `SfePy` script (e.g. `simple.py`):

    docker run --rm -it -v $(pwd):/home/sfepy/data sfepy/sfepy-notebook sfepy_run simple <problem_description_file>

Alternatively, you can start a Jupyter Notebook/Lab server and interact with `SfePy` via your browser:

    docker run --rm -it -p 8888:8888 sfepy/sfepy-notebook

and from docker container prompt:

    $ jupyter notebook

or (experimental)

    $ juppyter lab
    
You can then view the Jupyter notebook/lab by opening `http://127.0.0.1:8888/?token=...` link in your browser.

For further information see official [SfePy](http://sfepy.org/doc-devel/index.html#documentation) and
[Docker](https://docs.docker.com/) instructions.

#### Useful File Locations

* `/opt/conda` - `conda` installation prefix 
* `/opt/conda/lib/python3.7/site-packages/sfepy` - `SfePy` sources

## Built With

* Docker container is based on `debian:buster-slim`. You can install additional packages or change settings with `sudo`
  command (no password required).

## Limitations

* Containers are still experimental and early stage development. Please use them with caution and forgiveness,
* containers are **not** size optimized (~2GB) and the pull may take some time,
* only limited set of optional `SfePy` components (e.g. no MPI, IGA) is included,
* no graphical functions displaying visualization are supported from shell prompt inside docker container,
  but you still can do something:
  
  * run computations in "headless" mode:

        $ sfepy-run postproc data.vtk -o data.png -n
  
  * embed interactive `mayavi` 3D plotting into Jupyter notebook:
  
        from mayavi import mlab
        mlab.init_notebook()
        mlab.test_contour3d()


## Find Us

* [SfePy](http://sfepy.org)
* [SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org)
* [sfepy-docker](https://github.com/sfepy/sfepy-docker)
