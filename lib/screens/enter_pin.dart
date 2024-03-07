import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:palm_client/client_provider.dart';
import 'package:provider/provider.dart';

class EnterPin extends StatefulWidget {
  final String ip, name;
  final int port;
  const EnterPin(
      {super.key, required this.ip, required this.name, required this.port});

  @override
  State<StatefulWidget> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  final String pin = (Random().nextInt(8999) + 1000).toString();

  @override
  void initState() {
    Provider.of<ClientProvider>(context, listen: false)
        .connect(widget.ip, widget.port, pin);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, clientProvider, _) => SizedBox(
        height: 180,
        width: double.maxFinite,
        child: Column(
          children: [
            Text(
              widget.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Enter this PIN on your computer:"),
            Text(
              pin,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            OutlinedButton(
              onPressed: () {
                if (clientProvider.connection) {
                  clientProvider.disconnect();
                }
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                );
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}