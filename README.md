# sfepy-docker
Official docker container images for [SfePy](http://sfepy.org) (Simple finite elements in Python) project.
All images are available from the Docker hub [Sfepy organization](https://hub.docker.com/u/sfepy) repositories.

## Image `sfepy-desktop`

`sfepy-desktop` is an Ubuntu based container containing a full desktop environment in officially supported flavors
accessible via any modern web browser.

All docker images are based on officially supported [Webtop](https://github.com/linuxserver/docker-webtop)
docker images from [linuxserver.io](https://www.linuxserver.io) and bootstrapped with latest
[Miniconda3](https://docs.conda.io/en/latest/miniconda.html) and
[SfePy](https://anaconda.org/conda-forge/sfepy) packages that are configured and ready to use.

The Miniconda distribution is installed into the `/opt/conda` folder and ensures that the default user has the 
`conda` command in their path and conda `base` environment is activated.

### Usage
#### Basic configuration
To get started creating container we highly recommend using `docker-compose` command with simple configuration file
`docker-compose.yml`:

```yaml
---
version: "2.1"
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
      - <path-to-sfepy-data>:/config                # <path-to-sfepy-data>:<home-dir>
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - "3000:3000"
#    devices:
#      - /dev/dri:/dev/dri                          # Linux hosts only
    shm_size: "1gb"
    restart: unless-stopped
```

Most important of above configuration you have to change is `<path-to-sfepy-data>`, which should point to your sfepy 
`<problem_description_file>` related data (we recommend use absolute path to avoid any confusion). Selected
`<path-to-sfepy-data>` is mounted as a *persistent volume* to default user's home directory (`/config`) inside running 
container.

#### Running `sfepy-desktop` container
Now you can create container (assuming your configuration file is in current directory) with

    $ docker compose up -d

and access them at:

    http://localhost:3000/

Running container can be stopped/started at any time with

    $ docker compose stop/start

Note that any modifications made previously to stopped container remains persistent until you explicitly delete the 
container. For further information see official [Docker Compose documentation](https://docs.docker.com/compose/).

### Advanced usage
There are plenty of additional parameters and fine-tuning options you can use. For official documentation, support 
and community help see [Linuxserver.io Webtop](https://github.com/linuxserver/docker-webtop/blob/master/README.md).

## Find Us

* [SfePy](http://sfepy.org)
* [SfePy mailing list](https://mail.python.org/mm3/mailman3/lists/sfepy.python.org)
* [sfepy-docker](https://github.com/sfepy/sfepy-docker)
