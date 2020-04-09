# sfepy-docker
Experimental docker images for [SfePy](http://sfepy.org) (Simple finite elements in Python) project.
All images are available from the Docker hub 
 [Sfepy organization](https://hub.docker.com/r/sfepy/sfepy-notebook) repositories.

## Image `sfepy-notebook`

Docker image bootstrapped with official installation of 
[Miniconda3](http://conda.pydata.org/miniconda.html) and [SfePy](https://anaconda.org/conda-forge/sfepy)
package that is ready to use.

This image is intended as basic CLI to `SfePy` functionality or for testing `Jupyter notebook/JupyterLab`
interface.

#### Usage
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

##### Useful Information

* Docker container is based on `debian:buster-slim` distribution.
* Use image tag to select specific `SfePy` release.
* Inside running image you can install additional packages or change settings with `sudo`
  command (no password required). These changes are NOT persistent across multiple
  `docker run` commands (see [Docker volumes](https://docs.docker.com/storage/volumes/) for more info).
* `conda` installation prefix is  `/opt/conda`.
* `SfePy` sources can be found at `/opt/conda/lib/python3.7/site-packages/sfepy`.

#### Limitations

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

## Image `sfepy-x11vnc-desktop`

This is a Docker image for Ubuntu desktop with X11 and VNC with enhancements
on security and features:

* Accessible via standard web browser or VNC client.
* Connection is protected by a unique random password for each session.
* Supports dynamic resizing of the desktop and 24-bit true color.
* Supports Ubuntu LTS release 18.04 with very fast launching.
* Automatically shares the current work directory from host to Docker image.
* Automatically opens default browser to show running desktop.
* Official `Miniconda3` installation including `Python 3.7+` and `SfePy`.

#### Usage

To run the Docker image, first download the script 
[sfepy_x11vnc_desktop.py](https://raw.githubusercontent.com/sfepy/sfepy-docker/master/scripts/sfepy_x11vnc_desktop.py)
and save it to the working directory where you will store your codes and data.

After downloading the script, you can start the Docker image using the command:

```
python sfepy_x11vnc_desktop.py
```

This will download and run the Docker image and then launch your default web browser
to show the desktop environment. The work directory by default will be mapped to the 
`/home/sfepy/shared` directory on your host.

For additional command-line options, use the command:
```
python sfepy_x11vnc_desktop.py -h
```

##### Docker Run Parameters

Please note the "circular definition" here: you need at least basic Python installation
to run Docker image with (advanced) Python installation (Sorry ih that ;).
Of course, you can run Docker from command line, but that is really 
looong parameters line...


##### Useful Information

* All volumes mapped into this image ARE persistent across multiple
  `docker run` commands (see [Docker volumes](https://docs.docker.com/storage/volumes/) for more info).
* This image does not contain Jupyter notebook/JupyterLab components by default,
  everything else is same as for `sfepy-notebook` image.

## Find Us

* [SfePy](http://sfepy.org)
* [SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org)
* [sfepy-docker](https://github.com/sfepy/sfepy-docker)
