import json
import os
import time
import base64

from pika.adapters.blocking_connection import BlockingChannel
from .score_calculate import ScoreCalculate
from config import get_config

config = get_config()
class Manager:
    def __init__(self, broker, thread_number) -> None:
        self.__broker = broker
        self.thread_number = thread_number
        self.subscribe_queue = config.RABBITMQ_SUBSCRIBE_QUEUE

    def start_messenger(self):
        self.__broker.connect_to_broker()

        self.__broker.insert_queue(self.subscribe_queue, self.callback_new_message)

        self.__broker.start_broker()

    @staticmethod
    def callback_new_message(
        channel: BlockingChannel, body: bytes, delivery_tag: int
    ) -> bool:

        data = json.loads(body)
        print("data", data)
        username = data["username"]
        card_number = data["card_number"]
        score_handler = ScoreCalculate(username, card_number)
        score = score_handler.score_calculate()
        score_handler.insert_score()
        print("score", score)

        """channel.basic_publish(
            exchange="", routing_key=queue_name, body=json.dumps(content)
        )=---==============================================
        """
        channel.basic_ack(delivery_tag=delivery_tag)
        return True
