import 'dart:io';
import 'package:latlong2/latlong.dart';

class IncidentReport {
  final LatLng location;
  final DateTime timestamp;
  final File? videoFile;
  final String status;

  IncidentReport({
    required this.location,
    required this.timestamp,
    this.videoFile,
    this.status = 'Active',
  });
}