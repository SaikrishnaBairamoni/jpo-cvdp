Master: [![Build Status](https://travis-ci.org/usdot-jpo-ode/jpo-cvdp.svg?branch=master)](https://travis-ci.org/usdot-jpo-ode/jpo-cvdp) [![Quality Gate](https://sonarqube.com/api/badges/gate?key=jpo-cvdp-key)](https://sonarqube.com/dashboard?id=jpo-cvdp-key)

# jpo-cvdp

The United States Department of Transportation Joint Program Office (JPO)
Connected Vehicle Data Privacy (CVDP) Project is developing a variety of methods
to enhance the privacy of individuals who generated connected vehicle data.

Connected vehicle technology uses in-vehicle wireless transceivers to broadcast
and receive basic safety messages (BSMs) that include accurate spatiotemporal
information to enhance transportation safety. Integrated Global Positioning
System (GPS) measurements are included in BSMs.  Databases, some publicly
available, of BSM sequences, called trajectories, are being used to develop
safety and traffic management applications. **BSMs do not contain explicit
identifiers that link trajectories to individuals; however, the locations they
expose may be sensitive and associated with a very small subset of the
population; protecting these locations from unwanted disclosure is extremely
important.** Developing procedures that minimize the risk of associating
trajectories with individuals is the objective of this project.

# The Operational Data Environment (ODE) Privacy Protection Module (PPM)

The PPM operates on streams of raw BSMs generated by the ODE. It determines
whether individual BSMs should be retained or suppressed (deleted) based on the
information in that BSM and auxiliary map information used to define a geofence.
BSM geoposition (latitude and longitude) and speed are used to determine the
disposition of each BSM processed. The PPM also redacts other BSM fields.

## PPM Limitations

Protecting against inference-based privacy attacks on spatiotemporal
trajectories (i.e., sequences of BSMs from a single vehicle) in **general** is
a challenging task. An example of an inference-based privacy attack is
identifying the driver that generated a sequence of BSMs using specific
locations they visit during their trip, or other features discernable from the
information in the BSM sequence. **This PPM treats a specific use case: a
geofenced area where residences do not exist, e.g., a highway corridor, with
certain speed restrictions.** Do not assume this strategy will work in general.
There are alternative strategies that must be employed to handle cases where
loitering locations can aid in learning the identity of the driver.

## Table of Contents

1. [Release Notes](#release-notes)
2. [Documentation](#documentation)
3. [Development and Collaboration Tools](#development-and-collaboration-tools)
3. [Getting Started](#getting-started)
4. [Installation](docs/installation.md)
5. [Configuration and Operation](docs/configuration.md)
6. [Testing](docs/testing.md)
7. [Development](docs/coding-standards.md)
8. [Confluent Cloud Integration](#confluent-cloud-integration)

## Release Notes

### ODE Sprint 38

- ODE-771: Fixed reported bug where the PPM exits when connections to Kafka brokers fail.

### ODE Sprint 15

- ODE-369/ORNL-15: Logging
- Updated Identifier Redactor to include random assignment in lieu of fixed assignment.

### ODE Sprint 14

- ORNL-17: USDOT Playbook

### ODE Sprint 13

- ODE-290: Integration with the ODE.

### ODE Sprint 12

- ODE-77: Complete documentation

### ODE Sprint 11

- (Partial Complete) ODE-282 Implement a Module that Interfaces with the ODE.
- (Partially Complete) ODE-77 Implement a PPM that uses a Geofence to Filter BSMs.

# Documentation

The following document will help practitioners build, test, deploy, and understand the PPM's functions:

- [Privacy Protection Module User Guide](docs/ppm_user_manual.docx)

All stakeholders are invited to provide input to these documents. Stakeholders should direct all input on this document
to the JPO Product Owner at DOT, FHWA, or JPO. To provide feedback, we recommend that you create an "issue" in this
repository (https://github.com/usdot-jpo-ode/jpo-cvdp/issues). You will need a GitHub account to create an issue. If you
don’t have an account, a dialog will be presented to you to create one at no cost.

## Code Documentation

Code documentation can be generated using [Doxygen](https://www.doxygen.org) by following the commands below:

```bash
$ sudo apt install doxygen
$ cd <install root>/jpo-cvdp
$ doxygen
```

The documentation is in HTML and is written to the `<install root>/jpo-cvdp/docs/html` directory. Open `index.html` in a
browser.

## Class Usage Diagram
![class usage](./docs/diagrams/class-usage/PPM%20Class%20Usage.drawio.png)

This diagram displays how the different classes in the project are used. If one class uses another class, there will be a black arrow pointing to the class it uses. The Tool class is extended by the PPM class, which is represented by a white arrow.

# Development and Collaboration Tools

## Source Repositories - GitHub

- https://github.com/usdot-jpo-ode/jpo-cvdp
- `git@github.com:usdot-jpo-ode/jpo-cvdp.git`

## Agile Project Management - Jira
https://usdotjpoode.atlassian.net/secure/Dashboard.jspa

## Continuous Integration and Delivery

The PPM is tested using [Travis Continuous Integration](https://travis-ci.org).

# Getting Started

## Prerequisites

You will need Git to obtain the code and documents in this repository.
Furthermore, we recommend using Docker to build the necessary containers to
build, test, and experiment with the PPM. The [Docker](#docker) instructions can be found in that section.

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com)

You can find more information in our [installation and setup](docs/installation.md) directions.

## Getting the Source Code

See the installation and setup instructions unless you just want to examine the code.

**Step 1.** Disable Git `core.autocrlf` (Only the First Time)

   **NOTE**: If running on Windows, please make sure that your global git config is
   set up to not convert End-of-Line characters during checkout. This is important
   for building docker images correctly.

```bash
git config --global core.autocrlf false
```

**Step 2.** Clone the source code from GitHub repositories using Git commands:

```bash
git clone https://github.com/usdot-jpo-ode/jpo-cvdp.git
```

# Confluent Cloud Integration
Rather than using a local kafka instance, this project can utilize an instance of kafka hosted by Confluent Cloud via SASL.

## Environment variables
### Purpose & Usage
- The DOCKER_HOST_IP environment variable is used to communicate with the bootstrap server that the instance of Kafka is running on.
- The KAFKA_TYPE environment variable specifies what type of kafka connection will be attempted and is used to check if Confluent should be utilized.
- The CONFLUENT_KEY and CONFLUENT_SECRET environment variables are used to authenticate with the bootstrap server.

### Values
- DOCKER_HOST_IP must be set to the bootstrap server address (excluding the port)
- KAFKA_TYPE must be set to "CONFLUENT"
- CONFLUENT_KEY must be set to the API key being utilized for CC
- CONFLUENT_SECRET must be set to the API secret being utilized for CC

## CC Docker Compose File
There is a provided docker-compose file (docker-compose-confluent-cloud.yml) that passes the above environment variables into the container that gets created. Further, this file doesn't spin up a local kafka instance since it is not required.

## Note
This has only been tested with Confluent Cloud but technically all SASL authenticated Kafka brokers can be reached using this method.

# Testing/Troubleshooting
## Unit Tests
Unit tests can be built and executed using the build_and_run_unit_tests.sh file inside of the dev container for the project. More information about this can be found [here](./docs/testing.md#utilizing-the-build_and_run_unit_testssh-script).

The unit tests are also built when the solution is compiled. For information on that, check out [this section](./docs/testing.md#unit-testing).

## Standalone Cluster
The docker-compose-standalone.yml file is meant for local testing/troubleshooting.

To utilize this, pass the -f flag to the docker-compose command as follows:
> docker-compose -f docker-compose-standalone.yml up

Sometimes kafka will fail to start up properly. If this happens, spin down the containers and try again.

### Data & Config Files
Data and config files are expected to be in a location pointed to by the DOCKER_SHARED_VOLUME environment variable.

At this time, the PPM assumes that this location is the /ppm_data directory. When run in a docker or k8s solution, an external drive/directory can be mounted to this directory.

In a BSM configuration, the PPM requires the following files to be present in the /ppm_data directory:
- *.edges
- ppmBsm.properties

#### fieldsToRedact.txt
The path to this file is specified by the REDACTION_PROPERTIES_PATH environment variable. If this is not set, field redaction will not take place but the PPM will continue to function. If this is set and the file is not found, the same behavior will occur.

When running the project in the provided dev container, the REDACTION_PROPERTIES_PATH environment variable should be set to the project-level fieldsToRedact.txt file for debugging/experimentation purposes. This is located in /workspaces/jpo-cvdp/config/fieldsToRedact.txt from the perspective of the dev container.

#### RPM Debug
If the RPM_DEBUG environment variable is set to true, debug messages will be logged to a file by the RedactionPropertiesManager class. This will allow developers to see whether the environment variable is set, whether the file was found and whether a non-zero number of redaction fields were loaded in.

## Build & Exec Script
The [`build_and_exec.sh`](./build_and_exec.sh) script can be used to build a tagged image of the PPM, run the container & enter it with an interactive shell. This script can be used to test the PPM in a standalone environment.

## Some Notes
- The tests for this project can be run after compilation by running the "ppm_tests" executable.
- When manually compiling with WSL, librdkafka will sometimes not be recognized. This can be resolved by utilizing the provided dev environment.

# General Redaction
General redaction refers to redaction functionality in the BSMHandler that utilizes the 'fieldsToRedact.txt' file to redact specified fields from BSM messages.

## How to specify the fields to redact
The fieldsToRedact.txt file is used by the BSMHandler and lists the paths to the fields to be redacted. It should be noted that this file needs to use the LF end-of-line sequence.

### How are fields redacted?
The paths in the fieldsToRedact.txt file area are added to a list and then used to search for the fields in the BSM message. If a member is found, the default behavior is to remove it with rapidjson's RemoveMember() function. It should be noted that by default, only leaf members are able to be removed. There are some exceptions to this which are listed in the [Overridden Redaction Behavior](#overridden-redaction-behavior) section.

## Overridden Redaction Behavior
Some values will be treated differently than others when redacted. For example, the 'coreData.angle' field will be set to 127 instead of being removed since it is a required field. The following table lists the overridden redaction behavior.

| Field | Redaction Behavior |
| --- | --- |
| angle | Set to 127 |
| transmission | Set to "UNAVAILABLE" |
| wheelBrakes | Set first bit to 1 and all other bits to 0 |
| weatherProbe | Remove object |
| status | Remove object |
| speedProfile | Remove object |
| traction | Set to "unavailable" |
| abs | Set to "unavailable" |
| scs | Set to "unavailable" |
| brakeBoost | Set to "unavailable" |
| auxBrakes | Set to "unavailable" |

### Bitstrings
Since it would be incorrect for a bitstring to be missing bits, the PPM will remove the entire bitstring if any of its bits are redacted. This is done by removing the parent object. For example, if the 'partII.value.lights.lowBeamHeadlightsOn' field is redacted, the 'partII.value.lights' object will be removed.
