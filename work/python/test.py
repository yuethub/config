#!/bin/python3

import tensorflow as tf

x = tf.placeholder(tf.float32, name='x');
x = tf.placeholder(tf.float32, name='y');
x = tf.add(x, y, name='sum');

session = tf.Session()
summary_writer = tf.summary.FileWriter('/tmp/1', session.graph);

