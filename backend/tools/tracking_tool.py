def tracking_tool(context: dict) -> dict:
    return {
        "order_id": "ORD-2024-78432",
        "status": "In Transit",
        "carrier": "FedEx",
        "tracking_number": "FX9284710234",
        "estimated_delivery": "2026-06-04",
        "timeline": [
            {"step": "Order Placed",      "date": "2026-05-29", "done": True},
            {"step": "Processing",        "date": "2026-05-30", "done": True},
            {"step": "Shipped",           "date": "2026-05-31", "done": True},
            {"step": "In Transit",        "date": "2026-06-01", "done": True},
            {"step": "Out for Delivery",  "date": "2026-06-03", "done": False},
            {"step": "Delivered",         "date": "2026-06-04", "done": False},
        ],
    }
