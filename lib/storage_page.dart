import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  _StoragePageState createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  // Lấy đường dẫn tới file
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/note.txt');
  }

  // Đọc dữ liệu từ file
  Future<void> _loadNote() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      setState(() {
        _textController.text = contents;
      });
    } catch (e) {
      // Nếu file chưa tồn tại hoặc có lỗi, không làm gì cả
      print("Không thể đọc file: $e");
    }
  }

  // Ghi dữ liệu vào file
  Future<void> _saveNote() async {
    final file = await _localFile;
    await file.writeAsString(_textController.text);
    // Hiển thị thông báo đã lưu
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu ghi chú!')),
    );
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lưu trữ & Hệ thống Tệp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textController,
          maxLines: null, // Cho phép nhập nhiều dòng
          expands: true, // Mở rộng hết không gian
          decoration: const InputDecoration(
            hintText: 'Nhập ghi chú của bạn ở đây...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        label: const Text('Lưu'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
