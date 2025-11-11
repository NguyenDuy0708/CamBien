import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';

class LightSensorPage extends StatefulWidget {
  const LightSensorPage({Key? key}) : super(key: key);

  @override
  _LightSensorPageState createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  int? _luxValue;
  StreamSubscription<int>? _subscription; // Thay late bằng nullable

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    try {
      _subscription = Light().lightSensorStream.listen((int luxValue) {
        setState(() {
          _luxValue = luxValue;
        });
      });
    } catch (exception) {
      print("Không thể khởi tạo cảm biến ánh sáng: $exception");
      // Có thể hiển thị thông báo lỗi cho người dùng ở đây
    }
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Sử dụng ?. để tránh lỗi nếu null
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[900]!;
    Color textColor = Colors.white;
    IconData icon = Icons.lightbulb;
    Color iconColor = Colors.yellow;
    String message = "Trời tối, đã bật đèn!";

    const brightThreshold = 100;

    if (_luxValue != null && _luxValue! > brightThreshold) {
      backgroundColor = Colors.amber[100]!;
      textColor = Colors.black87;
      icon = Icons.wb_sunny;
      iconColor = Colors.orange;
      message = "Trời sáng, không cần đèn!";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cảm biến Ánh sáng"),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 150,
                color: iconColor,
              ),
              const SizedBox(height: 30),
              Text(
                message,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cường độ sáng: ${_luxValue ?? "Đang đọc..."} lux',
                style: TextStyle(fontSize: 18, color: textColor.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}