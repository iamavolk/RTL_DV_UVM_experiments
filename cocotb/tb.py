import cocotb
from cocotb.queue import Queue, QueueEmpty, QueueFull
from cocotb.triggers import Timer
import logging

logging.basicConfig(level=logging.NOTSET)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

async def producer(q, n, delay=None):
    for elem in range(1, n+1):
        if delay is not None:
            await Timer(delay, unit="ns")
        await q.put(elem)
        logger.info(f"producer sent {elem}")

async def consumer(q):
    while True:
        elem = await q.get()
        logger.info(f"consumer got {elem}")

@cocotb.test()
async def infinite_queue(_):
    q = Queue()
    cocotb.start_soon(consumer(q))
    cocotb.start_soon(producer(q, 3))
    await Timer(1, unit="ns")
