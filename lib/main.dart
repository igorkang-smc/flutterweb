import 'dart:html';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  var pool = <String>[
    "The beginning of wisdom is the ability to call things by their right names. - Confucius.",
    "Не задерживай уходящего, не прогоняй пришедшего",
    "Быстро это медленно, но без перерывов",
    "Без обыкновкенных людей не бывает великих",
    "Кто сильно желает поднятся наверх придумает лестницу",
    "Солнце не знает правых, солнце не знает неправых, солнце светит без цели кого то согреть. Нашедший себя подобен солнцу.",
    "И далёкий путь начинается с близкого",
    "Даже если меч понадобится один раз в жизни, носить его нужно всегда",
    "Горе как рванное платье, надо оставлять дома",
    "Одно доброе слово, согревает три зимних месяца",
    "Если проблему можно решить, то не стоит о ней беспокоиться, если её решить нельзя то беспокоиться о ней бесполезно",
    "Когда рисуешь ветвь нужно слышать дыхание ветра",
    "Сделай все что можешь, а в остальном положись на судьбу",
    "Чрезмерная честность граничит с глупостью",
    "В дом где смеются приходит счастье",
    "Победа приходит тому, кто вытерпит на минуту дольше чем его противник",
    "Бывает что лист тонет а камень плывёт",
    "В улыбающееся лицо стрелу не пускают",
    "Подумав решайся - решившись не думай",
    "Спросить стыдно на минуту, не знать - стыд на всю жизнь",
    "Глубокие реки неслышно текут",
    "Сильнеешь от одиночества, гибнешь от тоски",
    "Тот кто контролирует настоящее, контролирует и прошлое, а тот кто контролирует прошлое, контролирует будущее"
  ];

  var current = '';
  MyAppState() {
    var randomIndex = Random().nextInt(pool.length);
    current = pool[randomIndex];
  }

  void getNext() {
    var randomIndex = Random().nextInt(pool.length);
    current = pool[randomIndex];
    notifyListeners();
  }

  var favourites = <String>[];

  void toggleFavourite() {
    if (favourites.contains(current)) {
      favourites.remove(current);
    } else {
      favourites.add(current);
    }
    notifyListeners();
  }


}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavourite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final String pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary, fontStyle: FontStyle.italic);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair,
          style: style,
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favourites.length} favorites:'),
        ),
        for (var pair in appState.favourites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair),
          ),
      ],
    );
  }
}
