from pydantic import BaseModel
from typing import Any


class Turn(BaseModel):
    role: str   # "user" or "assistant"
    content: str


class ChatRequest(BaseModel):
    session_id: str = "default"
    message: str
    history: list[Turn] = []


class ChatResponse(BaseModel):
    intent: str
    tool_called: str
    ui_type: str
    message: str
    data: dict[str, Any] = {}
