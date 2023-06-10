import 'chat_screen.dart';
import 'package:flutter/material.dart';


class UserBotName extends StatefulWidget {
  const UserBotName({Key? key}) : super(key: key);

  @override
  State<UserBotName> createState() => _UserBotNameState();
}

class _UserBotNameState extends State<UserBotName> {
  TextEditingController user_name = TextEditingController();
  TextEditingController ai_name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('user and bot name'),),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: user_name,
            ),
            TextField(
              controller:ai_name ,
            ),
            const SizedBox( height:  10,),
            ElevatedButton(onPressed: (){
    // Navigator.of(context).push(MaterialPageRoute(builder:  (context) => ChatScreen(username: user_name.text, ainame: ai_name.text) ,));
            }, child: const Text('set names'))

          ],
        ),
      ),
    );
  }
}
