import 'package:flutter/material.dart';

class TrackingWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const TrackingWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final timeline = (data['timeline'] as List<dynamic>?) ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Order ${data['order_id'] ?? ''}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Carrier: ${data['carrier'] ?? ''}  •  ${data['status'] ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('Estimated: ${data['estimated_delivery'] ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(height: 16),
            ...timeline.map((t) {
              final step = t as Map<String, dynamic>;
              final done = step['done'] as bool? ?? false;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(
                      done ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 18,
                      color: done ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(step['step'] as String? ?? '',
                        style: TextStyle(
                            fontSize: 13,
                            color: done ? Colors.black87 : Colors.grey)),
                    const Spacer(),
                    Text(step['date'] as String? ?? '',
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
