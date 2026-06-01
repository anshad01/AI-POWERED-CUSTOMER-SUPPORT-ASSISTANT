from tools.hotel_tool import hotel_tool
from tools.flight_tool import flight_tool
from tools.tracking_tool import tracking_tool
from tools.refund_tool import refund_tool
from tools.complaint_tool import complaint_tool
from tools.escalation_tool import escalation_tool

INTENT_MAP: dict[str, dict] = {
    "hotel_search":   {"tool": hotel_tool,      "tool_name": "hotel_tool",      "ui_type": "hotel_page"},
    "flight_search":  {"tool": flight_tool,     "tool_name": "flight_tool",     "ui_type": "flight_page"},
    "order_tracking": {"tool": tracking_tool,   "tool_name": "tracking_tool",   "ui_type": "tracking_page"},
    "refund_request": {"tool": refund_tool,     "tool_name": "refund_tool",     "ui_type": "refund_page"},
    "complaint":      {"tool": complaint_tool,  "tool_name": "complaint_tool",  "ui_type": "complaint_page"},
    "escalation":     {"tool": escalation_tool, "tool_name": "escalation_tool", "ui_type": "escalation_page"},
}

MESSAGES: dict[str, str] = {
    "hotel_search":   "Here are the available hotels.",
    "flight_search":  "Here are the available flights.",
    "order_tracking": "Here is your order tracking information.",
    "refund_request": "Your refund request has been processed.",
    "complaint":      "Your complaint has been logged successfully.",
    "escalation":     "Your case has been escalated to a manager.",
    "general":        "I'm here to help. You can ask about orders, refunds, hotels, flights, or complaints.",
}
