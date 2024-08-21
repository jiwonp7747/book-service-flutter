import 'package:flutter/material.dart';

class SettingDealRange extends StatefulWidget {
  const SettingDealRange({super.key});

  @override
  State<SettingDealRange> createState() => _SettingDealRangeState();
}

class _SettingDealRangeState extends State<SettingDealRange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
        ),
      ),
    );
  }
}
