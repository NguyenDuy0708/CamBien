import 'dart:async';
import 'dart:math' as math; // Cần thư viện math để tính toán góc
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MagnetometerPage extends StatefulWidget {
  const MagnetometerPage({Key? key}) : super(key: key);

  @override
  _MagnetometerPageState createState() => _MagnetometerPageState();
}

class _MagnetometerPageState extends State<MagnetometerPage> {
  // Biến lưu góc quay của la bàn (heading)
  double? _heading;
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    // Bắt đầu lắng nghe sự kiện từ từ kế
    _streamSubscription = magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        // Tính toán góc từ các giá trị x, y của từ trường
        // atan2 là hàm lượng giác giúp tính góc một cách chính xác
        _heading = math.atan2(event.y, event.x);
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
        title: const Text("Từ kế (La bàn số)"),
      ),
      body: Center(
        child: _heading == null
            ? const CircularProgressIndicator() // Hiển thị loading nếu chưa có dữ liệu
            : Stack( // Sử dụng Stack để xếp chồng các widget lên nhau
                alignment: Alignment.center,
                children: [
                  // Lớp 1: Hình ảnh mặt la bàn
                  Image.asset('assets/compass.png'),
                  
                  // Lớp 2: Kim la bàn được xoay
                  Transform.rotate(
                    angle: -(_heading! - (math.pi / 2)), // Điều chỉnh góc cho đúng
                    child: Image.asset('assets/needle.png', width: 200),
                  ),
                ],
              ),
      ),
    );
  }
}
