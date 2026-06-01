import 'package:flutter/material.dart';

class FlightWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const FlightWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final flights = (data['flights'] as List<dynamic>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available Flights',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ...flights.map((f) => _FlightCard(flight: f as Map<String, dynamic>)),
      ],
    );
  }
}

class _FlightCard extends StatelessWidget {
  final Map<String, dynamic> flight;

  const _FlightCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.flight_takeoff, color: Colors.indigo, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(flight['airline'] as String? ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '${flight['from']} → ${flight['to']}  '
                    '${flight['departure']} – ${flight['arrival']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              flight['price'] as String? ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}
