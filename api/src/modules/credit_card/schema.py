from pydantic import BaseModel, Field

class CardSchema(BaseModel):
    name: str
    analise: str
    credito: int

class AnaliseSchema(BaseModel):
    status: str
    score: int
    card_number: str
    data_request: int