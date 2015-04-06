# urfantasy
Entry for the League of Legends API Challenge 2015

# Installation (URF Mode)
This repository contains a Dockerfile to build the image the web app will run in, and a docker-compose.yml file to link the dependencies:

  * Rails 4.2
  * PostgreSQL 9.4
  * Redis 2.8

## Prerequisite
Get an API key from the [Riot Games Developer] site.

## Install Docker and Docker Compose
  * [Docker]
    * If you already have Docker, be sure it's updated to v1.5.
    * If you're using [Kitematic] on OSX, use the terminal from there.
  * [Docker Compose]:
    * Linux/OSX:
            curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
            chmod +x /usr/local/bin/docker-compose
    * Windows:
        * A native version of Compose is not available, but you can try it in a [Compose Docker container].

## Setup .env file
From the project's root folder, copy the `.env.template` file to `.env` and change as necessary. Be sure to define your `RIOT_API_KEY`.

## Build
From the project's root folder, build:

    docker-compose build

After building, run it (ctrl+c to exit):

    docker-compose up

Open a separate terminal instance and run migrations:

    docker-compose run app rake db:create
    docker-compose run app rake db:migrate

Visit http://localhost:3000 to see if it's running.

## Import Process

    docker-compose run app rake urfantasy:queue_all

## Useful Commands

    # console
    docker exec -it urfantasy_app_1 rails c

    # bundle for new gems
    docker exec -it urfantasy_app_1 bundle

    # migrations
    docker exec -it urfantasy_app_1 rake db:migrate

    # postgres
    docker exec -it urfantasy_postgres_1 psql -U postgres urfantasy_dev


[Riot Games Developer]:https://developer.riotgames.com/
[Docker]:https://docs.docker.com/installation/
[Docker Compose]:https://docs.docker.com/compose/
[Kitematic]:https://kitematic.com/
[Compose Docker container]:https://registry.hub.docker.com/u/dduportal/docker-compose/