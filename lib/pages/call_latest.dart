import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  const CallScreen(
      {Key? key,
      required this.appId,
      required this.channelName,
      required this.videoToken})
      : super(key: key);

  final String videoToken;
  final String channelName;
  final String appId;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    // chatId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(), // video of current user's friend
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                  onPressed: () async {
                    print('Call ended');
                    await leaveCall();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.call_end,
                    color: Colors.red,
                    size: 50,
                  )),
            ),
            Align(
              /// video of current
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            // videoCallToolBar(muted: false, context: context),
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  // ( video of current user's friend )
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(
              channelId: widget.channelName), // <---- channel name here
        ),
      );
    } else {
      return const Text(
        '',
        textAlign: TextAlign.center,
      );
    }
  }

// Agora Initialization
  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: widget.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: widget.videoToken,
      channelId: widget.channelName, // <---- channel name here
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  leaveCall() async {
    setState(() {
      _localUserJoined = false;
      _remoteUid = null;
    });
    await _engine.leaveChannel();
    _engine.release();
  }
}
