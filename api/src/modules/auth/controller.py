from flask import request
from flask_restful import Resource
from flask_pydantic import validate
from flask_jwt_extended import jwt_required, create_access_token, get_jwt_identity, get_jwt
from .ext import PasswordWrong, UserNotFound
from modules.users.repositories import UserRepository
from .schema import UserSchema, TokenSchema
from utils.crypt import verify_password
from argon2.exceptions import VerifyMismatchError
from .blocklist import blocklist
class LoginResource(Resource):

    @validate(UserSchema)
    def post(self):
        data = request.get_json()
        username = data.get('username')
        password = data.get('password')
        try:
            user = UserRepository().find_by_username(username)
            verify_password(user["password"], password)
        except (UserNotFound, VerifyMismatchError):
            return {'message': 'Invalid username or password'}, 401

        access_token = create_access_token(identity=username)
        return TokenSchema(token=access_token)

class LogoutResource(Resource):

    @jwt_required()
    def post(self):
        jti = get_jwt()["jti"]
        blocklist(jti)
        return {'message': 'Logged out successfully'}