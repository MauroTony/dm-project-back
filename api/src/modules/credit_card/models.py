from pydantic import BaseModel, Field
from datetime import datetime

class CreditCard(BaseModel):
    name: str = Field(..., min_length=3)
    number: str = Field(..., min_length=8)
    username: str = Field(..., min_length=3)
    credito: int = Field(default=0)
    score: int = Field(default=0)

class CreditCardAnalise(BaseModel):
    status: str = Field(default="pendente")
    score: int = Field(default=0)
    card_number: str = Field(..., min_length=8)
    username: str = Field(..., min_length=3)
    data_request: int = Field(default=datetime.now().timestamp())

class CreditCardAnaliseLogs(BaseModel):
    username: str = Field(..., min_length=3)
    card_number: str = Field(..., min_length=8)
    score: int = Field(default=0)
    status: str = Field(default="pendente")
    date_request: int = Field(...)