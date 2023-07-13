import pika
import pika as broker
import os
from dotenv import load_dotenv, find_dotenv
import base64
import json

load_dotenv(find_dotenv())
def teste():
    credentials = broker.PlainCredentials(
        os.getenv("RABBITMQ_USER"), os.getenv("RABBITMQ_PASS")
    )
    parameters = broker.ConnectionParameters(
        credentials=credentials,
        host=os.getenv("RABBITMQ_HOST"),
        port=int(os.getenv("RABBITMQ_PORT")),
        virtual_host="/",
        heartbeat=3600
    )
    connection = pika.BlockingConnection(parameters=parameters)
    channel = connection.channel()
    queue_name = 'SCORE'
    channel.queue_declare(queue=queue_name, auto_delete=False)
    content = {
        "data": "Teste"
    }
    channel.basic_publish(exchange='', routing_key=queue_name, body=json.dumps(content))
    connection.close()

teste()