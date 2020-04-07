# sfepy-notebook

Experimental docker containers for [SfePy](http://sfepy.org) (Simple finite elements in Python) project.

## Getting Started

Docker container with a bootstrapped installation of official [Miniconda](http://conda.pydata.org/miniconda.html)
(based on Python 3.7) and [SfePy](https://anaconda.org/conda-forge/sfepy) releases that is ready to use.

The `Miniconda` distribution is installed into `/opt/conda` folder and ensures that the default user (`sfepy`) has
the `base` conda environment activated and `conda` command is in their path.

### Usage

#### Container Parameters

You can run this image interactively using the following command:

    docker run --rm -it -p 8888:8888 sfepy/sfepy-notebook

You can also map any local folder (including `<problem_description_file>`) to docker image `/data` path and
run directly selected `SfePy` script (e.g. `simple.py`):

    docker run --rm -it -v $(pwd):/hoem/sfepy/data sfepy/sfepy-notebook sfepy_run simple <problem_description_file>

Alternatively, you can start a Jupyter Notebook/Lab server and interact with `SfePy` via your browser:

    docker run --rm -it -p 8888:8888 sfepy/sfepy-notebook

and from docker image prompt:

    $ jupyter notebook
or

    $ juppyter lab
    
You can then view the Jupyter notebook/lab by opening `http://127.0.0.1:8888/?token=...` link in your browser.

## Find Us

* [SfePy](http://sfepy.org)
* [SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org)
* [sfepy-docker](https://github.com/sfepy/sfepy-docker)

