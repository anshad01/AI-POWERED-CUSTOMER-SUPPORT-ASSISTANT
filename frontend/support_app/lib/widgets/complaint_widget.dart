import 'package:flutter/material.dart';

class ComplaintWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const ComplaintWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final steps = (data['steps'] as List<dynamic>?) ?? [];

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.report_problem, color: Colors.orange),
                SizedBox(width: 8),
                Text('Complaint Logged',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Ticket: ${data['ticket_id'] ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('Priority: ${data['priority'] ?? ''}  •  ${data['status'] ?? ''}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(height: 16),
            ...steps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.fiber_manual_record,
                          size: 10, color: Colors.orange.shade400),
                      const SizedBox(width: 6),
                      Text(e.value as String,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            Text(data['message'] as String? ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
