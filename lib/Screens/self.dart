import 'package:flutter/material.dart';
import 'package:my_duties/Widgets/itemWidget.dart';
import 'package:my_duties/Widgets/label.dart';
import 'package:my_duties/Screens/details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Providers/listsProvider.dart';
import 'package:my_duties/Models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class My_Self extends ConsumerStatefulWidget {
  const My_Self({super.key});

  @override
  ConsumerState<My_Self> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<My_Self> {
  final isLoading = false;
  Widget? content;

  @override
  void initState() {
    // TODO: implement initState
    reloadItemsHTTP();
    super.initState();
  }

  void reloadItemsHTTP() async {
    final urlGame = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Game.json');
    final urlSport = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Sport.json');
    final urlAnother = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Another.json');

    print("Start");
    final responseGame = await http.get(urlGame);
    final responseSport = await http.get(urlSport);
    final responseAnother = await http.get(urlAnother);
    print("End");

    if (responseGame.statusCode >= 400 ||
        responseSport.statusCode >= 400 ||
        responseAnother.statusCode >= 400) {
      print(responseGame.statusCode);
      print(responseSport.statusCode);
      print(responseAnother.statusCode);
      return;
    }
    if (responseGame.body != "null") {
      Map<String, dynamic> loadedGame = json.decode(responseGame.body);
      for (final duty in loadedGame.entries) {
        ref.read(fGameProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
    if (responseSport.body != "null") {
      Map<String, dynamic> loadedSport = json.decode(responseSport.body);
      for (final duty in loadedSport.entries) {
        ref.read(fSportProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
    if (responseAnother.body != "null") {
      Map<String, dynamic> loadedAnother = json.decode(responseAnother.body);
      for (final duty in loadedAnother.entries) {
        ref.read(fAnotherProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
  }

  void removeHTTP(Item item, List<Item> Game, List<Item> Sport) async {
    if (Game.contains(item)) {
      final urlGame = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Game/${item.id}.json');
      final response = await http.delete(urlGame);
    } else if (Sport.contains(item)) {
      final urlSport = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Sport/${item.id}.json');
      final response = await http.delete(urlSport);
    } else {
      final urlAnother = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Another/${item.id}.json');
      final response = await http.delete(urlAnother);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(fGameProvider);
    final sport = ref.watch(fSportProvider);
    final another = ref.watch(fAnotherProvider);
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Label(value: "Play Game")),
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Details();
                  }));
                  if (newItem != null) {
                    final urlGame = Uri.https(
                        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'My-Home-Game.json');

                    final response = await http.post(urlGame,
                        body: json.encode({
                          'Name': newItem.name,
                          'Priority': newItem.priority,
                          'Details': newItem.details
                        }),
                        headers: {
                          'Content-Type': 'application/json',
                        });

                    final decodedResponse = json.decode(response.body);
                    newItem.id = decodedResponse['name'];
                    ref.read(fGameProvider.notifier).addItem(newItem);
                  }
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: (game.isEmpty)
                ? const Center(child: Text("No Missions are Added Yet.."))
                : ListView(
                    children: [
                      for (final item in game)
                        Dismissible(
                          key: ValueKey(item),
                          onDismissed: (direction) {
                            removeHTTP(item, game, sport);
                            ref.read(fGameProvider.notifier).removeItem(item);
                          },
                          child: ItemWidget(item: item),
                        )
                    ],
                  )),
        Row(
          children: [
            const Expanded(child: Label(value: "Sport")),
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Details();
                  }));
                  if (newItem != null) {
                    final urlSport = Uri.https(
                        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'My-Home-Sport.json');

                    final response = await http.post(urlSport,
                        body: json.encode({
                          'Name': newItem.name,
                          'Priority': newItem.priority,
                          'Details': newItem.details
                        }),
                        headers: {
                          'Content-Type': 'application/json',
                        });

                    final decodedResponse = json.decode(response.body);
                    newItem.id = decodedResponse['name'];
                    ref.read(fSportProvider.notifier).addItem(newItem);
                  }
                },
                icon: const Icon(Icons.add))
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: (sport.isEmpty)
              ? const Center(child: Text("No Missions are Added Yet.."))
              : ListView(
                  children: [
                    for (final item in sport)
                      Dismissible(
                        key: ValueKey(item),
                        onDismissed: (direction) {
                          removeHTTP(item, game, sport);
                          ref.read(fSportProvider.notifier).removeItem(item);
                        },
                        child: ItemWidget(item: item),
                      )
                  ],
                ),
        ),
        Row(
          children: [
            const Expanded(child: Label(value: "Another Activity")),
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Details();
                  }));
                  if (newItem != null) {
                    final urlAnother = Uri.https(
                        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'My-Home-Another.json');

                    final response = await http.post(urlAnother,
                        body: json.encode({
                          'Name': newItem.name,
                          'Priority': newItem.priority,
                          'Details': newItem.details
                        }),
                        headers: {
                          'Content-Type': 'application/json',
                        });

                    final decodedResponse = json.decode(response.body);
                    newItem.id = decodedResponse['name'];
                    ref.read(fAnotherProvider.notifier).addItem(newItem);
                  }
                },
                icon: const Icon(Icons.add))
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: (another.isEmpty)
              ? const Center(child: Text("No Missions are Added Yet.."))
              : ListView(
                  children: [
                    for (final item in another)
                      Dismissible(
                        key: ValueKey(item),
                        onDismissed: (direction) {
                          removeHTTP(item, game, sport);
                          ref.read(fAnotherProvider.notifier).removeItem(item);
                        },
                        child: ItemWidget(item: item),
                      )
                  ],
                ),
        ),
      ],
    );
  }
}
