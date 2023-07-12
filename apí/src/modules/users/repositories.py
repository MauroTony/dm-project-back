from flask_restful import abort
from main import database
from .ext import UserAlreadyExists, UserNotFound
from utils.crypt import crypt_password

class UserRepository:
    def create(self, user):
        user_verify = database.users.find_one({'username': user.username})
        if user_verify:
            raise UserAlreadyExists('Username already exists')
        user.password = crypt_password(user.password)
        database.users.insert_one({'username': user.username, 'password': user.password})

    def find_by_username(self, username):
        user = database.users.find_one({'username': username})
        print("user", user)
        if not user:
            raise UserNotFound('User not found')
        return user

    def update_password(self, username, new_password):
        self.find_by_username(username)
        new_password = crypt_password(new_password)
        database.users.update_one({'username': username}, {'$set': {'password': new_password}})

    def delete(self, username):
        self.find_by_username(username)
        database.users.delete_one({'username': username})
