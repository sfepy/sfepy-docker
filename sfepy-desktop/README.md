# sfepy-desktop

Official Docker container images for the [SfePy](http://sfepy.org) (Simple finite elements in Python) project.

## Getting Started

`sfepy-desktop` is an Ubuntu-based container containing a full desktop environment in officially supported flavors, accessible via any modern web browser.

All Docker images are based on officially supported [Webtop](https://github.com/linuxserver/docker-webtop) Docker 
images from [linuxserver.io](https://www.linuxserver.io). They are bootstrapped with the latest [Miniforge3](https://github.com/conda-forge/miniforge)
and [SfePy](https://anaconda.org/conda-forge/sfepy) packages, which are pre-configured and ready to use. 
`sfepy-desktop` images are currently supported on `amd64` and `arm64` architectures.

The `Miniforge` distribution is installed into the `/opt/conda` folder, ensuring that the default user has the `conda` 
command in their path and the conda `base` environment is activated.

### Usage
#### Basic Configuration
To get started with creating a container, we highly recommend using the `docker-compose` command with a simple configuration file named `docker-compose.yml`:

```yaml
---
services:
  sfepy-desktop:
    image: sfepy/sfepy-desktop
    container_name: sfepy-desktop
    security_opt:
      - seccomp:unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - UMASK=022
      - TZ=Europe/Prague
      - TITLE=SfePy Desktop
    volumes:
      - <path-to-sfepy-data>:/config    # <path-to-sfepy-data>:<home-dir>
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "3000:3000"
      - "3001:3001"
    devices:
      - /dev/dri:/dev/dri               # Optional: Linux hosts only
    shm_size: "1gb"
    restart: unless-stopped
```
The most important configuration to change in the above file is `<path-to-sfepy-data>`, which should point to your
SfePy `<problem_description_file>` related data (we recommend using an absolute path to avoid any confusion).
The selected `<path-to-sfepy-data>` is mounted as a *persistent volume* to the default user's home directory (`/config`)
inside the running container.

You also should set `PUID/PGID` to match current user's `PID/GID` values.

#### Running `sfepy-desktop` container
To create the container (assuming your configuration file is in the current directory), use the following command:

    $ docker compose up -d

Access the container at:

    http://localhost:3000/

You can stop/start the running container at any time using the following commands:

    $ docker compose stop/start

Note that any modifications made to a stopped container will remain persistent until you explicitly delete the
container. For further information, see the official [Docker Compose documentation](https://docs.docker.com/compose/).

### Stopping and removing old containers

Stops containers and removes containers, networks, volumes and images created by `up`.

    $ docker compose down

### Advanced usage
There are plenty of additional parameters and fine-tuning options you can use. For official documentation, support,
and community help, please refer to
[Linuxserver.io Webtop](https://github.com/linuxserver/docker-webtop/blob/master/README.md).


## Find Us

* [SfePy](http://sfepy.org)
* [SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org)
* [sfepy-docker](https://github.com/sfepy/sfepy-docker)
