# urfantasy
Entry for the League of Legends API Challenge 2015

# URF Installation
## Install Docker
## Install Docker Compose
    curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
### Build
    docker-compose build
    docker-compose up
    docker-compose run urfantasy rake db:create


