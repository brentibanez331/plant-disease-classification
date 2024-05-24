import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_gemini_bot/flutter_gemini_bot.dart';
// import 'package:flutter_gemini_bot/models/chat_model.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // List<ChatModel> chatList = [];
  String apiKey = 'AIzaSyCExCx3dKC37bbQwbnlJ_Ij7YG-3k1kwIo';
  ChatUser theUser = ChatUser(id: '1', firstName: 'Me');
  ChatUser bot = ChatUser(
      id: '2',
      firstName: 'AIgri',
      profileImage:
          'https://firebasestorage.googleapis.com/v0/b/future-graph-411205.appspot.com/o/images%2F422543472_417335294072520_5270844125157524094_n.jpg?alt=media&token=88e89813-7d30-47be-a90f-7ab5c13ec2c3');

  List<QuickReply> quickReplies = [
    QuickReply(
      title: 'What are common diseases in plants?',
      value: 'What are common diseases in plants?',
    ),
    QuickReply(
      title: 'How can I prevent anthracnose in Cashew plants?',
      value: 'How can I prevent anthracnose in Cashew plants?',
    ),
    QuickReply(
      title: 'What are the plants that grows well in my area?',
      value: 'What are the plants that grows well in my area?',
    ),
  ];

  List<QuickReply> followUpReply = [
    QuickReply(title: 'placeholder', value: ''),
  ];

  late ChatMessage initMessage;
  late ChatMessage followUpMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initMessage = ChatMessage(
        user: bot,
        createdAt: DateTime.now(),
        text:
            "Please beware of these individuals. Avoid stepping inside Banago if possible.😊😊😊",
        quickReplies: quickReplies,
        medias: [
          ChatMedia(
              type: MediaType.video,
              fileName: 'Nothing',
              url:
                  'https://firebasestorage.googleapis.com/v0/b/future-graph-411205.appspot.com/o/images%2F10000000_5755843881163427_251576254397071810_n.mp4?alt=media&token=60fda10c-ea88-43e5-8731-a8069be5ec5e'),
        ]);
    allMessages.add(initMessage);
  }

  //  = ChatMessage(
  //     user: bot,
  //     createdAt: DateTime.now(),
  //     text: "Hi, how can I be of assistance today?");

  List<ChatMessage> allMessages = [];

  // API KEY HERE

  final header = {'Content-Type': 'application/json'};

  getData(ChatMessage m) async {
    allMessages.insert(0, m);
    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    // set loading to true
    isLoading = true;
    ChatMessage m1 =
        ChatMessage(text: "Typing...", user: bot, createdAt: DateTime.now());
    allMessages.insert(0, m1);
    // dev_log.log(allMessages.toString());
    setState(() {});

    await http
        .post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        // set loading to false
        isLoading = false;
        allMessages[0] = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: bot,
            createdAt: DateTime.now(),
            quickReplies: followUpReply);
        m1.text = result['candidates'][0]['content']['parts'][0]['text'];

        // allMessages.insert(0, m1);

        followUpMessage = ChatMessage(
            user: theUser,
            createdAt: DateTime.now(),
            text:
                "[Generate a short and simple one-sentence question based on the response. Keep it less than 10 words.] ${m1.text}");
        getFollowUpData(followUpMessage);
        setState(() {});
      } else {
        print("error occured");
      }
    }).catchError((e) {});
  }

  getFollowUpData(ChatMessage m) async {
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);

        followUpReply[0].title =
            result['candidates'][0]['content']['parts'][0]['text'];
        followUpReply[0].value =
            result['candidates'][0]['content']['parts'][0]['text'];

        setState(() {});
      } else {
        print("error occured");
      }
    }).catchError((e) {});
  }

  void onTapQuickReply(QuickReply quickReply) {
    getData(ChatMessage(
      user: theUser,
      createdAt: DateTime.now(),
      text: quickReply.value!,
    ));
    followUpReply[0].title = '';
    followUpReply[0].value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ask Agronex"),
          // automaticallyImplyLeading: false,
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Center(
              child: Container(
                  width: double.infinity, // Set the desired width here
                  child: DashChat(
                    currentUser: theUser,
                    onSend: (ChatMessage m) {
                      getData(m);
                    },
                    messages: allMessages,
                    quickReplyOptions: QuickReplyOptions(
                      quickReplyBuilder: (QuickReply quickReply) {
                        return GestureDetector(
                            onTap: () => onTapQuickReply(quickReply),
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: followUpReply[0].title != ''
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                quickReply.title,
                                style: TextStyle(color: Colors.white),
                              ),
                            ));
                      },
                      quickReplyStyle: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Border color
                          width: 1.0, // Border width
                        ),
                      ),
                    ),
                  )),
            ),
            // if (isLoading)
            //   Positioned(bottom: 10, child: Text("Agronex is Typing"))
            // else
            //   SizedBox(),
          ],
        )));
  }
}
