from flask import request
from flask_restful import Resource
from flask_pydantic import validate
from flask_jwt_extended import jwt_required, get_jwt_identity

from .ext import CreditCardNotFound, CreditCardAlreadyExists, AnaliseCreditCardNotFound, AnaliseApproved, AnaliseCooldown, AnalisePending
from .models import CreditCard
from .repositories import CreditCardRepository, AnaliseCreditCardRepository
class CardResource(Resource):

    @jwt_required()
    def get(self):
        current_user = get_jwt_identity()
        try:
            credit_card = CreditCardRepository().get_credit_card_by_username(current_user)
        except CreditCardNotFound:
            return {'message': 'CreditCard not found'}, 404
        return credit_card.model_dump(), 200

    @jwt_required()
    def post(self):
        current_user = get_jwt_identity()
        try:
            credit_card = CreditCardRepository().create(current_user)
        except CreditCardAlreadyExists:
            return {'message': 'CreditCard already exists'}, 400
        return credit_card.model_dump(), 201

    @jwt_required()
    def delete(self):
        current_user = get_jwt_identity()
        try:
            credit_card = CreditCardRepository().delete(current_user)
        except CreditCardNotFound:
            return {'message': 'Credit Card not found'}, 404
        except AnaliseCooldown:
            return {'message': 'Cooldown'}, 400
        except AnalisePending:
            return {'message': 'Credit review is pending'}, 400
        return {'message': 'CreditCard deleted successfully'}, 200
class AnaliseResource(Resource):

    @jwt_required()
    def get(self):
        current_user = get_jwt_identity()
        try:
            credit_card = AnaliseCreditCardRepository().get_analise_by_username(current_user)
        except AnaliseCreditCardNotFound:
            return {'message': 'Credit review not found'}, 404
        return credit_card.model_dump(), 200

    @jwt_required()
    def post(self):
        current_user = get_jwt_identity()
        try:
            credit_card = AnaliseCreditCardRepository().create(current_user)
        except AnaliseCooldown as cooldown:
            print("cooldown", cooldown)
            return {'message': 'Cooldown'}, 400
        except AnaliseApproved:
            return {'message': 'Credit review has already been approved'},
        except AnalisePending:
            return {'message': 'Credit review is pending'}, 400
        except CreditCardNotFound:
            return {'message': 'Credit Card not found'}, 404

        return credit_card.model_dump(), 201