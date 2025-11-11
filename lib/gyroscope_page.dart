import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopePage extends StatefulWidget {
  const GyroscopePage({Key? key}) : super(key: key);

  @override
  _GyroscopePageState createState() => _GyroscopePageState();
}

class _GyroscopePageState extends State<GyroscopePage> {
  // Biến để lưu giá trị góc quay theo 3 trục
  double x = 0.0, y = 0.0, z = 0.0;
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    // Bắt đầu lắng nghe sự kiện từ con quay hồi chuyển
    _streamSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        // Cộng dồn giá trị góc quay
        // Gyroscope cung cấp tốc độ quay (radians/second)
        // nên chúng ta cần cộng dồn để có được góc quay tuyệt đối
        x += event.x;
        y += event.y;
        z += event.z;
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
      appBar: AppBar(
        title: const Text("Con quay hồi chuyển (Gyroscope)"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Xoay điện thoại của bạn',
              style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 50),
            // Widget Transform sẽ xoay khối hộp của chúng ta
            Transform(
              transform: Matrix4.rotationZ(z)
                ..rotateX(x)
                ..rotateY(y),
              alignment: FractionalOffset.center,
              child: Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(5, 5),
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Khối hộp 3D",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
