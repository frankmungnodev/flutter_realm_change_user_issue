import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:realm/realm.dart';
import 'package:realm_example/home_page.dart';
import 'package:realm_example/models/realm_model.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = App(AppConfiguration("data-xuvuw"));
  final user = app.currentUser ?? await app.logIn(Credentials.anonymous());

  final appConfig = Configuration.flexibleSync(
    user,
    [
      Todo.schema,
    ],
  );
  final realm = await Realm.open(appConfig);
  realm.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.add(realm.all<Todo>());
  });

  getIt.registerSingleton<App>(app);
  getIt.registerSingleton<Realm>(realm);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realm Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
