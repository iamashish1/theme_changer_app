import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_changer_app/theme_bloc.dart';

void main() async {
  // A binding is a bridge between the framework and the engine.
  WidgetsFlutterBinding.ensureInitialized();
  //Fetch theme from SharedPreferences before creating ThemeBloc instance
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? savedTheme = prefs.getString('theme');
  ThemeData initialThemeToLoad =
      savedTheme == 'dark' ? ThemeData.dark() : ThemeData.light();
  //End of theme fetch

  runApp(BlocProvider<ThemeBloc>(
      //InitialThemeEvent() is invoked immediately after ThemeBloc instantiation
      // It uses the cascade operator '..' to trigger the event
      create: (context) =>
          ThemeBloc(initialThemeToLoad, prefs)..add(InitialThemeEvent()),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(builder: (context, theme) {
      return MaterialApp(
        title: 'Theme Changer App',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const MyHomePage(title: 'Theme Changer App'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: IconButton(
            icon: Icon(themeBloc.state == ThemeData.dark()
                ? Icons.toggle_on
                : Icons.toggle_off),
            onPressed: () {
              themeBloc.add(ToggleThemeEvent());
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
