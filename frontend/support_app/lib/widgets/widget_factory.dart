import 'package:flutter/material.dart';
import '../models/chat_response.dart';
import 'hotel_widget.dart';
import 'flight_widget.dart';
import 'tracking_widget.dart';
import 'refund_widget.dart';
import 'complaint_widget.dart';
import 'escalation_widget.dart';

/// Maps ui_type → Widget. Add new entries here to support new intents.
Widget buildResponseWidget(ChatResponse response) {
  switch (response.uiType) {
    case 'hotel_page':
      return HotelWidget(data: response.data);
    case 'flight_page':
      return FlightWidget(data: response.data);
    case 'tracking_page':
      return TrackingWidget(data: response.data);
    case 'refund_page':
      return RefundWidget(data: response.data);
    case 'complaint_page':
      return ComplaintWidget(data: response.data);
    case 'escalation_page':
      return EscalationWidget(data: response.data);
    default:
      return Text(response.message,
          style: const TextStyle(fontSize: 14, color: Colors.black87));
  }
}
