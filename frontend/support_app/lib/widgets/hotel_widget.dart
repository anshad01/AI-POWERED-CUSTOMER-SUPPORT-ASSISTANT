import 'package:flutter/material.dart';

class HotelWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const HotelWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final hotels = (data['hotels'] as List<dynamic>?) ?? [];
    final city = data['city'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (city.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Hotels in $city',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ...hotels.map((h) => _HotelCard(hotel: h as Map<String, dynamic>)),
      ],
    );
  }
}

class _HotelCard extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const _HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    final name = hotel['name'] as String? ?? '';
    final price = hotel['price'] as String? ?? '';
    final rating = (hotel['rating'] as num?)?.toDouble() ?? 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Container(
              width: 72,
              height: 72,
              color: Colors.blueGrey.shade100,
              child: const Icon(Icons.hotel, size: 36, color: Colors.blueGrey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
