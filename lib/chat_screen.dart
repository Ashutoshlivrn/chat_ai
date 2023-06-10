
import 'package:chat_gpt_02/threedots.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'chatmessage.dart';




class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _noOfImage = TextEditingController();

  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;
  bool _isImageSearch = false;

  bool _isTyping = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: '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',
        baseOption: HttpSetup(receiveTimeout:  600000 ));
    super.initState();
  }


  @override
  void dispose() {
    chatGPT?.close();
    chatGPT?.genImgClose();
    super.dispose();
  }

  // Link for api - https://beta.openai.com/account/api-keys

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    if (_isImageSearch) {
      final request = GenerateImage(message.text, 1 , size: "256x256");

      final response = await chatGPT!.generateImage(request);
      Vx.log(response!.data!.last!.url!);
      insertNewData(response.data!.last!.url!, isImage: true);
    } else {
      final request =
          CompleteText(prompt: message.text, model: kTranslateModelV3);

      final response = await chatGPT!.onCompleteText(request: request);
      Vx.log(response!.choices[0].text);
      insertNewData(response.choices[0].text, isImage: false);
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration(
                hintText: "Ask me!",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(19))
            ),

          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            _isImageSearch = false;
            _sendMessage();
          },
        ),
        IconButton(
          icon: const Icon(Icons.image),
          onPressed: () {
            _isImageSearch = true;
            _sendMessage();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text("Chat with AI"),
            actions: [

          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: (){
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text('Clear data'),
                actions: [
                  ElevatedButton(onPressed: (){
                    //MyApp();
                    //runApp(const MyApp());
                    setState(() {
                      _messages.clear();
                      Navigator.pop(context);
                    });
                  }, child: Text('Yes') ),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('No') ),
                ],
              ),);
            }, icon: const Icon(Icons.clear)),
        ]
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                reverse: true,
                padding: Vx.m8,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              )),
              if (_isTyping) const ThreeDots(),

              Container(
                padding: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                decoration: BoxDecoration(
                  color: context.cardColor,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }

}
