# sfepy-x11vnc-desktop

Experimental docker images for [SfePy](http://sfepy.org) (Simple finite elements in Python) project.

## Getting Started

This is a Docker image for Ubuntu desktop with X11 and VNC with enhancements
on security and features:

* Accessible via standard web browser or VNC client.
* Connection is protected by a unique random password for each session.
* Supports dynamic resizing of the desktop and 24-bit true color.
* Supports Ubuntu LTS release 18.04 with very fast launching.
* Automatically shares the current work directory from host to Docker image.
* Automatically opens default browser to show running desktop.
* Official `Miniconda3` installation including `Python 3.7+` and `SfePy`.


### Usage

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
to run Docker image with (advanced) Python installation (Sorry ;). Of course, you can run
Docker from command line, but there is really looong parameters line...


For further information see official [SfePy](http://sfepy.org/doc-devel/index.html#documentation) and
[Docker](https://docs.docker.com/) instructions.

## Find Us

* [SfePy](http://sfepy.org)
* [SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org)
* [sfepy-docker](https://github.com/sfepy/sfepy-docker)

