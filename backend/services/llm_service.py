import json
import logging
import os
import httpx
from models.schemas import Turn

logger = logging.getLogger(__name__)

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434/api/generate")
MODEL = os.getenv("OLLAMA_MODEL", "llama3.2")

VALID_INTENTS = [
    "order_tracking",
    "refund_request",
    "complaint",
    "escalation",
    "hotel_search",
    "flight_search",
    "general",
]

SYSTEM_PROMPT = """You are an intent classifier for a customer support system.
Output ONLY a JSON object with one key "intent". No explanation, no markdown, no extra text.

INTENT DEFINITIONS:
- order_tracking  : user asks WHERE their order is, delivery status, shipment, tracking number, estimated arrival
- refund_request  : user asks for money back, return, refund, cancel order
- complaint       : user expresses dissatisfaction, anger, bad experience, reports a problem with a product/service
- escalation      : user wants to speak to a manager, supervisor, human agent, or escalate their issue
- hotel_search    : user asks about hotels, accommodation, rooms, places to stay, booking a hotel
- flight_search   : user asks about flights, airline tickets, travel, booking a flight
- general         : anything that does not match the above

EXAMPLES:
"Where is my order?" → {"intent": "order_tracking"}
"Track my package" → {"intent": "order_tracking"}
"What is the status of my delivery?" → {"intent": "order_tracking"}
"I want a refund" → {"intent": "refund_request"}
"I'm unhappy with my purchase" → {"intent": "complaint"}
"This is terrible service" → {"intent": "complaint"}
"Let me speak to a manager" → {"intent": "escalation"}
"Show hotels in Dubai" → {"intent": "hotel_search"}
"Find me a flight to London" → {"intent": "flight_search"}
"Show cheaper ones" → {"intent": "hotel_search"}

Output format: {"intent": "<one of the intents above>"}"""


def _build_prompt(history: list[Turn], message: str) -> str:
    context = ""
    if history:
        context = "Conversation so far:\n"
        for turn in history[-6:]:
            context += f"{turn.role.capitalize()}: {turn.content}\n"
        context += "\n"
    return f"{context}User: {message}\n\nClassify the intent:"


async def classify_intent(history: list[Turn], message: str) -> str:
    prompt = _build_prompt(history, message)

    payload = {
        "model": MODEL,
        "system": SYSTEM_PROMPT,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "options": {"temperature": 0.0, "num_predict": 50},
    }

    try:
        async with httpx.AsyncClient(timeout=60.0) as client:
            resp = await client.post(OLLAMA_URL, json=payload)
            resp.raise_for_status()
            body = resp.json()
            logger.info("Ollama raw response: %s", body)
            raw = body.get("response", "{}")
            # extract JSON even if wrapped in markdown fences
            raw = raw.strip()
            if raw.startswith("```"):
                raw = raw.split("```")[1]
                if raw.startswith("json"):
                    raw = raw[4:]
            parsed = json.loads(raw)
            intent = parsed.get("intent", "general").strip()
            if intent not in VALID_INTENTS:
                logger.warning("Unknown intent '%s', falling back to general", intent)
                intent = "general"
            logger.info("Classified intent: %s", intent)
            return intent
    except Exception as exc:
        logger.exception("LLM error: %r", exc)
        return "general"
