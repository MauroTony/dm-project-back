import random
from datetime import datetime
import pika as broker
import json
from main import database
from libs.rabbitmq.rabbitmq import RabbitMQProducer
from .models import CreditCard, CreditCardAnalise, CreditCardAnaliseLogs
from .ext import CreditCardAlreadyExists, AnaliseNotPending, CreditCardNotFound, AnaliseCreditCardNotFound, AnaliseCooldown, AnaliseApproved, AnalisePending


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
        credit_card.pop('_id', None)
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

    def __init__(self):
        self.rabbitmq_producer = RabbitMQProducer()

    def create(self, username):
        card_user = CreditCardRepository().get_credit_card_by_username(username)

        analise_credit_card_verify = database.credit_card_analise.find_one({'card_number': card_user["number"]})

        if analise_credit_card_verify:
            status = analise_credit_card_verify['status']
            if status == 'negado':
                data_request = analise_credit_card_verify['data_request']
                if data_request + 600 < datetime.now().timestamp():
                    print('fazer a analise de credito1')
                    body = {
                        "card_number": card_user["number"],
                        "username": username,
                    }
                    database.credit_card_analise.update_one({'username': username}, {'$set': {'status': 'pendente', 'data_request': datetime.now().timestamp()}})
                    self.rabbitmq_producer.publish_message(body)
                    return analise_credit_card_verify
                else:
                    raise AnaliseCooldown('AnaliseCooldown')
            elif status == 'aprovado':
                raise AnaliseApproved('AnaliseApproved')
            else:
                raise AnalisePending('AnalisePending')
        print('fazer a analise de credito')

        analise_credit_card = CreditCardAnalise(
            username=username,
            card_number=card_user['number'],
        )

        body = {
            "card_number": card_user["number"],
            "username": username,
        }
        try:
            self.rabbitmq_producer.publish_message(body)
            database.credit_card_analise.insert_one(analise_credit_card.model_dump())
        except Exception as e:
            print(e)
        return analise_credit_card

    def get_analise_by_username(self, username):
        card_user = CreditCardRepository().get_credit_card_by_username(username)

        analise_credit_card = database.credit_card_analise.find_one({'username': username, 'card_number': card_user["number"]})
        if not analise_credit_card:
            raise AnaliseCreditCardNotFound('AnaliseCreditCard not found')
        return analise_credit_card

    def delete(self, username):
        card_user = CreditCardRepository().get_credit_card_by_username(username)
        analise_credit_card_verify = database.credit_card_analise.find_one({'card_number': card_user["number"]})
        if analise_credit_card_verify:
            status = analise_credit_card_verify['status']
            if status == 'pendente':
                database.credit_card_analise.delete_one({'card_number': card_user["number"]})
                return True
            else:
                raise AnaliseNotPending('AnaliseNotPending')
        else:
            raise AnaliseCreditCardNotFound('AnaliseCreditCard not found')

class AnaliseCreditCardLogsRepository:

    def get_logs(self, username):
        logs = database.credit_card_analise_log.find({'username': username})
        logs = list(logs)
        print("logs", logs)

        if not logs:
            return []
        for log in logs:
            log.pop('_id', None)
            print(log['date_request'])
            log["score"] = str(log["score"])
            log['date_request'] = datetime.fromtimestamp(log['date_request']).strftime('%Y-%m-%d %H:%M:%S')

        return logs
