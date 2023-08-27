import 'package:flutter/material.dart';
import 'package:my_duties/Models/item.dart';

final fKey = GlobalKey<FormState>();

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final nMController = TextEditingController();
  final dController = TextEditingController();
  Map<Priority, String> priorityMap = {
    Priority.urgent: "Urgent",
    Priority.important: "Important",
    Priority.medium: "Medium",
    Priority.regular: "Regular"
  };

  void reset() {
    setState(() {
      priority = priorityMap[Priority.urgent]!;
    });
    nMController.clear();
    dController.clear();
  }

  String? nameMission;

  String priority = 'Urgent';

  String? details;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Return Back")),
        body: Form(
          key: fKey,
          child: Column(children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nMController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Something";
                      }
                      return null;
                    },
                    maxLines: 1,
                    maxLength: 30,
                    onSaved: (written) {
                      nameMission = written!;
                    },
                    decoration:
                        const InputDecoration(label: Text("The mission")),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                DropdownButton(
                    value: priority,
                    items: [
                      DropdownMenuItem(
                          value: priorityMap[Priority.urgent]!,
                          child: Text(priorityMap[Priority.urgent]!)),
                      DropdownMenuItem(
                          value: priorityMap[Priority.important]!,
                          child: Text(priorityMap[Priority.important]!)),
                      DropdownMenuItem(
                          value: priorityMap[Priority.medium]!,
                          child: Text(priorityMap[Priority.medium]!)),
                      DropdownMenuItem(
                          value: priorityMap[Priority.regular]!,
                          child: Text(priorityMap[Priority.regular]!)),
                    ],
                    onChanged: (newPriority) {
                      setState(() {
                        priority = newPriority!;
                      });
                    }),
              ],
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Something";
                }
                return null;
              },
              controller: dController,
              maxLines: 5,
              maxLength: 200,
              onSaved: (written) {
                details = written!;
              },
              decoration: const InputDecoration(label: Text("Details")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      reset();
                    },
                    child: const Text("Reset")),
                const SizedBox(
                  width: 3,
                ),
                ElevatedButton(
                    onPressed: () {
                      fKey.currentState!.save();
                      if (fKey.currentState!.validate()) {
                        Navigator.of(context).pop(Item(
                            id: '',
                            name: nameMission!,
                            priority: priority,
                            details: details!));
                      } else {
                        return;
                      }
                    },
                    child: const Text("Save"))
              ],
            )
          ]),
        ));
  }
}
