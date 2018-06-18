# -*- coding: utf-8 -*-
from __future__ import absolute_import

import logging

logger = logging.getLogger(__name__)

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, world!'
