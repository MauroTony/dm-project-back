import os
from urllib.parse import quote_plus
from dataclasses import dataclass
from dotenv import find_dotenv, load_dotenv

load_dotenv(find_dotenv())

@dataclass
class GeneralConfig:
    # api enviroments
    API_PORT: str = os.getenv('API_PORT')
    API_HOST: str = os.getenv('API_HOST')

    # rabbitmq enviroments
    RABBITMQ_USER: str = os.getenv('RABBITMQ_USER')
    RABBITMQ_PASS: str = os.getenv('RABBITMQ_PASS')
    RABBITMQ_HOST: str = os.getenv('RABBITMQ_HOST')
    RABBITMQ_PORT: str = os.getenv('RABBITMQ_PORT')
    RABBITMQ_SUBSCRIBE_QUEUE: str = os.getenv('RABBITMQ_SUBSCRIBE_QUEUE')
    RABBITMQ_PUBLISH_QUEUE: str = os.getenv('RABBITMQ_PUBLISH_QUEUE')

    # authentication security enviroments
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')
    JWT_REFRESH_SECRET_KEY = os.getenv('JWT_REFRESH_SECRET_KEY')
    JWT_ALGORITHM = os.getenv('JWT_ALGORITHM')

    # application database enviroments
    DB_TYPE = os.getenv('DB_TYPE')
    DB_HOST = os.getenv('DB_HOST')
    DB_DATABASE = os.getenv('DB_DATABASE')
    DB_PORT = os.getenv('DB_PORT')
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = quote_plus(os.getenv('DB_PASSWORD'))


def get_config() -> GeneralConfig:
    return GeneralConfig()
