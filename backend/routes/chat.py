import logging
import re
from fastapi import APIRouter
from models.schemas import ChatRequest, ChatResponse
from services import memory_service, llm_service
from tools.registry import INTENT_MAP, MESSAGES

logger = logging.getLogger(__name__)
router = APIRouter()


def _build_context(session_id: str, message: str) -> dict:
    """Extract lightweight context hints from history for tool use."""
    history = memory_service.get_history(session_id)
    ctx: dict = {}

    msg_lower = message.lower()
    if "cheap" in msg_lower or "budget" in msg_lower or "affordable" in msg_lower:
        ctx["price_filter"] = "cheaper"

    for turn in reversed(history):
        city_match = re.search(
            r"\b(dubai|london|paris|new york|istanbul|cairo|riyadh)\b",
            turn.content,
            re.IGNORECASE,
        )
        if city_match:
            ctx["city"] = city_match.group(1).title()
            break

    city_match = re.search(
        r"\b(dubai|london|paris|new york|istanbul|cairo|riyadh)\b",
        msg_lower,
        re.IGNORECASE,
    )
    if city_match:
        ctx["city"] = city_match.group(1).title()

    return ctx


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    session_id = request.session_id
    message = request.message.strip()

    history = memory_service.get_history(session_id)
    intent = await llm_service.classify_intent(history, message)
    logger.info("session=%s intent=%s message=%r", session_id, intent, message)

    memory_service.add_turn(session_id, "user", message)

    if intent in INTENT_MAP:
        entry = INTENT_MAP[intent]
        context = _build_context(session_id, message)
        data = entry["tool"](context)
        tool_name = entry["tool_name"]
        ui_type = entry["ui_type"]
        response_message = MESSAGES[intent]
    else:
        data = {}
        tool_name = "none"
        ui_type = "text_page"
        response_message = MESSAGES["general"]

    memory_service.add_turn(session_id, "assistant", response_message)

    return ChatResponse(
        intent=intent,
        tool_called=tool_name,
        ui_type=ui_type,
        message=response_message,
        data=data,
    )
