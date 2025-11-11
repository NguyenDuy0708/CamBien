import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximitySensorPage extends StatefulWidget {
  const ProximitySensorPage({Key? key}) : super(key: key);

  @override
  _ProximitySensorPageState createState() => _ProximitySensorPageState();
}

class _ProximitySensorPageState extends State<ProximitySensorPage> {
  // Biến để lưu trạng thái có vật thể ở gần hay không
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<void> listenSensor() async {
    // Bắt đầu lắng nghe sự kiện
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        // Cảm biến trả về 1 nếu có vật cản, 0 nếu không
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cảm biến Tiệm cận"),
      ),
      // Thay đổi giao diện dựa trên trạng thái _isNear
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: _isNear ? Colors.black : Colors.white,
        child: Center(
          child: _isNear
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.phone_in_talk, color: Colors.white54, size: 80),
                    SizedBox(height: 20),
                    Text(
                      "Đang trong cuộc gọi...\nMàn hình đã tắt",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.white54),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hãy thử lấy tay che phần trên của điện thoại",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 100,
                      color: Colors.blue,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
