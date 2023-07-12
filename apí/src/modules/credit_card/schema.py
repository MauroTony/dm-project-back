from pydantic import BaseModel, Field

class CardSchema(BaseModel):
    name: str = Field(..., min_length=4, max_length=20)
    analise: str = Field(..., default="analise")
    credito: int = Field(..., default=0)