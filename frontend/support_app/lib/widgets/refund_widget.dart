import 'package:flutter/material.dart';

class RefundWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const RefundWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Refund Approved',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 10),
            _Row('Refund ID', data['refund_id']),
            _Row('Amount', data['amount']),
            _Row('Method', data['method']),
            _Row('Processing', '${data['processing_days']} business days'),
            const SizedBox(height: 8),
            Text(data['message'] as String? ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final dynamic value;

  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text('${value ?? ''}',
              style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
