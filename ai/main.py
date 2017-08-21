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
    def __init__(self, config):
        self.uri = "ws://%s:%d/sc2api" % (config.host, config.port)
        logger.debug("will use SC2 URI: %s" % (self.uri))

    async def connect(self):
        logger.debug("connecting to sc2 api")
        self.socket = await websockets.connect(self.uri)
        logger.info('connected to sc2 api')

    async def send(self, request):
        await self.socket.send(request.SerializeToString())


async def main():
    logger.info("Starting main AI function")

    config = ControllerConfig()
    controller = Controller(config)
    await controller.connect()

    createRequest = sc2api_pb2.RequestCreateGame()
    createRequest.battlenet_map_name = "BelShirVestigeLE.SC2Map"
    await controller.send(createRequest)

    hello = tf.constant('Hello, TensorFlow!')
    sess = tf.Session()
    logger.debug(sess.run(hello))

if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())
