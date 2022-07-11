// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

alert(BuildContext context, String msg, {Function? callback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text("ATENÇÃO"),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("SIM"),
              onPressed: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback();
                }
              },
            ),
            ElevatedButton(
              child: const Text("NÃO"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

alertAndClose(BuildContext context, String msg) {
  alert(context, msg, callback: () => Navigator.pop(context));
}

alertOk(BuildContext context, String msg, {Function? callback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text("ATENÇÃO"),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

alertTask(BuildContext context, String msg,
    callback(title, startDate, endDate, description)) {
  final toDoController = TextEditingController();
  final description = TextEditingController();
  final endDate = TextEditingController();
  final startDate = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var maksDate = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 250,
                    width: 300,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: toDoController,
                          validator: validateName,
                          decoration: InputDecoration(
                              labelText: "Nova Tarefa",
                              labelStyle:
                                  TextStyle(color: Colors.purple.shade800)),
                        ),
                        TextFormField(
                          inputFormatters: [maksDate],
                          validator: validateDate,
                          controller: startDate,
                          decoration: InputDecoration(
                              labelText: "Data inicio",
                              labelStyle:
                                  TextStyle(color: Colors.purple.shade800)),
                        ),
                        TextFormField(
                          inputFormatters: [maksDate],
                          controller: endDate,
                          validator: validateDate,
                          decoration: InputDecoration(
                              labelText: "Data de término prevista",
                              labelStyle:
                                  TextStyle(color: Colors.purple.shade800)),
                        ),
                        SizedBox(
                          height: 300,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 50),
                            child: TextFormField(
                              maxLength: 200,
                              controller: description,
                              maxLines: null,
                              decoration: InputDecoration(
                                  labelText: "Descrição",
                                  labelStyle:
                                      TextStyle(color: Colors.purple.shade800)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                
                if (_formKey.currentState!.validate()) {
                  var entrada = DateFormat('dd/MM/yyyy');
                  int anoStart = entrada.parse('${startDate.text}').year;
                  int anoEnd = entrada.parse('${endDate.text}').year;
                  int mesStart = entrada.parse('${startDate.text}').month;
                  int mesEnd = entrada.parse('${endDate.text}').month;
                  int diaStart = entrada.parse('${startDate.text}').day;
                  int diaEnd = entrada.parse('${endDate.text}').day;

                  if (anoStart < anoEnd) {
                    alertOk(
                        context, 'ano final é inferior a ano incial');
                  } else if (anoStart == anoEnd && mesStart < mesEnd) {
                    alertOk(
                        context, 'mes final é inferior a mes incial');
                  } else if (anoStart == anoEnd &&
                      mesStart == mesEnd &&
                      diaStart > diaEnd) {
                    alertOk(
                        context, 'dia final é inferior a dia incial');
                  } else {
                    callback(toDoController.text, startDate.text, endDate.text,
                        description.text);
                    Navigator.pop(context);
                  }
                }
              },
            ),
            ElevatedButton(
              child: const Text("Sair"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

String? validateName(String? value) {
  if (value!.isEmpty) {
    return 'Tarefa Invalida';
  }
  return null;
}

String? validateDate(String? value) {
  if (value!.length != 10) {
    return 'Data invalida';
  }
  var mesAux = value.substring(3, 5).toString();

  double meses = double.parse(mesAux);
  if (meses > 12) {
    return 'Data invalida';
  }
  var diaAux = value.substring(0, 2).toString();

  double dias = double.parse(diaAux);
  if (dias > 31) {
    return 'Data invalida';
  }
  if ((meses == 01 ||
          meses == 03 ||
          meses == 05 ||
          meses == 07 ||
          meses == 08 ||
          meses == 10 ||
          meses == 12) &&
      dias > 31) {
    return 'Data invalida';
  }

  if ((meses == 04 || meses == 06 || meses == 09 || meses == 11) && dias > 30) {
    return 'Data invalida';
  }

  if (meses == 02 && dias > 29) {
    return "Data invalida";
  }
  return null;
}
