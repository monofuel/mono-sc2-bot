
setup: fixCacheTimestamps setup_git unpack

setup_git:
	git submodule init
	git submodule update

unpack:	cache/StarCraftII cache/Ladder2017Season1 cache/Replays
	cp -r cache/Ladder2017Season1/* cache/StarCraftII/Maps/
	cp -r cache/Replays cache/StarCraftII/
	cp -r cache/Battle.net cache/StarCraftII/

fixCacheTimestamps:
	# hack to update timestamp from CI cache
	if [ ! -f cache/StarCraftII ]; then touch cache/StarCraftII; fi
	if [ ! -f cache/StarCraftII ]; then touch cache/Ladder2017Season1; fi

cache/StarCraftII: cache/SC2.3.16.1.zip
	cd cache && unzip -P iagreetotheeula SC2.3.16.1.zip

cache/Ladder2017Season1: cache/Ladder2017Season1.zip
	cd cache && unzip -P iagreetotheeula Ladder2017Season1.zip

cache/Replays: cache/3.16.1-Pack_1-fix.zip
	cd cache && unzip -P iagreetotheeula 3.16.1-Pack_1-fix.zip
	# fix timestamp
	touch cache/Replays
	touch cache/Battle.net

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

run:
	TF_CPP_MIN_LOG_LEVEL=2 python3 ai/main.py