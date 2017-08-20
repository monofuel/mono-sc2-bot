# Project

## SETUP
run `make setup` to initialize submodules and download starcraft 2 + maps + replays

## BUILD
- bare metal
    - have python3 and venv
        - `sudo apt-get install python3 python3-venv`
    - setup python env
        - `python3 -m venv ./env`
        - `source ./env/bin/activate`
        - `pip install -r requirements.txt`


- in docker
    - run `make docker_setup`

## RUN
not implemented yet