import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    if (_formkey.currentState!.validate()) {
        String email = _emailController.text;
        String password = _passwordController.text;
        if (email.isEmpty) {
          print('Email is empty');
          return;
        }
        if (password.isEmpty) {
          print('Password is empty');
          return;
        }
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ),
        );
      }
    }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: _emailController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter Your Email';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Your Password';
                }
                return null;
              },
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              _signUp();
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
