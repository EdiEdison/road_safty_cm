import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../models/report.dart';
import 'map_screen.dart';

class ReportDetailsScreen extends StatelessWidget {
  final LatLng location;
  final Map<LatLng, Report> reports;

  const ReportDetailsScreen({
    Key? key,
    required this.location,
    required this.reports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the report from the location
    final report = reports[location];

    if (report == null) {
      return const Scaffold(
        body: Center(
          child: Text('Report not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.videoFile != null)
              SizedBox(
                height: 300,
                width: double.infinity,
                child: VideoPlayerWidget(videoFile: report.videoFile!),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Incident Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailRow(
                    Icons.access_time,
                    "Time",
                    DateFormat('MMM dd, yyyy - HH:mm').format(report.timestamp),
                  ),
                  const SizedBox(height: 12),
                  _detailRow(
                    Icons.location_on,
                    "Location",
                    "${report.location.latitude.toStringAsFixed(4)}, ${report.location.longitude.toStringAsFixed(4)}",
                  ),
                  const SizedBox(height: 12),
                  _detailRow(
                    Icons.info_outline,
                    "Status",
                    report.status,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}