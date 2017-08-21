#!/usr/bin/python3

from s2clientprotocol import sc2api_pb2
import tensorflow as tf
import websockets
import asyncio
import os
import logging


logger = logging.getLogger("SC2AI")
logger.setLevel(logging.DEBUG)

console = logging.StreamHandler()
console.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(name)-12s: %(levelname)-8s %(message)s')
console.setFormatter(formatter)
logger.addHandler(console)


class ControllerConfig:
    def __init__(self):
        self.host = os.environ.get("STARCRAFT_HOST", "localhost")
        self.port = os.environ.get("STARCRAFT_PORT", 5000)


class Controller:
    def __init__(self, config: ControllerConfig):
        self.uri = "ws://%s:%d/sc2api" % (config.host, config.port)
        logger.debug("will use SC2 URI: %s" % (self.uri))

    async def connect(self):
        logger.debug("connecting to sc2 api")
        self.socket = await websockets.connect(self.uri)
        logger.info('connected to sc2 api')

    async def send(self, **req):
        msg = sc2api_pb2.Request(**req)
        if not msg.IsInitialized():
            logger.error("msg not initialized:\n%s" % str(msg))

        logger.debug('sending message:\n=====\n%s-----' % str(msg))
        await self.socket.send(msg.SerializeToString())
        # return getattr(res, list(req.keys())[0])

    async def recv(self):
        resp = await self.socket.recv()
        return resp


async def main():
    logger.info("Starting main AI function")

    config = ControllerConfig()
    controller = Controller(config)
    await controller.connect()

    map_path = os.environ.get("MAP_PATH", "/StarCraftII/Maps/")

    createRequest = sc2api_pb2.RequestCreateGame(
        local_map=sc2api_pb2.LocalMap(
            map_path="%s/%s" % (map_path, "BelShirVestigeLE.SC2Map")
        ),
        player_setup=[
            sc2api_pb2.PlayerSetup(
                type=sc2api_pb2.Computer
            ),
            sc2api_pb2.PlayerSetup(
                type=sc2api_pb2.Participant
            )]
    )
    await controller.send(create_game=createRequest)
    logger.info("sent request to create map")
    resp = await controller.recv()
    logger.debug("{}".format(resp))

    hello = tf.constant('Hello, TensorFlow!')
    sess = tf.Session()
    logger.debug(sess.run(hello))

if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())
