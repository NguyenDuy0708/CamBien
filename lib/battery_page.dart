import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({Key? key}) : super(key: key);

  @override
  _BatteryPageState createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.full;
  late StreamSubscription<BatteryState> _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    // Lấy mức pin ban đầu
    _battery.batteryLevel.then((level) {
      setState(() {
        _batteryLevel = level;
      });
    });

    // Lắng nghe sự thay đổi trạng thái pin (cắm sạc, rút sạc...)
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
      // Cập nhật lại mức pin mỗi khi trạng thái thay đổi
      _battery.batteryLevel.then((level) {
        setState(() {
          _batteryLevel = level;
        });
      });
    });
  }

  @override
  void dispose() {
    _batteryStateSubscription.cancel();
    super.dispose();
  }

  // Hàm để chọn màu sắc dựa trên mức pin
  Color _getBatteryColor() {
    if (_batteryLevel > 50) {
      return Colors.green;
    } else if (_batteryLevel > 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Hàm để chọn icon dựa trên trạng thái pin
  IconData _getBatteryIcon() {
    switch (_batteryState) {
      case BatteryState.charging:
        return Icons.battery_charging_full;
      case BatteryState.full:
        return Icons.battery_full;
      case BatteryState.discharging:
      default:
        if (_batteryLevel > 90) return Icons.battery_full;
        if (_batteryLevel > 60) return Icons.battery_4_bar;
        if (_batteryLevel > 40) return Icons.battery_3_bar;
        if (_batteryLevel > 20) return Icons.battery_2_bar;
        return Icons.battery_1_bar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Pin"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getBatteryIcon(),
              size: 200,
              color: _getBatteryColor(),
            ),
            const SizedBox(height: 20),
            Text(
              '$_batteryLevel%',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: _getBatteryColor(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Trạng thái: ${_batteryState.toString().split('.').last}',
              style: TextStyle(fontSize: 22, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
