import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

//import bubble:
import 'package:bubble/bubble.dart';

//import chat list :
import 'package:chat_list/chat_list.dart';

class ChatPage3 extends StatefulWidget {
  @override
  _ChatPage3State createState() => _ChatPage3State();
}

class _ChatPage3State extends State<ChatPage3> {
  SocketIO socketIO;
  List<String> messages;
  List<Message> messageList;
  SocketIOManager manager;

  double height, width;
  TextEditingController textController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //Initializing the message list
    messages = List<String>();
    messageList = List<Message>();

    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();

    var uuid = 1;
    //Creating the socket
    /*
    socketIO = SocketIOManager().createSocketIO('http://192.168.1.4:1010', '/',
        query: 'uid=1', socketStatusCallback: _socketStatus);
    //Call init before doing anything with socket
    */
    //https://socketio-node-flutter-app.herokuapp.com/
    socketIO = SocketIOManager().createSocketIO(
        'https://socketio-node-flutter-app.herokuapp.com', '/',
        query: 'uid=1', socketStatusCallback: _socketStatus);
    socketIO.init();

    //Connect to the socket
    socketIO.connect();

    //Subscribe to an event to listen to
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      Map<String, dynamic> data = json.decode(jsonData);
      //this.setState(() => messages.add(data['message']));
      setState(() {
        messageList.add(Message(
            content: data['message'],
            ownerType: OwnerType.receiver,
            ownerName: "Receiver"));
      });
      /*
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      */
    });

    super.initState();
  }

  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  //changing here with Bubble
  /*
  Widget buildSingleMessage(int index) {
    print("from buildSingleMessage");
    print(list_message[index]);

    return Container(
      alignment: list_message[index].owner.toString() == "sender"
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Bubble(
        color: list_message[index].owner.toString() == "sender"
            ? Color(0xFFE74C3C)
            : Color(0xFF757575),
        margin: BubbleEdges.only(top: 10, right: 10, left: 10),
        nip: list_message[index].owner.toString() == "sender"
            ? BubbleNip.rightTop
            : BubbleNip.leftTop,
        child: Text(
          list_message[index].content.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      /*
       Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          //messages[index],
          list_message[index].content.toString(),
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
      */
    );
  }
*/

/*
  Widget buildMessageList() {
    return Container(
      height: height * 0.8,
      width: width,
      child: ListView.builder(
        controller: scrollController,
        itemCount: list_message.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  */

  Widget buildMessageList() {
    return Expanded(
      flex: 5,
      child:
          ChatList(children: messageList, scrollController: _scrollController),
    );
    //);
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(5.0),
      //margin: const EdgeInsets.only(left: 10.0, right: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
        borderRadius: BorderRadius.circular(25.0),
        shape: BoxShape.rectangle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration.collapsed(
            hintText: 'Send a message...',
          ),
          controller: textController,
        ),
      ),
    );
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      //backgroundColor: Colors.deepPurple,
      backgroundColor: Color(0xFFE74C3C),
      onPressed: () {
        //Check if the textfield has text or not
        if (textController.text.isNotEmpty) {
          //Send the message as JSON data to send_message event
          socketIO.sendMessage(
              'send_message', json.encode({'message': textController.text}));
          //Add the message to the list
          //this.setState(() => messages.add(textController.text));
          setState(() {
            messageList.add(Message(
                //backgroundColor: Color(0xFFE74C3C),
                content: textController.text,
                ownerType: OwnerType.sender,
                ownerName: "Sender"));
          });
          textController.text = '';
          //Scrolldown the list to show the latest message
          /*
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn);
          */
        }
      },
      child: Icon(
        Icons.send,
        size: 30,
      ),
    );
  }

  disconnect() {
    socketIO.disconnect();
  }

  Widget buildInputArea() {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height * 0.1,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildChatInput(),
              buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: height * 0.1),
        buildMessageList(),
        buildInputArea(),
      ],
    )

        /*
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: height * 0.1),
            buildMessageList(),
            buildInputArea(),
          ],
        ),
      ),
      */
        );
  }
}
