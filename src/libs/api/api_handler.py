from flask import Flask
from flask_restful import Api
from src.config import get_config

class APIHandler:
    def __init__(self) -> None:
        config = get_config()
        self.port = int(config.API_PORT)
        self.host = config.API_HOST
        self.app = Flask(__name__)
        self.api = Api(self.app)

    def inject_router(self, module, router) -> None:
        self.api.add_resource(module, router)
    def start(self):
        self.app.run(host=self.host, port=self.port, debug=True)