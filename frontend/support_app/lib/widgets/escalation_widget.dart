import 'package:flutter/material.dart';

class EscalationWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const EscalationWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.escalator_warning, color: Colors.red),
                SizedBox(width: 8),
                Text('Case Escalated',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 10),
            Text('ID: ${data['escalation_id'] ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('Manager: ${data['assigned_manager'] ?? ''}',
                style: const TextStyle(fontSize: 13)),
            Text('Response: ${data['estimated_response'] ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(data['message'] as String? ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
