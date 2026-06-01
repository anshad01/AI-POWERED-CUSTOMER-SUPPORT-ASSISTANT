def complaint_tool(context: dict) -> dict:
    return {
        "ticket_id": "TKT-2024-55901",
        "status": "Open",
        "priority": "Medium",
        "category": "Customer Complaint",
        "created_at": "2026-06-01",
        "assigned_to": "Support Team",
        "message": "Your complaint has been logged. A support agent will follow up within 24 hours.",
        "steps": [
            "Complaint received",
            "Under review",
            "Resolution in progress",
            "Closed",
        ],
    }
