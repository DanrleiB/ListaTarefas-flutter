// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TarefaDetalde extends StatefulWidget {
  Map todolist;

  // ListTarefas todolist;
  TarefaDetalde(this.todolist, {Key? key}) : super(key: key);

  @override
  _TarefaDetadjeState createState() => _TarefaDetadjeState();
}

// ignore: recursive_getters
final comentario = TextEditingController();
// List data = [];

class _TarefaDetadjeState extends State<TarefaDetalde> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
        title: const Text("Detalhes"),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          TextFormField(
            enabled: false,
            initialValue: widget.todolist["title"],
            decoration: InputDecoration(
                labelText: "Nome da Tarefa",
                labelStyle:
                    TextStyle(color: Colors.purple.shade800, fontSize: 20)),
          ),
          TextFormField(
            enabled: false,
            initialValue: widget.todolist["startDate"],
            decoration: InputDecoration(
                labelText: "Data inicio",
                labelStyle:
                    TextStyle(color: Colors.purple.shade800, fontSize: 20)),
          ),
          TextFormField(
            enabled: false,
            initialValue: widget.todolist["endDate"],
            decoration: InputDecoration(
                labelText: "Término Previsto",
                labelStyle:
                    TextStyle(color: Colors.purple.shade800, fontSize: 20)),
          ),
          TextFormField(
            enabled: false,
            initialValue: widget.todolist['ok'] == 'Finalizado'
                ? widget.todolist['finalizado']
                : widget.todolist['ok'],
            decoration: InputDecoration(
              labelText: "Status",
              labelStyle:
                  TextStyle(color: Colors.purple.shade800, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Descrição",
            style: TextStyle(color: Colors.purple.shade800, fontSize: 15),
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.todolist['description'] != ''
                      ? "${widget.todolist["description"]}"
                      : 'Sem Descrição',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
          // SizedBox(
          //   height: 20,
          //   child: ListView.builder(
          //     itemCount: widget.todolist['teste'].length,
          //               reverse: true,
          //               itemBuilder: (context, index) {
          //                 return Text(widget.todolist['teste'].toString());
          //               },
          //   ),
          // ),
          // Text(widget.todolist["teste"].toString()),
          // SizedBox(
          //   height: 20,
          // ),
          // TextFormField(
          //   controller: comentario,
          //   keyboardType: TextInputType.text,
          //   // validator: _validateNome,
          //   style: const TextStyle(color: Colors.blue, fontSize: 15),
          //   decoration: const InputDecoration(
          //     hintText: 'Digite o comentário',
          //     labelText: 'Comentário',
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(12),
          //       ),
          //     ),
          //   ),
          //   onFieldSubmitted: (value) {
          //     data.add(value);
          //     widget.todolist['teste'] = data;
          //     print(widget.todolist);
          //    comentario.clear();
          //   }
          // ),
        ],
      ),
    );
  }
}
