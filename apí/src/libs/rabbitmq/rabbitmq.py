import pika as broker
import json

from config import get_config

class RabbitMQProducer:
    def __init__(self):
        self.config = get_config()
        self.exchange = ''
        self.queue = self.config.RABBITMQ_PUBLISH_QUEUE
        self.username = self.config.RABBITMQ_USER
        self.password = self.config.RABBITMQ_PASS
        self.host = self.config.RABBITMQ_HOST
        self.port = self.config.RABBITMQ_PORT
        self.channel = self.connect_to_broker().channel()

    def connect_to_broker(self):
        credentials = broker.PlainCredentials(self.username, self.password)
        parameters = broker.ConnectionParameters(
            credentials=credentials,
            host=self.host,
            port=int(self.port),
            virtual_host="/",
            heartbeat=3600,
        )
        connection = broker.BlockingConnection(parameters=parameters)
        return connection

    def publish_message(self, content: dict):
        self.channel.basic_publish(exchange=self.exchange, routing_key=self.queue, body=json.dumps(content))


