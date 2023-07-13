from flask import Flask
from flask_restful import Api
from flask_cors import CORS
from flask_jwt_extended import JWTManager, jwt_required, create_access_token, get_jwt_identity
from flask_pymongo import PyMongo
from config import get_config

class APIHandler:
    def __init__(self) -> None:
        self.config = get_config()
        self.port = int(self.config.API_PORT)
        self.host = self.config.API_HOST
        self.app = Flask(__name__)
        self.api = Api(self.app)
        self.jwt = JWTManager(self.app)
        self.__config()
        self.mongo = PyMongo(self.app)


    def inject_router(self, module, router) -> None:
        self.api.add_resource(module, router)

    def __config(self):
        CORS(self.app)
        self.app.config['JWT_SECRET_KEY'] = self.config.JWT_SECRET_KEY
        self.app.config['JWT_ALGORITHM'] = self.config.JWT_ALGORITHM
        self.app.config['MONGO_URI'] = f"mongodb://{self.config.DB_USER}:{self.config.DB_PASSWORD}@{self.config.DB_HOST}:{self.config.DB_PORT}/{self.config.DB_DATABASE}"
        #self.app.config['MONGO_URI'] = f'mongodb://{self.config.DB_USER}:{self.config.DB_PASSWORD}@{self.config.DB_HOST}:{self.config.API_PORT}/{self.config.DB_DATABASE}'

        @self.jwt.token_in_blocklist_loader
        def check_if_token_in_blocklist(jwt_header, jwt_payload):
            token = jwt_payload['jti']
            verify = self.mongo.db.blocklist.find_one({'token': token})
            if verify:
                return True
            return False

    def start(self):

        self.app.run(host=self.host, port=self.port, debug=True)
