# For What It's URF
Created for Riot Games API Challenge, what started as a fantasy scoring
application ended up turning into a data exploration application. Rather than
using strictly familiar technologies, my duo queue partner for this project,
[dbanksdesign](https://github.com/dbanksdesign), and I also incorporated new/trendy
stuff (at least to us) such as Docker, ReactJS, D3.js, and Postgres
for JSON persistence. I plan to write a retrospective of this development
experience on [my blog](http://josephyi.com).

The goal of our application is to provide interesting information about URF without
denying our users the experience to be their own explorers. We feel that once
users get accustomed to the treemap interface, they can delight in their discoveries
and have fun reviewing the URF data. As a project, the code can be a valuable
resource to anyone trying to learn how to import, transform, and present data
by interacting with queues, the database, and the frontend stack. As for the code
itself, we don't recommend anyone using it as a template (gets bad towards deadline),
but would probably best serve as a reference for any of the technologies we're using.

# Tech Stack
  * Ruby 2.2.1
  * Rails 4.2 (JSON API)
  * Postgres (persistence, `jsonb`!)
  * Sidekiq (queueing)
  * Redis (backed Sidekiq)
  * ReactJS, Backbone, Semantic-UI, D3.js (frontend)
  * Docker (dev/prod environment)
  * Puma (rails server)
  * Nginx (reverse proxy)
  * memcached (caching)

# Backend

While it was available, the Riot API Challenge endpoint provided a randomized
list of match ids in 5 minute intervals for each region. The endpoint required
the `beginTime` parameter in Unix epoch time to the nearest 5 minutes. With a
simple queuing setup, the import process was able to fetch over 490,000 matches
as well as perform aggregations on fields of interest.

## Zilean, the Scheduler
Since the import tools were still under development after the endpoint was made
available, a Sidekiq queue was used to schedule jobs for a worker named
`Zilean` matching every possible `beginTime`. I used 1427866200..1429340400
(contest end date, but URF ended before that) in 300 second intervals with a
600 second offset (in case Riot was slow). This was, in my mind, the easiest way
reconcile everything I missed to when it finally catches up.

### Nunu, Challenge Endpoint Consumer
When a `Zilean` job runs, it delegates the consuming of the the challenge
endpoint for each region to `Nunu`, and feasting of the match ids response to
`Chogath`. All aspects of the import process were developed with idempotency in
mind, so if `Zilean` had to re-run (perhaps due to implementation changes),
checks are made between `Nunu` and `Chogath` to ensure nothing gets inserted twice.  

### Chogath, Match Endpoint Feaster
`Chogath` iterates through the list of match IDs provided by `Nunu`
and feasts on the JSON responses. The requests used to be handled one by
one, which was fine at first (or with a dev API key), but was somewhat
inefficient. The solution was to modify my Ruby gem [Taric] to handle parallel
HTTP requests, so that simultaneous requests can be made, and `Chogath` could
batch insert the responses into a `jsonb` type column in Postgres.

## Bard, the Collector
To minimize database load, a worker named `Bard` was created and scheduled to
aggregate an hours worth of data on an hourly basis. Like `Zilean`, jobs were
scheduled to cover the entire spectrum of the challenge endpoint's existence.
Unlike `Nunu` and `Chogath`, `Bard`'s job is not idempotent since aggregation
is a 'destructive' process, and there's a chance that new matches that weren't
available at request time (e.g. KR endpoint is down) become available in a rerun
of `Zilean`.

# Frontend

ReactJS touts itself as being the V of MVC, and since neither of us were familiar with one-way
data binding via Flux, Danny settled on Backbone for the routing aspect. He was able
to write React components in CoffeeScript thanks to a gem called
[sprockets-coffee-react](https://github.com/jsdf/sprockets-coffee-react). Once
he was familiar with React component development with Backbone, we agreed on the
single page application approach. With only a week left to finish the project,
we decided the fantasy application was no longer feasible (plus URF ended), but
since we had a lot of data, we decided a data exploration application would have
a better shot at being completed in time. Danny had prior experience with D3.js
and suggested a treemap overview of the aggregated data. The SQL queries were actually
pretty fast, but I stored the results in memcached anyway to keep the site running
smoothly. Danny also used Semantic-UI, which is a semantic i.e. natural language
based components framework.

# Production

I have a small VPS running on Digital Ocean, and while our application is light
enough to run off Heroku, I wanted to practice running services in Docker. I was able to
create a separate docker-compose configuration for the production environment
that gets linked to another docker-compose group of containers that has nginx.
Setting up the reverse proxy to the rails server, puma, was pretty easy, and will
be documented in [my blog](http://josephyi.com) in the near future.

# Installation (URF Mode)
This repository contains a Dockerfile to build the image the web app will run in, and a docker-compose.yml file to link the dependencies:

  * Rails 4.2
  * PostgreSQL 9.4
  * Redis 2.8
  * Sidekiq

## Prerequisite
Get an API key from the [Riot Games Developer] site.

## Install Docker and Docker Compose
  * [Docker]
    * If you already have Docker, be sure it's updated to v1.5.
    * If you're using [Kitematic] on OSX, use the terminal from there.
  * [Docker Compose]:
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

    # queuing jobs
    docker-compose run app rake urfantasy:queue_all

    # starting workers
    docker-compose -f docker-compose-zilean up

## Aggregator Process

    # queuing jobs
    docker-compose run app rake urfantasy:aggregate

    # starting workers
    docker-compose -f docker-compose-bard up

## Useful Commands

    # console
    docker exec -it urfantasy_app_1 rails c

    # migrations
    docker exec -it urfantasy_app_1 rake db:migrate

    # postgres
    docker exec -it urfantasy_postgres_1 psql -U postgres urfantasy_dev


[Riot Games Developer]:https://developer.riotgames.com/
[Docker]:https://docs.docker.com/installation/
[Docker Compose]:https://docs.docker.com/compose/
[Kitematic]:https://kitematic.com/
[Compose Docker container]:https://registry.hub.docker.com/u/dduportal/docker-compose/
[Taric]:https://github.com/josephyi/taric
