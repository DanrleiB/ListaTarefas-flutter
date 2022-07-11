import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listatarefas/pages/tarefasdetalhes.dart';
import 'package:listatarefas/pages/utils/alert.dart';
import 'package:listatarefas/pages/utils/nav.dart';
import 'package:path_provider/path_provider.dart';

class ListTarefas extends StatefulWidget {
  const ListTarefas({Key? key}) : super(key: key);

  @override
  _ListTarefasState createState() => _ListTarefasState();
}

class _ListTarefasState extends State<ListTarefas> {
  List toDolist = [];
  late Map<String, dynamic> lastRemove;
  late int lastRemovePos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        toDolist = json.decode(data!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
        backgroundColor: Colors.purple.shade800,
      ),
      body: listaDeTarefas(context),
    );
  }

  listaDeTarefas(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple.shade800)),
                    onPressed: addToDo,
                    child: const Text("ADD"))
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 15),
                itemCount: toDolist.length,
                itemBuilder: buildItem),
            onRefresh: refresh,
          ),
        )
      ],
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      background: Container(
        color: Colors.black,
        child: const Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: toDolist[index]['ok'] == 'Espera'
              ? Colors.yellow
              : toDolist[index]['ok'] == 'Andamento'
                  ? Colors.green
                  : toDolist[index]['ok'] == 'Bloqueado'
                      ? Colors.red
                      : Colors.blue,
          child: Icon(
            toDolist[index]['ok'] == 'Espera'
                ? Icons.pause
                : toDolist[index]['ok'] == 'Andamento'
                    ? Icons.play_arrow
                    : toDolist[index]['ok'] == 'Bloqueado'
                        ? Icons.block
                        : Icons.check,
            color: Colors.white,
          ),
        ),
        // onTap: () {
        //   setState(() {
        //     toDolist[index]['ok'] = !toDolist[index]['ok'];
        //     toDolist[index]['finalizado'] = finalizado();
        //     _saveData();
        //   });
        // },
        onLongPress: () => push(context, TarefaDetalde(toDolist[index])),
        title: Text(toDolist[index]["title"]),
        subtitle: Text(toDolist[index]['ok']),
        trailing: Wrap(
          children: <Widget>[
            DropdownButton<String>(
              value: toDolist[index]['ok'],
              items: const [
                DropdownMenuItem(
                  child: Text('Espera'),
                  value: 'Espera',
                ),
                DropdownMenuItem(
                  child: Text('Andamento'),
                  value: 'Andamento',
                ),
                DropdownMenuItem(
                  child: Text('Finalizado'),
                  value: 'Finalizado',
                ),
                DropdownMenuItem(
                  child: Text('Bloqueado'),
                  value: 'Bloqueado',
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  toDolist[index]['ok'] = value;
                });

                if (value == 'Finalizado') {
                  toDolist[index]['finalizado'] = finalizado();
                  _saveData();
                }
              },
            ),

            // IconButton(
            //   icon: toDolist[index]['ok']
            //       ? const Icon(Icons.play_arrow)
            //       : const Icon(Icons.check),
            //       color: toDolist[index]['ok'] ? Colors.green : Colors.blue,
            //   disabledColor: Colors.grey,
            //   onPressed:  toDolist[index]['cancel'] == false  ? () {

            //          setState(
            //             () {
            //               toDolist[index]['ok'] = !toDolist[index]['ok'];
            //               toDolist[index]['finalizado'] = finalizado();
            //               _saveData();
            //             },
            //           );
            //   } : null,
            // ),
            // Checkbox(
            //   value: toDolist[index]['ok'],
            //   onChanged: (value) {
            //     setState(
            //       () {
            //         toDolist[index]['ok'] = value;
            //         _saveData();
            //       },
            //     );
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.block, color: Colors.redAccent),
            //   disabledColor: Colors.black,
            //   onPressed: () {
            //     toDolist[index]['ok'] == false
            //         ? setState(
            //             () {
            //               toDolist[index]['cancel'] =
            //                   !toDolist[index]['cancel'];
            //             },
            //           )
            //         : null;
            //   },
            // ),
          ],
        ),
      ),
      onDismissed: (direction) {
        lastRemove = Map.from(toDolist[index]);
        lastRemovePos = index;
        setState(() {
          toDolist.removeAt(index);
        });
        _saveData();
        final snack = SnackBar(
          content: Text("Tarefa \"${lastRemove["title"]}\" Removida"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                toDolist.insert(lastRemovePos, lastRemove);
                _saveData();
              });
            },
          ),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },
    );
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      toDolist.sort((a, b) {
        if (a["ok"] && !b["ok"]) {
          return 1;
        } else if (!a["ok"] && b["ok"]) {
          return -1;
        } else {
          return 0;
        }
      });

      _saveData();
    });

    return;
  }

  addToDo() {
    alertTask(
        context,
        "kaka",
        (toDoController, startDate, endDate, description) =>
            addList(toDoController, startDate, endDate, description));
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(toDolist);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  addList(toDoController, startDate, endDate, description) {
    setState(() {
      Map<String, dynamic> newToDo = {};
      newToDo["title"] = toDoController;
      newToDo["startDate"] = startDate;
      newToDo["endDate"] = endDate;
      newToDo["description"] = description;
      newToDo["ok"] = 'Espera';
      // newToDo['comentarios'] = 'lkjl';
      //  newToDo['teste'] = [];
      toDolist.add(newToDo);
      // print(newToDo.keys);
      // print(newToDo.values);
      _saveData();
    });
  }

  finalizado() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);

    return formattedDate.toString();
  }
}
// CheckboxListTile(
//         title: Text(toDolist[index]["title"]),
//         onChanged: (value) {
//           setState(() {
//             toDolist[index]['ok'] = value;
//             _saveData();
//             push(context, TarefaDetalde(toDolist[index]));
//           });
//         },
//         value: toDolist[index]['ok'],
//         secondary: CircleAvatar(
//           backgroundColor: toDolist[index]['ok'] ? Colors.blue : Colors.red,
//           child: Icon(
//             toDolist[index]['ok'] ? Icons.check : Icons.error,
//             color: Colors.white,
//           ),
//         ),
//       ),