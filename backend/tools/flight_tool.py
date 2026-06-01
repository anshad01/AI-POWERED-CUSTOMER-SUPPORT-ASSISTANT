def flight_tool(context: dict) -> dict:
    return {
        "flights": [
            {"airline": "Emirates",     "from": "DXB", "to": "LHR", "departure": "08:00", "arrival": "12:30", "price": "$550", "seats": 12},
            {"airline": "Flydubai",     "from": "DXB", "to": "IST", "departure": "14:15", "arrival": "17:45", "price": "$210", "seats": 5},
            {"airline": "Air Arabia",   "from": "SHJ", "to": "CAI", "departure": "06:30", "arrival": "08:00", "price": "$130", "seats": 20},
            {"airline": "Qatar Airways","from": "DOH", "to": "JFK", "departure": "22:00", "arrival": "06:00", "price": "$780", "seats": 3},
        ]
    }
