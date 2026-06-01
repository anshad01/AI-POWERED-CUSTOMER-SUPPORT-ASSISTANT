def hotel_tool(context: dict) -> dict:
    price_filter = context.get("price_filter")
    city = context.get("city", "Dubai")

    hotels = [
        {"name": "Grand Palace Hotel", "price": "$220", "price_value": 220, "rating": 4.8, "location": city, "image": "hotel1"},
        {"name": "City Inn Express",   "price": "$95",  "price_value": 95,  "rating": 4.1, "location": city, "image": "hotel2"},
        {"name": "Azure Suites",       "price": "$310", "price_value": 310, "rating": 4.9, "location": city, "image": "hotel3"},
        {"name": "Budget Stay",        "price": "$60",  "price_value": 60,  "rating": 3.7, "location": city, "image": "hotel4"},
        {"name": "Royal Comfort",      "price": "$175", "price_value": 175, "rating": 4.5, "location": city, "image": "hotel5"},
    ]

    if price_filter == "cheaper":
        threshold = context.get("last_min_price", 220)
        hotels = [h for h in hotels if h["price_value"] < threshold]

    return {
        "hotels": [
            {"name": h["name"], "price": h["price"], "rating": h["rating"], "location": h["location"]}
            for h in hotels
        ],
        "city": city,
        "count": len(hotels),
    }
