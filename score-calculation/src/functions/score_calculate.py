import random
from time import sleep
from pymongo import MongoClient
from config import get_config
from .models import CreditCardAnalise, CreditCardAnaliseLogs

class ScoreCalculate:
    def __init__(self, username, card) -> None:
        self.config = get_config()
        self.MONGO_URI = None
        self.__config()
        self.client = MongoClient(self.MONGO_URI)
        self.username = username
        self.card = card
        self.score = None
    def __config(self):
        self.MONGO_URI = f"mongodb://{self.config.DB_USER}:{self.config.DB_PASSWORD}@{self.config.DB_HOST}:{self.config.DB_PORT}"
    def score_calculate(self):
        self.score = random.randint(1, 999)
        sleep(5)
        return self.score

    def insert_score(self):
        db = self.client['admin']
        collection = db["users"]
        user = collection.find_one({'username': self.username})
        if not user:
            return False
        renda = user['renda']
        limite = 0
        if self.score <= 299:
            limite = 0
            status = "negado"
        elif self.score >= 300 and self.score < 600:
            limite = int(renda)/2
            status = "aprovado"
        elif self.score >= 600 and self.score < 800:
            limite = int(renda)*2
            status = "aprovado"
        elif self.score >= 951:
            limite = 1000000
            status = "aprovado"

        collection = db["credit_card_analise"]
        analise = collection.find_one(
            {'username': self.username, 'card_number': self.card}
        )
        if not analise:
            return False
        collection.update_one(
            {"username": self.username, "card_number": self.card},
            {'$set': {'status': status, 'score': self.score}}
        )

        collection = db["credit_card_analise_log"]
        log_data = CreditCardAnaliseLogs(
            card_number=self.card,
            username=self.username,
            score=self.score,
            status=status,
            date_request=int(analise['data_request'])
        ).model_dump()
        exec = collection.insert_one(log_data)
        print("collection updated1 ", exec)
        collection = db["credit_cards"]
        exec = collection.update_one(
            {'username': self.username, 'number': self.card},
            {'$set': {'credito': limite, "score": self.score}}
        )
        print("collection updated", exec)

        self.client.close()