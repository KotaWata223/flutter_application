import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool pushNotificationEnabled = true;
  bool emailNotificationEnabled = false;
  bool soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("通知設定"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text("プッシュ通知を有効にする"),
              subtitle: Text("アプリからの通知を受け取ります"),
              value: pushNotificationEnabled,
              onChanged: (bool value) {
                setState(() {
                  pushNotificationEnabled = value;
                });
              },
              secondary: Icon(Icons.notifications_active),
            ),
            SwitchListTile(
              title: Text("メール通知を有効にする"),
              subtitle: Text("新着情報をメールで受信します"),
              value: emailNotificationEnabled,
              onChanged: (bool value) {
                setState(() {
                  emailNotificationEnabled = value;
                });
              },
              secondary: Icon(Icons.email),
            ),
            SwitchListTile(
              title: Text("通知音をオンにする"),
              subtitle: Text("通知時にサウンドを再生します"),
              value: soundEnabled,
              onChanged: (bool value) {
                setState(() {
                  soundEnabled = value;
                });
              },
              secondary: Icon(Icons.volume_up),
            ),
          ],
        ),
      ),
    );
  }
}