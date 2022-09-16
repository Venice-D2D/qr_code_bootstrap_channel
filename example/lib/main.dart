import 'package:channel_multiplexed_scheduler/channels/channel_metadata.dart';
import 'package:channel_multiplexed_scheduler/file/file_metadata.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_bootstrap_channel/qr_code_bootstrap_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    QrCodeBootstrapChannel channel = QrCodeBootstrapChannel(context);
    FileMetadata data = FileMetadata("testName", 42000, 10);
    ChannelMetadata cData = ChannelMetadata("wifi_channel", "address", "apIdentifier", "password");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  channel.sendFileMetadata(data);
                },
                child: const Text("Send file metadata")
            ),
            ElevatedButton(
                onPressed: () {
                  channel.sendChannelMetadata(cData);
                },
                child: const Text("Send channel metadata")
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: const Divider(thickness: 1),
            ),
            ElevatedButton(
                onPressed: () {
                  channel.initReceiver();
                },
                child: const Text("Receive data metadata")
            )
          ],
        ),
      ),
    );
  }
}
