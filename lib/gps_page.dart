import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GpsPage extends StatefulWidget {
  const GpsPage({Key? key}) : super(key: key);

  @override
  _GpsPageState createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  LocationData? _locationData;
  bool _isLoading = false;
  String? _error;

  // Hàm để lấy vị trí
  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // 1. Kiểm tra xem dịch vụ vị trí có được bật không
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _error = "Dịch vụ vị trí đã bị tắt.";
          _isLoading = false;
        });
        return;
      }
    }

    // 2. Kiểm tra quyền truy cập
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _error = "Quyền truy cập vị trí đã bị từ chối.";
          _isLoading = false;
        });
        return;
      }
    }

    // 3. Nếu mọi thứ ổn, lấy tọa độ
    try {
      final locationData = await location.getLocation();
      setState(() {
        _locationData = locationData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Không thể lấy vị trí: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Location"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                )
              else if (_locationData != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Vĩ độ (Latitude):\n${_locationData!.latitude}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Kinh độ (Longitude):\n${_locationData!.longitude}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Text(
                  "Nhấn nút để lấy vị trí hiện tại của bạn",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.location_on),
                label: const Text("Lấy Vị trí Hiện tại"),
                onPressed: _getLocation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
