# Linked Data Theatre
The Linked Data Theatre (LDT) is a platform for an optimal presentation of Linked Data

## Building
See [BUILD.md](BUILD.md) for instructions to build the Linked Data Theatre. You can also try one of the releases:

- [ldt-1.5.0.war](https://github.com/architolk/Linked-Data-Theatre/releases/download/v1.5.0/ldt-1.5.0.war "ldt-1.5.0.war")

If you want to create a new release of the ldt, please look into [BUILD-LICENSE.md](BUILD-LICENSE.md) for instructions to create the approriate license headers.

## Tomcat deployment
To deploy the Linked Data Theatre in a tomcat 7 container, follow the instructions in [DEPLOY.md](DEPLOY.md).

## Docker deployment
See instructions in [DOCKER.md](DOCKER.md)

## Configuration
The Linked Data Theatre uses a configuration graph containing all the triples that make up the LDT configuration. Instructions and examples how to create such a configuration can be found at the [wiki](https://github.com/architolk/Linked-Data-Theatre/wiki).

## Post-installation
You can check whether the Linked Data Theatre is running on:
[your-host]:8080/version