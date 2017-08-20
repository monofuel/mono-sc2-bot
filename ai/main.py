#!/usr/bin/python3

from s2clientprotocol import sc2api_pb2
import tensorflow as tf

if __name__ == "__main__":
    print("hello world")
    request = sc2api_pb2.Request()

    hello = tf.constant('Hello, TensorFlow!')
    sess = tf.Session()
    print(sess.run(hello))
