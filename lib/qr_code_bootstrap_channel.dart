library qr_code_bootstrap_channel;

import 'package:channel_multiplexed_scheduler/channels/abstractions/bootstrap_channel.dart';
import 'package:channel_multiplexed_scheduler/channels/channel_metadata.dart';
import 'package:channel_multiplexed_scheduler/channels/events/bootstrap_channel_event.dart';
import 'package:channel_multiplexed_scheduler/file/file_metadata.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrCodeBootstrapChannel extends BootstrapChannel {
  final BuildContext context;
  QrCodeBootstrapChannel(this.context);

  @override
  Future<void> initReceiver() async {
    showModalBottomSheet(context: context, builder: (BuildContext cContext) {
      return DraggableScrollableSheet(
        initialChildSize: 1,
        maxChildSize: 1,
        builder: (dContext, controller) {
          return Container(
            color: Colors.red,
            child: MobileScanner(fit: BoxFit.fill, onDetect: (code, arguments) {
              String value = code.rawValue!;
              List<String> words = value.split(";");
              
              if (!["c", "f"].contains(words[0])) {
                throw StateError("Received packet with unknown format.");
              }
              
              if (words[0] == "c") {
                ChannelMetadata data = ChannelMetadata(words[1], words[2], words[3], words[4]);
                Navigator.of(context).pop();
                on (BootstrapChannelEvent.channelMetadata, data);
              } else {
                FileMetadata data = FileMetadata(words[1], int.parse(words[2]), int.parse(words[3]));
                Navigator.of(context).pop();
                on (BootstrapChannelEvent.fileMetadata, data);
              }
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
          Container(
            margin: const EdgeInsets.all(20),
            child: QrImage(
              data: "c;$data",
              version: QrVersions.auto
            ),
          )
        ],
      );
    });

    await Future.delayed(const Duration(seconds: 2));
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
          Container(
            margin: const EdgeInsets.all(20),
            child: QrImage(
              data: "f;$data",
              version: QrVersions.auto
            )
          )
        ],
      );
    });

    await Future.delayed(const Duration(seconds: 2));
  }

}