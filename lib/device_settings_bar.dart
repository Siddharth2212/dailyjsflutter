import 'package:collection/collection.dart';
import 'package:daily_flutter/daily_flutter.dart';
import 'package:flutter/material.dart';

class DeviceSettingsBar extends StatefulWidget {
  const DeviceSettingsBar({super.key, required this.client});

  final CallClient client;

  @override
  State<DeviceSettingsBar> createState() => _DeviceSettingsBarState();
}

class _DeviceSettingsBarState extends State<DeviceSettingsBar> {
  bool _isSpeakerOn = true; // true for speaker, false for earpiece

  Future<void> toggleMicrophonePublishingEnabled() =>
      widget.client.setIsPublishing(
          microphone: !widget.client.publishing.microphone.isPublishing);

  Future<void> toggleCameraPublishingEnabled() => widget.client
      .setIsPublishing(camera: !widget.client.publishing.camera.isPublishing);

  Future<void> toggleMicrophoneEnabled() => widget.client
      .setInputsEnabled(microphone: !widget.client.inputs.microphone.isEnabled);

  Future<void> toggleCameraEnabled() => widget.client
      .setInputsEnabled(camera: !widget.client.inputs.camera.isEnabled);

  Future<void> toggleCameraFacingMode() => widget.client.setCameraFacingMode(
      facingMode: widget.client.inputs.camera.settings.facingMode.flipped);

  void toggleSpeakerMode() async {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });

    // Get available audio devices and find speaker/earpiece
    final availableDevices = widget.client.availableDevices.microphone;
    DeviceId? targetDeviceId;

    if (_isSpeakerOn) {
      // Switch to speaker - look for device with "Speaker" in name
      targetDeviceId = availableDevices
          .firstWhereOrNull(
              (device) => device.label.toLowerCase().contains('speaker'))
          ?.deviceId;
    } else {
      // Switch to earpiece - look for device with "Receiver" or "Earpiece" in name
      targetDeviceId = availableDevices
          .firstWhereOrNull((device) =>
              device.label.toLowerCase().contains('receiver') ||
              device.label.toLowerCase().contains('earpiece'))
          ?.deviceId;
    }

    if (targetDeviceId != null) {
      final messenger = ScaffoldMessenger.of(context);
      await widget.client.setAudioDevice(deviceId: targetDeviceId);
      final audioDevice = availableDevices.firstWhereOrNull(
        (device) => device.deviceId == targetDeviceId,
      );
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('${audioDevice?.label} selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputs = CallClientState.inputsOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Speaker/Earpiece toggle with device selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(
                  _isSpeakerOn ? Icons.volume_up : Icons.phone_in_talk,
                  color: Colors.black,
                ),
                onPressed: toggleSpeakerMode,
              ),
            ),
          ),
          // Microphone button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(
                  inputs.microphone.isEnabled
                      ? Icons.mic_none_outlined
                      : Icons.mic_off_outlined,
                  color: Colors.black,
                ),
                onPressed: toggleMicrophoneEnabled,
              ),
            ),
          ),
          // Disconnect call button (always red)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 53,
              height: 53,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF21010),
              ),
              child: IconButton(
                icon: const Icon(Icons.call_end, color: Colors.white),
                onPressed: () {
                  // Handle disconnect call logic
                  // This could be a leave call or disconnect logic
                  // For example:

                  //go to previous screen
                  Navigator.of(context).pop();
                  // TODO: Implement disconnect call logic
                },
              ),
            ),
          ),
          // Video camera button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(
                  inputs.camera.isEnabled
                      ? Icons.videocam_outlined
                      : Icons.videocam_off_outlined,
                  color: Colors.black,
                ),
                onPressed: toggleCameraEnabled,
              ),
            ),
          ),
          // Chat/Message button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(Icons.chat_outlined, color: Colors.black),
                onPressed: () {
                  // TODO: Implement chat logic
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
