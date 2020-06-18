Wetty GeoServer Shell
=====================
Wetty Geoserver Shell is simply an integration of 2 projects in a Docker image that will allow you to run Geoserver Shell in a browser tab.

It's an attempt to enable some kind of Geoserver CLI tool as a Web tool, that allows to play with Geoserver API easily. 
Geoserver-shell provides the access as a CLI tool while Wetty provides the "web" capability (exposing SSH in a browser tab). So, if you execute a docker container with Wetty-Geoserver-Shell then you will be able to run geoserver-shell scripts from inside your own docker(s) deployment, no need to do it with SSH.

Build
-----

Important note::

building this docker image implies a dependence on this project https://github.com/jemacchi/geoserver-shell fork, since the geoserver-shell repo was not working using latest changes on Geoserver API (ie. with Geoserver 2.16.2 it was failing, so I needed to adjust some calls) and also because in that fork, it's included the Dockerfile that allows to build a Docker image with Geoserver-shell.

Clone the repository::

    git clone https://github.com/jemacchi/wetty-geoserver-shell.git

Build the docker image::

    sudo ./build.sh

Then::

1. Create a docker container as follow:
    docker run -it -d --publish=3000:3000 --name wetty-gsshell jemacchi/wetty-geoserver-shell:1.0
2. Open localhost:3000 in a browser
3. Log with user: gsshell and pass: geoserver
4. Execute ./start-gsshell.sh command (that will start Geoserver-shell console)
5. Enjoy geoserver-shell from web! (connect to you preferred geoserver instance and start working with the Geoserver API)
