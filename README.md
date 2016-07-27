# LemonLDAP::NG in Docker

## Build the image

Designed to be used as a base image, you must provide your own Dockerfile. A minimal one can contain just the FROM instruction.

You must provide a lmConf-1.js file and set the base domain name the server will listen to with the variable SSODOMAIN.

Use the docker build command:

    docker build --build-arg SSODOMAIN=example.com -t yourname/lemonldap-ng:version .

Or use the arg option in your docker-compose.yml file (https://docs.docker.com/compose/compose-file/#/args).
