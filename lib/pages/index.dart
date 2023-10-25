import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_application_7/pages/call_latest.dart';
import 'package:flutter_application_7/utils/settings.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _appIdController = TextEditingController();
  final _chatIdController = TextEditingController();
  final _videoTokenController = TextEditingController();
  @override
  void dispose() {
    _chatIdController.dispose();
    _appIdController.dispose();
    _videoTokenController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Video Call'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Image.network(imageUrl),
              SizedBox(height: 10),
              Text(
                  'Visit https://console.agora.io/token for AppId,Channel Name,Temp token.'),
              Text(
                  'Both user have to join same channel. User id will be assinged automatically'),
              SizedBox(height: 10),
              TextField(
                controller: _chatIdController,
                decoration: const InputDecoration(
                    border:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1)),
                    hintText: 'Chat Id'),
              ),
              TextField(
                controller: _appIdController,
                decoration: const InputDecoration(
                    border:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1)),
                    hintText: 'App Id'),
              ),
              TextField(
                controller: _videoTokenController,
                decoration: const InputDecoration(
                    border:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1)),
                    hintText: 'Video Token'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    join();
                  },
                  child: Text('Join'))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> join() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            appId: _appIdController.text,
            chatId: _chatIdController.text,
            videoToken: _videoTokenController.text,
          ),
        ));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
