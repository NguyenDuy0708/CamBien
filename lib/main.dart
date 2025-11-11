import 'dart:async';
import 'package:cambien/battery_page.dart';
import 'package:cambien/biometric_page.dart';
import 'package:cambien/bluetooth_page.dart';
import 'package:cambien/camera_page.dart';
import 'package:cambien/gps_page.dart';
import 'package:cambien/gyroscope_page.dart';
import 'package:cambien/light_sensor_page.dart';
import 'package:cambien/magnetometer_page.dart';
import 'package:cambien/npc_page.dart';
import 'package:cambien/proximity_sensor_page.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accelerometer Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AccelerometerPage(),
    );
  }
}

class AccelerometerPage extends StatefulWidget {
  const AccelerometerPage({Key? key}) : super(key: key);

  @override
  _AccelerometerPageState createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  double x = 0.0, y = 0.0, z = 0.0;
  Color _backgroundColor = Colors.white;
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      const shakeThreshold = 15.0; // Ngưỡng để phát hiện lắc

      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        if (event.x.abs() > shakeThreshold ||
            event.y.abs() > shakeThreshold ||
            event.z.abs() > shakeThreshold) {
          _backgroundColor = Colors.primaries[DateTime.now().millisecond % Colors.primaries.length];
        }
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Minh họa Cảm biến"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Giá trị gia tốc theo các trục:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'X: ${x.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Y: ${y.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Z: ${z.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              'Hãy thử lắc điện thoại!',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GyroscopePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Đi tới màn hình Gyroscope'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LightSensorPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Đi tới Cảm biến Ánh sáng'),
          ),
          const SizedBox(height: 20), 
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProximitySensorPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới Cảm biến Tiệm cận'),
            ),
            const SizedBox(height: 20), // Thêm khoảng cách
            // Thêm nút bấm mới
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MagnetometerPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới Từ kế (La bàn)'),
            ),
            const SizedBox(height: 20),
            // Thêm nút bấm mới
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GpsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới GPS Location'),
            ),
            const SizedBox(height: 20),
            // Thêm nút bấm mới
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới Camera'),
            ),
            const SizedBox(height: 20),
            // Thêm nút bấm mới
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BatteryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới Quản lý Pin'),
            ),
            const SizedBox(height: 20),
            // Thêm nút bấm mới
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BluetoothPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới Quản lý Bluetooth'),
            ),
            const SizedBox(height: 20),
            // Thêm nút bấm mới
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NfcPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới NFC'),
            ),
            const SizedBox(height: 20),
            // Thêm nút bấm mới
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BiometricPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Đi tới Xác thực Sinh trắc học'),
            ),
        ],
      ),
      )
    );
  }
}
