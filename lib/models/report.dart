
import 'dart:io';
import 'package:latlong2/latlong.dart';

class Report {
  final File? videoFile;
  final DateTime timestamp;
  final LatLng location;
  final String status;

  Report({
    this.videoFile,
    required this.timestamp,
    required this.location,
    required this.status,
  });
}