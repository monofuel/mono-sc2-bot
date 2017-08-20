
setup: setup_git cache/SC2.3.16.1.zip cache/Ladder2017Season1.zip cache/3.16.1-Pack_1-fix.zip

setup_git:
	git submodule init
	git submodule update

cache/SC2.3.16.1.zip:
	cd cache && wget http://blzdistsc2-a.akamaihd.net/Linux/SC2.3.16.1.zip

cache/Ladder2017Season1.zip:
	cd cache && wget http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season1.zip

cache/3.16.1-Pack_1-fix.zip:
	cd cache && wget http://blzdistsc2-a.akamaihd.net/ReplayPacks/3.16.1-Pack_1-fix.zip

freeze:
	# work around bug
	pip freeze | grep -v 'pkg-resources==0.0.0' > requirements.txt

py_compile: protos
	python -m py_compile ./ai/main.py

lint:
	flake8 ./ai/

protos: setup_git
	protoc -I=./s2client-proto/ --python_out=./ai ./s2client-proto/s2clientprotocol/*.proto

docker_setup:
	docker-compose build

