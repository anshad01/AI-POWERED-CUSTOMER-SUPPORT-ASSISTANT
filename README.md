# AI-Powered Customer Support Assistant

## Screenshots

### Chat UI — Hotel Search
![Hotel Search](screenshots/hotel_search.png)

---

## Architecture

```
Flutter App
    │  POST /chat  { session_id, message, history }
    ▼
FastAPI (port 8000)
    │  routes/chat.py
    ├─► memory_service  →  last 5 turns per session
    ├─► llm_service     →  Ollama (llama3.2) intent classification
    └─► tools/registry  →  intent → tool → static data
    │
    ▼
JSON Response  { intent, tool_called, ui_type, message, data }
    │
Flutter Widget Factory
    └─► switch(ui_type) → HotelWidget | FlightWidget | TrackingWidget | ...
```

---

## Prerequisites

| Tool | Version |
|---|---|
| Python | 3.11+ |
| Ollama | latest |
| Flutter | 3.19+ |

---

## Setup & Run

### 1. Ollama — pull the model (one-time, needs internet)
```bash
ollama pull llama3.2
```

### 2. Backend
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

### 3. Flutter frontend
```bash
cd frontend/support_app
flutter pub get
flutter run                        # Android emulator
flutter run -d windows             # Windows desktop
```

> **Android emulator**: backend URL is `http://10.0.2.2:8000` (already configured).  
> **Windows desktop**: change `_baseUrl` in `lib/services/api_service.dart` to `http://localhost:8000`.

---

## API

### POST /chat

**Request**
```json
{
  "session_id": "abc123",
  "message": "Show hotels in Dubai",
  "history": []
}
```

**Response**
```json
{
  "intent": "hotel_search",
  "tool_called": "hotel_tool",
  "ui_type": "hotel_page",
  "message": "Here are the available hotels.",
  "data": {
    "hotels": [
      { "name": "Grand Palace Hotel", "price": "$220", "rating": 4.8, "location": "Dubai" }
    ],
    "city": "Dubai",
    "count": 5
  }
}
```

### curl examples
```bash
# Hotel search
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"session_id":"s1","message":"Show hotels in Dubai","history":[]}'

# Follow-up (context-aware)
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"session_id":"s1","message":"Show cheaper ones","history":[]}'

# Order tracking
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"session_id":"s1","message":"Where is my order?","history":[]}'

# Refund
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"session_id":"s1","message":"I want a refund","history":[]}'
```

---

## Supported Intents

| Intent | Tool | ui_type | Example message |
|---|---|---|---|
| hotel_search | hotel_tool | hotel_page | "Show hotels in Dubai" |
| flight_search | flight_tool | flight_page | "Find flights to London" |
| order_tracking | tracking_tool | tracking_page | "Where is my order?" |
| refund_request | refund_tool | refund_page | "I want a refund" |
| complaint | complaint_tool | complaint_page | "I'm very unhappy with my order" |
| escalation | escalation_tool | escalation_page | "I want to speak to a manager" |

---

## Design Decisions

- **Intent classification via Ollama**: System prompt forces `{"intent": "..."}` JSON-only output with `temperature: 0` for determinism. Falls back to `general` on any parse error.
- **Memory**: Server-side `dict[session_id → list[Turn]]`, capped at 10 entries (5 turns). Full history passed to Ollama on each request for follow-up comprehension.
- **Tool Registry**: Plain dict — adding a new intent = 1 new tool file + 2 registry lines.
- **Widget Factory**: Single `switch` in `widget_factory.dart` — adding a new `ui_type` = 1 new widget file + 1 case.
- **Riverpod**: `StateNotifier` manages chat state; `Provider` supplies `ApiService`.
