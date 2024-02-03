// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_final_fields

import 'dart:async';
// import 'dart:js_interop';

import 'package:cypher_x/core.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int k = 1;
  int _currentLevel = 1;
  String _heading =
      'Hello guys, welcome to bubhbh huesh h rhch hsr  h sh. hshbh zhbhz ucncc dk.';

  TextEditingController _password = TextEditingController();

  List<String> _hints = [
    'When the appropriate time arrives, the hint will be provided here..'
  ];

  Firestore firestore = Firestore.initialize(projectId);

  List<Map<String, dynamic>> _answers = [];

  @override
  void initState() {
    super.initState();
    getdata();
    addHints();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          NesContainer(
            label: 'CipherX',
            height: 80,
            width: double.infinity,
            child: NesRunningText(
              speed: .2,
              text: _heading,
              running: true,
              onEnd: () {
                changeHeading();
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: 216,
                  height: size.height - 96,
                  child: ListView(
                    children: buildStages(),
                  ),
                ),
                Container(
                  height: size.height - 96,
                  width: (size.width - 232) * .6,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 31, 31, 31)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Stage $_currentLevel',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Cupidatat qui quis in elit aliquip ut ad. Laboris aliquip anim ad nulla esse anim in et voluptate aliquip laborum. Cupidatat dolor officia nostrud pariatur veniam nulla velit veniam non amet voluptate deserunt nostrud occaecat. Sunt eu amet velit voluptate sunt minim officia non excepteur adipisicing.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Enter the password below..',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: (size.width - 232) * .4,
                          child: TextFormField(
                            controller: _password,
                            decoration: const InputDecoration(
                              hintText: 'CiphereX{ password }',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: (size.width - 232) * .4,
                        child: Center(
                          child: NesButton(
                            type: NesButtonType.warning,
                            onPressed: () async {
                              bool x = false;
                              await NesConfirmDialog.show(
                                      context: context,
                                      confirmLabel: 'Yes',
                                      cancelLabel: 'No',
                                      message: 'Are you sure?')
                                  .then((value) => x = value!);

                              if (x &&
                                  _password.text ==
                                      _answers[_currentLevel - 1]['password']) {
                                NesSnackbar.show(
                                  type: NesSnackbarType.success,
                                  context,
                                  text:
                                      'You successfully captured the flag $_currentLevel. Congrats',
                                );
                                await Future.delayed(
                                    const Duration(seconds: 4));
                                setState(() {
                                  _currentLevel += 1;
                                });
                                await NesDialog.show(
                                  context: context,
                                  builder: (context) {
                                    return Text(
                                        'Hello.. Welcome to stage $_currentLevel. Be ready for the challenge');
                                  },
                                );
                                _password.text = '';
                                changeHeading();
                                String defhint = _hints[0];
                                _hints.clear();
                                _hints.add(defhint);

                                addHints();
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height - 96,
                  width: (size.width - 232) * .4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Hint',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: size.height - 206,
                        child: ListView(
                          children: buildHints(),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void changeHeading() {
    return setState(() {
      _heading =
          'Stage $_currentLevel is about hdbxhud dhu x xex e e.You can cbcnr';
    });
  }

  buildStages() {
    List<Widget> x = [];
    for (var element in levels) {
      x.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: NesWindow(
          height: 150,
          title: 'Stage',
          icon: NesIcons.flag,
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                element.toString(),
                style: const TextStyle(fontSize: 50),
              ),
            ],
          ),
        ),
      ));
    }
    return x;
  }

  List<Widget> buildHints() {
    List<Widget> x = [];
    for (var element in _hints) {
      Padding p = Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          element.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      );
      x.add(p);
    }
    return x;
  }

  addHints() {
    if (_hints.length < 5) {
      Timer.periodic(const Duration(seconds: 3), (timer) {
        setState(() {
          if (_hints.length < 5) {
            _hints.add('hint ${_hints.length + 1}');
          }
        });

        if (_hints.length == 5) {
          timer.cancel(); // Cancel the timer after adding 5 hints
        }
      });
    }
  }

  void getdata() async {
    await firestore.collection('flags').orderBy('no').get().then((value) {
      for (var element in value) {
        _answers.add({'no': element['no'], 'password': element['password']});
      }
    });
    print(_answers);
  }
}
