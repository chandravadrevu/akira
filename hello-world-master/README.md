[![Build Status](https://travis-ci.org/chouseknecht/hello-world.svg)](https://travis-ci.org/chouseknecht/hello-world)

# Hello World

A simple example project for [Ansible Container](https://github.com/ansible/ansible-container).

## Prerequisites

- [Ansible Container 0.9.2+](http://docs.ansible.com/ansible-container/installation.html)
- Access to a Docker daemon

## Run it!

The following script will download this project from Galaxy, build the container, and run it locally, exposing the flask server on host port 4000:

```
#!/bin/bash
# Create a new directory, and set it as your working dir
mkdir hello-world
cd hello-world 

# Download the project
ansible-container init ansible.hello-world

# Build the container
ansible-container build 

# Run hello world
ansible-container run

# Open a browser and load http://localhost:4000
open http://localhost:4000

```

## Deploy It!
TODO

## Tear it down

When you're ready to remove the *hello-world* containers and images from your local Docker daemon, run the following from within the *hello-world* directory:

```
ansible-container destroy
```

## Authors

Taken from [j00bar's ](https://github.com/j00bar) AnsibleFest San Francisco 2017 [presentation](https://www.ansible.com/ansiblefest). Thanks @j00bar!

## License

[Apache V2](https://www.apache.org/licenses/LICENSE-2.0)
