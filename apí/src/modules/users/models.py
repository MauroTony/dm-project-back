from pydantic import BaseModel, Field

class User(BaseModel):

    username: str = Field(..., min_length=4, max_length=20)
    password: str = Field(..., min_length=8)
    name: str = Field(..., min_length=3)
    renda: int = Field(...)