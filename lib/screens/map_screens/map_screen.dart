import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:road_safty_cm/app_colors.dart';
import 'package:road_safty_cm/screens/setting_screens/setting_screen.dart';
import 'package:video_player/video_player.dart';

import '../../models/incident_report.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  final MapController _mapController = MapController();

  // List to store markers
  final Map<LatLng, IncidentReport> _reports = {};

  // Initial markers
  List<Marker> _markers = [
     Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(3.8480, 11.5021),
      child: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
      ),
    ),
     Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(3.8500, 11.5100),
      child: Icon(
        Icons.location_pin,
        color: Colors.blue,
        size: 40,
      ),
    ),
     Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(3.8520, 11.5200),
      child: Icon(
        Icons.location_pin,
        color: Colors.green,
        size: 40,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize reports for existing markers
    for (var marker in _markers) {
      _reports[marker.point] = IncidentReport(
        location: marker.point,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'Active',
      );
    }
  }

  void _showReportDetails(LatLng location) {
    final report = _reports[location];
    if (report == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Video preview
            if (report.videoFile != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 200,
                  child: VideoPlayerWidget(videoFile: report.videoFile!),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text("No video available for this report"),
                ),
              ),

            // Report details
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
                  const SizedBox(height: 24),

                  // Help button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _offerHelp(location);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "I Can Help",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: RColors.textPrimary,
                        ),
                      ),
                    ),
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

  void _offerHelp(LatLng location) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Help"),
        content: const Text(
          "Thank you for offering to help! The incident reporter will be notified of your assistance.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Update report status
              setState(() {
                if (_reports.containsKey(location)) {
                  final updatedReport = IncidentReport(
                    location: location,
                    timestamp: _reports[location]!.timestamp,
                    videoFile: _reports[location]!.videoFile,
                    status: 'Help Offered',
                  );
                  _reports[location] = updatedReport;
                }
              });
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for offering help! The reporter has been notified.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RColors.buttonColor,
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: RColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  LatLng _generateNearbyLocation() {
    final random = Random();
    final latOffset = (random.nextDouble() - 0.5) * 0.02;
    final lngOffset = (random.nextDouble() - 0.5) * 0.02;
    final center = _mapController.camera.center;
    return LatLng(
      center.latitude + latOffset,
      center.longitude + lngOffset,
    );
  }

  void _addNewMarker() {
    final newLocation = _generateNearbyLocation();
    final newMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: newLocation,
      child: GestureDetector(
        onTap: () => _showReportDetails(newLocation),
        child: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 40,
        ),
      ),
    );

    setState(() {
      _markers.add(newMarker);
      _reports[newLocation] = IncidentReport(
        location: newLocation,
        timestamp: DateTime.now(),
        videoFile: _videoFile,
        status: 'Active',
      );
    });

    _mapController.move(newLocation, 15.0);
  }


  Future<void> _recordVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );

      if (video != null) {
        setState(() {
          _videoFile = File(video.path);
        });

        _showVideoDialog();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to record video: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void _showVideoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Review Your Video",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (_videoFile != null)
                  SizedBox(
                    height: 300,
                    child: VideoPlayerWidget(videoFile: _videoFile!),
                  )
                else
                  const Text("No video available."),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _recordVideo(); // Retake video
                      },
                      child: const Text("Retake"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Simulate report submission
                        _addNewMarker();
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report submitted successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RColors.buttonColor,
                      ),
                      child: const Text(
                        "Accept",
                        style: TextStyle(color: RColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
            child: const SizedBox(
              width: 40,
              height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.menu, color: RColors.textPrimary),
          ),
        ],
        centerTitle: true,
        backgroundColor: RColors.primaryBackground,
        title: const Text(
          "Good Morning, Edi",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: RColors.textPrimary),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(3.8480, 11.5021),
              initialZoom: 13.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _markers.map((marker) => Marker(
                  width: marker.width,
                  height: marker.height,
                  point: marker.point,
                  child: GestureDetector(
                    onTap: () => _showReportDetails(marker.point),
                    child: marker.child,
                  ),
                )).toList(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _recordVideo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: RColors.buttonColor,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Report",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({super.key, required this.videoFile});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.file(widget.videoFile);
    await _controller.initialize();
    setState(() {
      _isInitialized = true;
    });
    await _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(_controller),
          _ControlsOverlay(controller: _controller),
          VideoProgressIndicator(_controller, allowScrubbing: true),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          child: Container(
            color: Colors.black26,
            child: Center(
              child: IconButton(
                icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32.0,
                ),
                onPressed: () {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
