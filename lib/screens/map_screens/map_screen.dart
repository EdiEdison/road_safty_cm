import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:road_safty_cm/app_colors.dart';
import 'package:road_safty_cm/screens/setting_screens/setting_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
          Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.menu, color: RColors.textPrimary,)),
        ],
        centerTitle: true,
        backgroundColor: RColors.primaryBackground,
        title: const Text("Good Morning, Edi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: RColors.textPrimary),),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(3.8480, 11.5021),
              initialZoom: 12.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              const MarkerLayer(
                markers: [
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

