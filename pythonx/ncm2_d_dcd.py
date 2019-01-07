#!/usr/bin/env python
# -*- coding: utf-8 -*-
import vim
from ncm2 import Ncm2Source, getLogger
from subprocess import Popen, PIPE, CalledProcessError, TimeoutExpired
from multiprocessing import Process
from distutils.spawn import find_executable


logger = getLogger(__name__)


def start_dcd_server(dcd_server):
    """Start dcd server."""
    logger.debug(dcd_server)
    try:
        out = Popen(
                [dcd_server],
                stdin=PIPE,
                stdout=PIPE,
                stderr=PIPE,
                universal_newlines=True,
                ).communicate()[0]
    except (CalledProcessError, FileNotFoundError) as e:
        logger.error("dcd-server executable not available!")
    except TimeoutExpired:
        logger.error("dcd-server timeout!")


class Source(Ncm2Source):
    def __init__(self, vim):
        Ncm2Source.__init__(self, vim)

    def on_complete(self, ctx, data, lines):
        return None

    def start(self):
        data = self.nvim.call("ncm2_d#data")
        dcd_server = find_executable(data["dcd_server_bin"])
        p = Process(target=start_dcd_server, args=(dcd_server, ), daemon=True)
        p.start()
        p.join()


try:
    source = Source(vim)
    #  source.start()
except Exception as e:
    logger.error(str(e))

