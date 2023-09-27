import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtc_chat/auth.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String errorMessage = '';
  bool hidepassword = true;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  Future<void> signIn() async {
    try {
      await Auth().signin(
          email: _emailcontroller.text, 
          password: _passwordcontroller.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? '';

        _emailcontroller.clear();
        _passwordcontroller.clear();
      });
    }
  }

  Future<void> createAcc() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailcontroller.text, password: _passwordcontroller.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? '';
      });

      _emailcontroller.clear();
      _passwordcontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gtc_chat',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromARGB(31, 124, 127, 132)),
        margin: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Log in or register',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:const Color.fromARGB(222, 190, 218, 255)),
                child: TextField(
                  onTap: () => setState(() {
                    errorMessage = '';
                  }),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'email',
                  ),
                  controller: _emailcontroller,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:const  Color.fromARGB(222, 190, 218, 255)),
                child: TextField(
                  obscureText: hidepassword,
                  onTap: () => setState(() {
                    errorMessage = '';
                  }),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'password',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        hidepassword = hidepassword ? false : true;
                      }),
                      icon: Icon(hidepassword
                          ? Icons.visibility
                          : Icons.visibility_off ,color: Colors.black,),
                    ),
                  ),
                  controller: _passwordcontroller,
                ),
              ),
             
              OutlinedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: const Text('log in')),
              OutlinedButton(
                  onPressed: () {
                    createAcc();
                  },
                  child: const Text('register')),

                  Visibility(
                    visible: errorMessage == ''? false:true,
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ))
             
                  
                   
            ],
          ),
        ),
      ),
    );
  }
}
