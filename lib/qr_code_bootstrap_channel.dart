library qr_code_bootstrap_channel;

import 'package:channel_multiplexed_scheduler/channels/abstractions/bootstrap_channel.dart';
import 'package:channel_multiplexed_scheduler/channels/channel_metadata.dart';
import 'package:channel_multiplexed_scheduler/file/file_metadata.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class QrCodeBootstrapChannel extends BootstrapChannel {
  final BuildContext context;
  QrCodeBootstrapChannel(this.context);

  @override
  Future<void> initReceiver() async {
    // TODO send event
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 1,
        maxChildSize: 1,
        builder: (context, controller) {
          return Container(
            color: Colors.red,
            child: MobileScanner(fit: BoxFit.fill, onDetect: (code, arguments) {
              debugPrint(code.rawValue);
            }),
          );
        },
      );
    });
  }

  @override
  Future<void> initSender() async {
    // no need to initialize sender
  }

  @override
  Future<void> sendChannelMetadata(ChannelMetadata data) async {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 20),
            child: const Text("Channel metadata", style: TextStyle(fontSize: 20)),
          ),
          QrImage(
            data: data.toString(),
            version: QrVersions.auto
          )
        ],
      );
    });
  }

  @override
  Future<void> sendFileMetadata(FileMetadata data) async {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 20),
            child: const Text("File metadata", style: TextStyle(fontSize: 20)),
          ),
          QrImage(
            data: data.toString(),
            version: QrVersions.auto
          )
        ],
      );
    });
  }

}