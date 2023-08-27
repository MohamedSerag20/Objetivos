import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_duties/Widgets/itemWidget.dart';
import 'package:my_duties/Widgets/label.dart';
import 'package:my_duties/Screens/details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duties/Providers/listsProvider.dart';
import 'package:http/http.dart' as http;
import '../Models/item.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<Home> {
  bool isLoading = false;
  Widget? content;

  @override
  void initState() {
    // TODO: implement initState
    reloadItemsHTTP();
    super.initState();
  }

  void reloadItemsHTTP() async {
    final urlDuties = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Duties.json');
    final urlOrders = Uri.https(
        'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
        'My-Home-Orders.json');

    final responseDuties = await http.get(urlDuties);
    final responseOrders = await http.get(urlOrders);

    if (responseDuties.statusCode >= 400 || responseOrders.statusCode >= 400) {
      print(responseDuties.statusCode);
      return;
    }
    if (responseDuties.body != "null") {
      Map<String, dynamic> loadedDuties = json.decode(responseDuties.body);
      for (final duty in loadedDuties.entries) {
        ref.read(fDutiesProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
    if (responseOrders.body != "null") {
      Map<String, dynamic> loadedOrders = json.decode(responseOrders.body);
      for (final duty in loadedOrders.entries) {
        ref.read(fOrdersProvider.notifier).addItem(Item(
            name: duty.value["Name"],
            priority: duty.value["Priority"],
            details: duty.value["Details"],
            id: duty.key));
      }
    }
  }

  void removeHTTP(Item item, List<Item> familyDuties) async {
    if (familyDuties.contains(item)) {
      final urlDuties = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Duties/${item.id}.json');
      final response = await http.delete(urlDuties);
    } else {
      final urlOrders = Uri.https(
          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
          'My-Home-Orders/${item.id}.json');
      final response = await http.delete(urlOrders);
    }
  }

  @override
  Widget build(BuildContext context) {
    final familyDuties = ref.watch(fDutiesProvider);
    final familyOrders = ref.watch(fOrdersProvider);

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      content = Column(
        children: [
          Row(
            children: [
              const Expanded(child: Label(value: "Family Duties")),
              IconButton(
                  onPressed: () async {
                    final newItem = await Navigator.of(context)
                        .push<Item>(MaterialPageRoute(builder: (context) {
                      return const Details();
                    }));
                    if (newItem != null) {
                      final urlDuties = Uri.https(
                          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                          'My-Home-Duties.json');

                      final response = await http.post(urlDuties,
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

                      ref.read(fDutiesProvider.notifier).addItem(newItem);
                    }
                  },
                  icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
              child: (familyDuties.isEmpty)
                  ? const Center(child: Text("No Missions are Added Yet.."))
                  : ListView(
                      children: [
                        for (final item in familyDuties)
                          Dismissible(
                            key: ValueKey(item),
                            onDismissed: (direction) {
                              removeHTTP(item, familyDuties);
                              ref
                                  .read(fDutiesProvider.notifier)
                                  .removeItem(item);
                            },
                            child: ItemWidget(item: item),
                          )
                      ],
                    )),
          Row(
            children: [
              const Expanded(child: Label(value: "Family Orders")),
              IconButton(
                  onPressed: () async {
                    final newItem = await Navigator.of(context)
                        .push<Item>(MaterialPageRoute(builder: (context) {
                      return const Details();
                    }));
                    if (newItem != null) {
                      final urlOrders = Uri.https(
                          'my-duties-caca9-default-rtdb.asia-southeast1.firebasedatabase.app',
                          'My-Home-Orders.json');

                      final response = await http.post(urlOrders,
                          body: json.encode({
                            'Name': newItem.name,
                            'Priority': newItem.priority,
                            'Details': newItem.details
                          }),
                          headers: {
                            'Content-Type': 'application/json',
                          });

                      final decodedResponse = json.decode(response.body);
                      print(response.statusCode);
                      newItem.id = decodedResponse['name'];
                      print(newItem.id);

                      ref.read(fOrdersProvider.notifier).addItem(newItem);
                    }
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: (familyOrders.isEmpty)
                ? const Center(child: Text("No Missions are Added Yet.."))
                : ListView(
                    children: [
                      for (final item in familyOrders)
                        Dismissible(
                          key: ValueKey(item),
                          onDismissed: (direction) {
                            removeHTTP(item, familyDuties);
                            ref.read(fOrdersProvider.notifier).removeItem(item);
                          },
                          child: ItemWidget(item: item),
                        )
                    ],
                  ),
          ),
        ],
      );
    }

    return content!;
  }
}
