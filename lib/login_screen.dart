import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:realm_example/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final app = getIt<App>();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "user1@test.com");
  final passwordController = TextEditingController(text: "user1@test");

  bool isLoading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    log("isLoading: $isLoading");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                // obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot empty";
                  }
                  return null;
                },
              ),
              error != null
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      child: Text(
                        error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  login(context);
                },
                child: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      )
                    : const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
          error = null;
        });
        final credential = Credentials.emailPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        // Just login method not work so try with switchUser but result the same.
        //  await app.logIn(credential).then((value) {
        //   Navigator.pop(context);
        // });
        final newUser = await app.logIn(credential);
        app.switchUser(newUser);
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          Navigator.pop(context);
        }
      } on AppException catch (e) {
        setState(() {
          error = e.message;
          isLoading = false;
        });
      } catch (e, s) {
        log("error login", error: e, stackTrace: s);
        setState(() {
          error = "Something went wrong";
          isLoading = false;
        });
      }
    }
  }
}
