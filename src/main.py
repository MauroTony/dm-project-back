from libs.api.api_handler import APIHandler
from flask_restful import Api, Resource


class HelloWorld(Resource):
    def get(self):
        return {'message': 'Hello, World!'}

manager = APIHandler()
manager.inject_router( HelloWorld, '/')
manager.start()
