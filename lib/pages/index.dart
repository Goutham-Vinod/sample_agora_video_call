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
  final _channelNameController = TextEditingController();
  final _videoTokenController = TextEditingController();
  @override
  void dispose() {
    _channelNameController.dispose();
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
                controller: _channelNameController,
                decoration: const InputDecoration(
                    border:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1)),
                    hintText: 'Channel Name'),
              ),
              TextField(
                controller: _appIdController,
                decoration: const InputDecoration(
                    border:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1)),
                    hintText: 'App ID'),
              ),
              TextField(
                controller: _videoTokenController,
                decoration: const InputDecoration(
                    border:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1)),
                    hintText: 'Temp Token'),
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
            channelName: _channelNameController.text,
            videoToken: _videoTokenController.text,
          ),
        ));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }
}
