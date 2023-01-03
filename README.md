# Tharsis all-in-one Docker

A Dockerfile that embeds all the dependencies needed to run [Tharsis API](https://gitlab.com/infor-cloud/martian-cloud/tharsis/tharsis-api) with the main purpose of making testing easier. Orchestrates everything with Supervisord.

Docker image includes:  
 - [Minio](https://min.io/) - object storage
 - [Keycloak](https://www.keycloak.org/) - identity provider IDP
 - [Postgresql](https://www.postgresql.org/) - database
 - [Supervisord](http://supervisord.org/) - process controller

**Warning: This image is NOT meant for production use! It should only be used for testing!**

## Get started

Either this repository can be cloned to build an image locally or one can be obtained from the [container registry](https://gitlab.com/infor-cloud/martian-cloud/tharsis/tharsis-all-in-one-docker/container_registry).

## Security

If you've discovered a security vulnerability in the Tharsis all-in-one Docker, please let us know by creating a **confidential** issue in this project.

## Statement of support

Please submit any bugs or feature requests for Tharsis. Of course, MR's are even better. :)

## License

Tharsis all-in-one Docker is distributed under [Mozilla Public License v2.0](https://www.mozilla.org/en-US/MPL/2.0/).
