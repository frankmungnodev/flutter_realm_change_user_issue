import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:realm_example/login_screen.dart';
import 'package:realm_example/main.dart';
import 'package:realm_example/models/realm_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final app = getIt<App>();
  final realm = getIt<Realm>();
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Realm Demo"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      expands: false,
                      decoration: const InputDecoration(
                        isDense: false,
                        labelText: "Todo title",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title cannot empty";
                        }

                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final user = app.currentUser;
                      if (user == null) return;

                      if (formKey.currentState!.validate()) {
                        realm.write(() {
                          final now = DateTime.now();
                          final todo = Todo(
                            ObjectId(),
                            controller.text.trim(),
                            false,
                            user.id.toString(),
                            now,
                            now,
                          );
                          realm.add<Todo>(todo);
                          controller.clear();
                        });
                      }
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: realm.all<Todo>().changes,
                builder: (context, snapshot) {
                  final results = snapshot.data?.results;
                  if (results == null || results.isEmpty) {
                    return const Center(
                      child: Text(
                        "You don't have any todos",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final todo = results[index];

                      return ListTile(
                        title: Text(todo.title),
                        trailing: Checkbox(
                          value: todo.completed,
                          onChanged: (value) {
                            log("value: $value");
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
