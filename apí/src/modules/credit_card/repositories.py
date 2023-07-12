from datetime import datetime

from main import database
from .models import CreditCard, CreditCardAnalise, CreditCardAnaliseLogs
from .ext import CreditCardAlreadyExists, CreditCardNotFound, AnaliseCreditCardNotFound, AnaliseCooldown, AnaliseApproved, AnalisePending
import random

class CreditCardRepository:

    def create(self, username):
        credit_card_verify = database.credit_cards.find_one({'username': username})

        if credit_card_verify:
            raise CreditCardAlreadyExists('CreditCard already exists')

        user = database.users.find_one({'username': username})
        username_number = sum(ord(char) for char in username)
        credit_card_number = ''.join(random.choice('0123456789') for _ in range(16))
        credit_card_number = str(username_number) + credit_card_number

        credit_card = CreditCard(
            username=username,
            number=credit_card_number,
            name=user['name'],
        )

        database.credit_cards.insert_one(credit_card.model_dump())
        return credit_card

    def get_credit_card_by_username(self, username):
        credit_card = database.credit_cards.find_one({'username': username})
        if not credit_card:
            raise CreditCardNotFound('CreditCard not found')
        return credit_card

    def delete(self, username):
        card_user = self.get_credit_card_by_username(username)
        analise_credit_card_verify = database.credit_card_analise.find_one({'card_number': card_user["number"]})
        if analise_credit_card_verify:
            status = analise_credit_card_verify['status']
            if status == 'negado':
                data_request = analise_credit_card_verify['data_request']
                if data_request + 600 > datetime.now().timestamp():
                    raise AnaliseCooldown('AnaliseCooldown2')
            elif status == "pendente":
                raise AnalisePending('AnalisePending')
        database.credit_cards.delete_one({'username': username})
        return True

class AnaliseCreditCardRepository:
    def create(self, username):
        card_user = CreditCardRepository().get_credit_card_by_username(username)

        analise_credit_card_verify = database.credit_card_analise.find_one({'card_number': card_user["number"]})

        if analise_credit_card_verify:
            status = analise_credit_card_verify['status']
            if status == 'negado':
                data_request = analise_credit_card_verify['data_request']
                if data_request + 600 < datetime.now().timestamp():
                    # TODO - fazer a analise de credito
                    print('fazer a analise de credito')
                    database.credit_card_analise.update_one({'username': username}, {'$set': {'status': 'pendente', 'data_request': datetime.now().timestamp()}})
                    return analise_credit_card_verify
                else:
                    raise AnaliseCooldown('AnaliseCooldown2')
            elif status == 'aprovado':
                raise AnaliseApproved('AnaliseApproved')
            else:
                raise AnalisePending('AnalisePending')
        # TODO - fazer a analise de credito
        print('fazer a analise de credito')

        analise_credit_card = CreditCardAnalise(
            username=username,
            card_number=card_user['number'],
        )

        database.credit_card_analise.insert_one(analise_credit_card.model_dump())
        return analise_credit_card

    def get_analise_by_username(self, username):
        analise_credit_card = database.credit_card_analise.find_one({'username': username})
        if not analise_credit_card:
            raise AnaliseCreditCardNotFound('AnaliseCreditCard not found')
        return analise_credit_card