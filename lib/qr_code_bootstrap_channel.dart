library qr_code_bootstrap_channel;

import 'package:venice_core/channels/abstractions/bootstrap_channel.dart';
import 'package:venice_core/channels/channel_metadata.dart';
import 'package:venice_core/channels/events/bootstrap_channel_event.dart';
import 'package:venice_core/file/file_metadata.dart';
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
                // Note: if you have more than one data channel, you should
                // remove this call, as it will close QR code scanner view.
                Navigator.of(context).pop();
                on (BootstrapChannelEvent.channelMetadata, data);
              } else {
                FileMetadata data = FileMetadata(words[1], int.parse(words[2]), int.parse(words[3]));
                // Navigator.of(context).pop();
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
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Channel metadata"),
        content: SizedBox(
          width: 300,
          height: 300,
          child: QrImage(
            data: "c;$data",
            version: QrVersions.auto
          )
        ),
      );
    });

    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
  }

  @override
  Future<void> sendFileMetadata(FileMetadata data) async {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("File metadata"),
        content: SizedBox(
          width: 300,
          height: 300,
          child: QrImage(
            data: "f;$data",
            version: QrVersions.auto
          )
        ),
      );
    });

    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
  }

}