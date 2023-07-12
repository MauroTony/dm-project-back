from flask import request
from flask_restful import Resource
from flask_pydantic import validate
from flask_jwt_extended import jwt_required, get_jwt_identity
from .ext import UserAlreadyExists, UserNotFound
from .models import User
from .repositories import UserRepository
from .schema import UserSchema, UserDeleteSchema
class UserResource(Resource):
    @jwt_required()
    def get(self, username):
        user = UserRepository().find_by_username(username)
        if user:
            return {'username': user['username']}
        return {'message': 'User not found'}, 404

    @validate(User)
    def post(self):
        data = request.get_json()
        username = data.get('username')
        password = data.get('password')
        try:
            new_user = User(username=username, password=password)
            UserRepository().create(new_user)
        except UserAlreadyExists:
            return {'message': 'Username already exists'}, 400
        return {'message': 'User created successfully'}, 201

    @jwt_required()
    @validate(UserSchema)
    def put(self):
        data = request.get_json()
        username = data.get('username')
        new_password = data.get('password')
        current_user = get_jwt_identity()
        if current_user != username:
            return {'message': 'Permission denied'}, 403
        try:
            UserRepository().update_password(username, new_password)
        except UserNotFound:
            return {'message': 'User not found'}, 404
        return {'message': 'User updated successfully'}


    @jwt_required()
    @validate(UserDeleteSchema)
    def delete(self):
        data = request.get_json()
        username = data.get('username')
        current_user = get_jwt_identity()
        try:
            UserRepository().delete(username)
        except UserNotFound:
            return {'message': 'User not found'}, 404

        return {'message': 'User deleted successfully'}