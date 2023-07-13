from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field

class UserSchema(BaseModel):
    username: str
    password: str = Field(..., min_length=8)

class TokenSchema(BaseModel):
    token: str