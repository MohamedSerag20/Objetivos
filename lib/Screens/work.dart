import 'package:flutter/material.dart';
import 'package:my_duties/Widgets/itemWidget.dart';
import 'package:my_duties/Widgets/label.dart';
import 'package:my_duties/Screens/details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Providers/listsProvider.dart';
import 'package:my_duties/Models/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Work extends ConsumerStatefulWidget {
  const Work({super.key});

  @override
  ConsumerState<Work> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<Work> {
  final isLoading = false;
  Widget? content;

  @override
  void initState() {
    // TODO: implement initState
    reloadItemsHTTP();
    super.initState();
  }

  void reloadItemsHTTP() async {
    final urlWork = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Work.json');
    final urlSDev = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-SDev.json');

    print("Start");
    final responseWork = await http.get(urlWork);
    final responseSDec = await http.get(urlSDev);
    print("End");

    if (responseWork.statusCode >= 400 || responseSDec.statusCode >= 400) {
      print(responseWork.statusCode);
      print(responseSDec.statusCode);
      return;
    }
    if (responseWork.body != "null") {
      Map<String, dynamic> loadedWork = json.decode(responseWork.body);
      for (final duty in loadedWork.entries) {
        ref.read(fScohoolProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
    if (responseSDec.body != "null") {
      Map<String, dynamic> loadedSDev = json.decode(responseSDec.body);
      for (final duty in loadedSDev.entries) {
        ref.read(fSDevProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
  }

  void removeHTTP(Item item, List<Item> Work) async {
    if (Work.contains(item)) {
      final urlWork = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Work/${item.id}.json');
      final response = await http.delete(urlWork);
    } else {
      final urlSDev = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-SDev/${item.id}.json');
      final response = await http.delete(urlSDev);
    }
  }

  @override
  Widget build(BuildContext context) {
    final school = ref.watch(fScohoolProvider);
    final dev = ref.watch(fSDevProvider);
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Label(value: "Work/School")),
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context)
                      .push<Item>(MaterialPageRoute(builder: (context) {
                    return const Details();
                  }));
                  if (newItem != null) {
                    final urlWork = Uri.https(
                        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'My-Home-Work.json');

                    final response = await http.post(urlWork,
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
                    ref.read(fScohoolProvider.notifier).addItem(newItem);
                  }
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: (school.isEmpty)
                ? const Center(child: Text("No Missions are Added Yet.."))
                : ListView(
                    children: [
                      for (final item in school)
                        Dismissible(
                          key: ValueKey(item),
                          onDismissed: (direction) {
                            removeHTTP(item, school);
                            ref
                                .read(fScohoolProvider.notifier)
                                .removeItem(item);
                          },
                          child: ItemWidget(item: item),
                        )
                    ],
                  )),
        Row(
          children: [
            const Expanded(child: Label(value: "Self-Development")),
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context)
                      .push<Item>(MaterialPageRoute(builder: (context) {
                    return const Details();
                  }));
                  if (newItem != null) {
                    final urlSDev = Uri.https(
                        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'My-Home-SDev.json');

                    final response = await http.post(urlSDev,
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
                    ref.read(fSDevProvider.notifier).addItem(newItem);
                  }
                },
                icon: const Icon(Icons.add))
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: (dev.isEmpty)
              ? const Center(child: Text("No Missions are Added Yet.."))
              : ListView(
                  children: [
                    for (final item in dev)
                      Dismissible(
                        key: ValueKey(item),
                        onDismissed: (direction) {
                          removeHTTP(item, school);
                          ref.read(fSDevProvider.notifier).removeItem(item);
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
