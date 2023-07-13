import os
from urllib.parse import quote_plus
from dotenv import find_dotenv, load_dotenv
from pydantic import BaseModel

load_dotenv(find_dotenv())

class GeneralConfig(BaseModel):
    # rabbitmq enviroments
    RABBITMQ_USER: str = os.getenv('RABBITMQ_USER')
    RABBITMQ_PASS: str = os.getenv('RABBITMQ_PASS')
    RABBITMQ_HOST: str = os.getenv('RABBITMQ_HOST')
    RABBITMQ_PORT: str = os.getenv('RABBITMQ_PORT')
    RABBITMQ_SUBSCRIBE_QUEUE: str = os.getenv('RABBITMQ_SUBSCRIBE_QUEUE')
    RABBITMQ_PUBLISH_QUEUE: str = os.getenv('RABBITMQ_PUBLISH_QUEUE')

    # config system enviroments
    THREADS: int = int(os.getenv('THREADS'))

    # application database enviroments
    DB_TYPE: str = os.getenv('DB_TYPE')
    DB_HOST: str = os.getenv('DB_HOST')
    DB_DATABASE: str = os.getenv('DB_DATABASE')
    DB_PORT: str = os.getenv('DB_PORT')
    DB_USER: str = os.getenv('DB_USER')
    DB_PASSWORD: str = quote_plus(os.getenv('DB_PASSWORD'))

def get_config() -> GeneralConfig:
    return GeneralConfig()