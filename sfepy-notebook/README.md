# sfepy-notebook

Experimental docker images for [SfePy](http://sfepy.org) (Simple finite elements in Python) project.

## Getting Started

Docker image running `debian:buster-slima` with official installation of 
[Miniconda3](http://conda.pydata.org/miniconda.html) and [SfePy](https://anaconda.org/conda-forge/sfepy)
package that is ready to use.

This image is intended as basic CLI to `SfePy` functionality or for testing `Jupyter notebook/JupyterLab`
interface.

The `Miniconda3` (including `SfePy`) distribution is installed into `/opt/conda` folder and ensures
that the default user (`sfepy`) has the `base` conda environment activated and `conda` command is in their path.

### Usage
##### Docker Run Parameters

You can run this image interactively (`/bin/bash`) using the following command:

    docker run --rm -it -p 8888:8888 sfepy/sfepy-notebook

You can also map any local folder (e.g. including `<problem_description_file>`) to docker image path
(`/home/sfepy/data`) and run directly selected script:

    docker run --rm -it -v $(pwd):/home/sfepy/data sfepy/sfepy-notebook sfepy_run simple <problem_description_file>

Alternatively, you can start a Jupyter Notebook/JupyterLab server and interact with `SfePy` via your browser:

    docker run --rm -it -p 8888:8888 sfepy/sfepy-notebook

and from docker image prompt:

    $ jupyter notebook
or

    $ juppyter lab
    
You can then view the Jupyter notebook/JupyterLab by opening `http://127.0.0.1:8888/?token=...`
link in your browser (see more info on terminal output).

For further information see official [SfePy](http://sfepy.org/doc-devel/index.html#documentation) and
[Docker](https://docs.docker.com/) instructions.

## Find Us

* [SfePy](http://sfepy.org)
* [SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org)
* [sfepy-docker](https://github.com/sfepy/sfepy-docker)

