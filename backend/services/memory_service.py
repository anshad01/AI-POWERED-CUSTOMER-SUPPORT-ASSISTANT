from collections import defaultdict
from models.schemas import Turn

MAX_TURNS = 5

_store: dict[str, list[Turn]] = defaultdict(list)


def get_history(session_id: str) -> list[Turn]:
    return _store[session_id]


def add_turn(session_id: str, role: str, content: str) -> None:
    _store[session_id].append(Turn(role=role, content=content))
    if len(_store[session_id]) > MAX_TURNS * 2:
        _store[session_id] = _store[session_id][-(MAX_TURNS * 2):]


def clear_session(session_id: str) -> None:
    _store[session_id] = []
