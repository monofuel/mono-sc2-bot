# Project

## SETUP
run `make setup` to initialize submodules and download starcraft 2 + maps + replays

## BUILD
- bare metal
    - have python3 and deps
        - `sudo apt-get install python3 python3-venv python3-pip`
    - setup python env
        - `python3 -m venv ./env`
        - `source ./env/bin/activate`
        - `python3 -m pip install -r requirements.txt`
    - add protobuf compiler
        - `sudo apt-get install protobuf-compiler`

- in docker
    - run `make docker_setup`

## RUN
not implemented yet