import 'package:flutter/material.dart';
import 'package:my_duties/Widgets/itemWidget.dart';
import 'package:my_duties/Widgets/label.dart';
import 'package:my_duties/Screens/details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Providers/listsProvider.dart';
import 'package:my_duties/Models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Me_and_Allah extends ConsumerStatefulWidget {
  const Me_and_Allah({super.key});

  @override
  ConsumerState<Me_and_Allah> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<Me_and_Allah> {
  final isLoading = false;
  Widget? content;

  @override
  void initState() {
    // TODO: implement initState
    reloadItemsHTTP();
    super.initState();
  }

  void reloadItemsHTTP() async {
    final urlZaker = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Zaker.json');
    final urlDuaa = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Duaa.json');

    print("Start");
    final responseZaker = await http.get(urlZaker);
    final responseDuaa = await http.get(urlDuaa);
    print("End");

    if (responseZaker.statusCode >= 400 || responseDuaa.statusCode >= 400) {
      print(responseZaker.statusCode);
      print(responseDuaa.statusCode);
      return;
    }
    if (responseZaker.body != "null") {
      Map<String, dynamic> loadedZaker = json.decode(responseZaker.body);
      for (final duty in loadedZaker.entries) {
        ref.read(fZakerProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
    if (responseDuaa.body != "null") {
      Map<String, dynamic> loadedDuaa = json.decode(responseDuaa.body);
      for (final duty in loadedDuaa.entries) {
        ref.read(fDuaaProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
  }

  void removeHTTP(Item item, List<Item> Zaker) async {
    if (Zaker.contains(item)) {
      final urlZaker = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Zaker/${item.id}.json');
      final response = await http.delete(urlZaker);
    } else {
      final urlDuaa = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Duaa/${item.id}.json');
      final response = await http.delete(urlDuaa);
    }
  }

  @override
  Widget build(BuildContext context) {
    final zaker = ref.watch(fZakerProvider);
    final duaa = ref.watch(fDuaaProvider);
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Label(value: "Zaker")),
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Details();
                  }));
                  if (newItem != null) {
                    final urlZaker = Uri.https(
                        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'My-Home-Zaker.json');

                    final response = await http.post(urlZaker,
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
                    ref.read(fZakerProvider.notifier).addItem(newItem);
                  }
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: (zaker.isEmpty)
                ? const Center(child: Text("No Missions are Added Yet.."))
                : ListView(
                    children: [
                      for (final item in zaker)
                        Dismissible(
                          key: ValueKey(item),
                          onDismissed: (direction) {
                            removeHTTP(item, zaker);
                            ref.read(fZakerProvider.notifier).removeItem(item);
                          },
                          child: ItemWidget(item: item),
                        )
                    ],
                  )),
        Row(
          children: [
            const Expanded(child: Label(value: "Duaa")),
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const Details();
                  }));
                  if (newItem != null) {
                    final urlDuaa = Uri.https(
                        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'My-Home-Duaa.json');

                    final response = await http.post(urlDuaa,
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
                    ref.read(fDuaaProvider.notifier).addItem(newItem);
                  }
                },
                icon: const Icon(Icons.add))
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: (duaa.isEmpty)
              ? const Center(child: Text("No Missions are Added Yet.."))
              : ListView(
                  children: [
                    for (final item in duaa)
                      Dismissible(
                        key: ValueKey(item),
                        onDismissed: (direction) {
                          removeHTTP(item, zaker);
                          ref.read(fDuaaProvider.notifier).removeItem(item);
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
