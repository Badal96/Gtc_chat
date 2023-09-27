import 'package:flutter/material.dart';
import 'package:gtc_chat/chat.dart';
import 'package:gtc_chat/login.dart';

import 'auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChnages,
      
      builder: (context, snapshot) {

        if (snapshot.hasData) return ChatPage(user: Auth().currrentUser!);

        return const Loginpage();
      },
    );
  }
}
