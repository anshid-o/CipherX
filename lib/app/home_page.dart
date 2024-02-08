// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_final_fields

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cypher_x/core.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.teamName});
  String teamName;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  ValueNotifier<Duration> _eventTime =
      ValueNotifier(const Duration(minutes: 10, seconds: 34));
  List<int> levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int k = 1;

  final ValueNotifier<int> _currentPonts = ValueNotifier(100);
  final ValueNotifier<int> _currentLevel = ValueNotifier(1);
  final ValueNotifier<int> _currentReward = ValueNotifier(100);
  String _heading =
      'Hello guys, welcome to bubhbh huesh h rhch hsr  h sh. hshbh zhbhz ucncc dk.';

  TextEditingController _password = TextEditingController();

  List<String> _hints = [
    'When the appropriate time arrives, the hint will be provided here..'
  ];
  List<int> _rewardList = [
    100,
    200,
    500,
    500,
    750,
    1000,
    1000,
    1200,
    1500,
    2000
  ];
  Firestore firestore = Firestore.initialize(projectId);

  final ValueNotifier<int> _isLastTime = ValueNotifier(0);
  final ValueNotifier<int> _currentHintCount = ValueNotifier(0);
  bool _isPlayed = false;
  final List<Map<String, dynamic>> _flags = [];

  @override
  void initState() {
    super.initState();
    getdata();
    windowManager.addListener(this);
    _init();
    // addHints();
    updateTime();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  updateTime() async {
    while (!_eventTime.value.isNegative) {
      if (_eventTime.value.inMinutes < 10) {
        _isLastTime.value = 1;
      }
      if (_eventTime.value.inSeconds <= 1) {
        _isLastTime.value = 2;
        firestore.collection('results').add({
          'name': widget.teamName,
          'points': _currentPonts.value,
          'time': '3 Hourse'
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      _eventTime.value -= const Duration(seconds: 1);
    }
  }

  @override
  void onWindowClose() async {
    // TODO: implement onWindowClose

    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Are you sure you want to close this window?'),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  NesInputDialog.show(
                          context: context,
                          inputLabel: 'Submit',
                          cancelLabel: 'cancel',
                          message: 'What is CipherX password?')
                      .then((value) async {
                    if (value == 'CipherX@2024CUSAT') {
                      await windowManager.destroy();
                    } else {
                      NesSnackbar.show(context,
                          type: NesSnackbarType.error,
                          text:
                              'You are unable to exit the game until it reaches its conclusion.');
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    }
    super.onWindowClose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: _flags.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                child: ValueListenableBuilder(
                                  valueListenable: _currentLevel,
                                  builder: (context, value, child) {
                                    return Text(
                                      'Stage ${_currentLevel.value}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 20, 10),
                                    child: Text(
                                      'Level point : ${_currentReward.value}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 20),
                                child: Text(
                                  _flags[_currentLevel.value - 1]['qs'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
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
                                      hintText: 'CipherX{ password }',
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
                                      if (_password.text.isNotEmpty) {
                                        bool x = false;
                                        await NesConfirmDialog.show(
                                                context: context,
                                                confirmLabel: 'Yes',
                                                cancelLabel: 'No',
                                                message: 'Are you sure?')
                                            .then((value) => x = value!);

                                        if (x &&
                                            _password.text ==
                                                _flags[_currentLevel.value - 1]
                                                    ['password']) {
                                          if (_currentLevel.value ==
                                              _flags.length) {
                                            NesDialog.show(
                                              context: context,
                                              builder: (context) {
                                                return NesRunningText(
                                                  onEnd: () {
                                                    firestore
                                                        .collection('results')
                                                        .document(_eventTime
                                                            .value
                                                            .toString())
                                                        .update({
                                                      'name': widget.teamName,
                                                      'points':
                                                          _currentPonts.value,
                                                      'time': _eventTime.value
                                                          .toString()
                                                    });
                                                  },
                                                  textStyle:
                                                      TextStyle(fontSize: 20),
                                                  text:
                                                      'Congratulations on completing the game within the impressive time of ${0 - _eventTime.value.inHours} hour, ${10 - _eventTime.value.inMinutes % 60} minutes, and ${30 - _eventTime.value.inSeconds % 60} seconds, earning a total of ${_currentPonts.value} points! Your determination and skill have truly paid off. Well done!',
                                                );
                                              },
                                            );
                                          } else {
                                            NesSnackbar.show(
                                              type: NesSnackbarType.success,
                                              context,
                                              text:
                                                  'You successfully captured the flag ${_currentLevel.value}. Congrats',
                                            );
                                            await Future.delayed(
                                                const Duration(seconds: 2));

                                            _currentPonts.value += _rewardList[
                                                _currentLevel.value];

                                            _currentReward.value = _rewardList[
                                                _currentLevel.value];
                                            _currentLevel.value += 1;
                                            _currentHintCount.value = 0;
                                            await NesDialog.show(
                                              context: context,
                                              builder: (context) {
                                                return ValueListenableBuilder(
                                                  valueListenable:
                                                      _currentLevel,
                                                  builder:
                                                      (context, value, child) {
                                                    return Text(
                                                        'Hello.. Welcome to stage ${_currentLevel.value}. Be ready for the challenge');
                                                  },
                                                );
                                              },
                                            );
                                            _password.text = '';
                                            changeHeading();
                                            String defhint = _hints[0];
                                            _hints.clear();
                                            _hints.add(defhint);
                                          }

                                          // addHints();
                                        } else {
                                          NesSnackbar.show(context,
                                              type: NesSnackbarType.error,
                                              text:
                                                  'You entered wrong password');
                                        }
                                      }
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ),
                              ),
                              NesButton.icon(
                                type: NesButtonType.primary,
                                icon: NesIcons.audio,
                                onPressed: () {
                                  if (_isPlayed == false) {
                                    final player = AudioPlayer();
                                    player.play(AssetSource('UI.mp3'));
                                  }
                                  _isPlayed = true;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height - 96,
                          width: (size.width - 232) * .4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 20, 10),
                                        child: ValueListenableBuilder(
                                          valueListenable: _currentPonts,
                                          builder: (context, value, child) {
                                            return Text(
                                              'Available points : ${_currentPonts.value}',
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      'Hint section',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: _currentHintCount,
                                    builder: (context, value, child) {
                                      if (_currentHintCount.value == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 0, 0, 0),
                                          child: NesButton(
                                            onPressed: () async {
                                              bool x = false;
                                              await NesConfirmDialog.show(
                                                      context: context,
                                                      confirmLabel: 'Yes',
                                                      cancelLabel: 'No',
                                                      message:
                                                          'Are you sure? you are going to lose ${(((_currentLevel.value == 1 ? 100 : _rewardList[_currentLevel.value - 1]) / 10) * 4).ceil()} points for 1 hint')
                                                  .then((value) => x = value!);

                                              if (x) {
                                                _currentHintCount.value =
                                                    _currentHintCount.value + 1;
                                                _currentPonts
                                                    .value -= ((_currentLevel
                                                                    .value ==
                                                                1
                                                            ? 100
                                                            : _rewardList[
                                                                _currentLevel
                                                                        .value -
                                                                    1]) /
                                                        10 *
                                                        4)
                                                    .ceil();
                                              }
                                            },
                                            type: NesButtonType.warning,
                                            child: Text(
                                                'Unlock 1 Hint for ${(((_currentLevel.value == 1 ? 100 : _rewardList[_currentLevel.value - 1]) / 10) * 4).ceil()} points'),
                                          ),
                                        );
                                      } else if (_currentHintCount.value == 1) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Text(
                                                _flags[_currentLevel.value - 1]
                                                    ['h1'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            NesButton(
                                              onPressed: () async {
                                                if (_currentPonts.value >=
                                                    (((_currentLevel.value == 1
                                                                    ? 100
                                                                    : _rewardList[
                                                                        _currentLevel.value -
                                                                            1]) /
                                                                10) *
                                                            6)
                                                        .ceil()) {
                                                  bool x = false;
                                                  await NesConfirmDialog.show(
                                                          context: context,
                                                          confirmLabel: 'Yes',
                                                          cancelLabel: 'No',
                                                          message:
                                                              'Are you sure? you are going to lose ${(((_currentLevel.value == 1 ? 100 : _rewardList[_currentLevel.value - 1]) / 10) * 6).ceil()} points for 1 hint')
                                                      .then((value) =>
                                                          x = value!);

                                                  if (x) {
                                                    _currentHintCount.value =
                                                        _currentHintCount
                                                                .value +
                                                            1;
                                                    _currentPonts
                                                        .value -= (((_currentLevel
                                                                            .value ==
                                                                        1
                                                                    ? 100
                                                                    : _rewardList[
                                                                        _currentLevel.value -
                                                                            1]) /
                                                                10) *
                                                            6)
                                                        .ceil();
                                                  }
                                                } else {
                                                  NesSnackbar.show(context,
                                                      type:
                                                          NesSnackbarType.error,
                                                      text:
                                                          'You have no enough points');
                                                }
                                              },
                                              type: NesButtonType.warning,
                                              child: Text(
                                                  'Unlock new Hint for ${((_currentReward.value / 10) * 6).ceil()} points'),
                                            )
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Text(
                                                _flags[_currentLevel.value - 1]
                                                    ['h1'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Text(
                                                _flags[_currentLevel.value - 1]
                                                    ['h2'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),

                                  // SizedBox(
                                  //   height: size.height - 406,
                                  //   child: ListView(
                                  //     children: buildHints(),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                              ValueListenableBuilder(
                                  valueListenable: _eventTime,
                                  builder: (context, value, child) {
                                    int hours = _eventTime.value.inHours;
                                    int minutes =
                                        (_eventTime.value.inMinutes % 60);
                                    int seconds =
                                        (_eventTime.value.inSeconds % 60);

                                    String formattedTime = '';

                                    if (hours > 0) {
                                      formattedTime +=
                                          '${hours.toString().padLeft(2, '0')}:';
                                    }

                                    formattedTime +=
                                        '${minutes.toString().padLeft(2, '0')}:';
                                    formattedTime +=
                                        '${seconds.toString().padLeft(2, '0')}';

                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: NesTooltip(
                                            arrowDirection:
                                                NesTooltipArrowDirection.top,
                                            arrowPlacement:
                                                NesTooltipArrowPlacement.right,
                                            message:
                                                'The challenge will conclude upon the expiration of this time period',
                                            child: ValueListenableBuilder(
                                              valueListenable: _isLastTime,
                                              builder: (context, value, child) {
                                                return NesContainer(
                                                    width: 300,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          formattedTime,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: _isLastTime
                                                                          .value ==
                                                                      1
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .w500,
                                                              color: _isLastTime
                                                                          .value ==
                                                                      1
                                                                  ? Colors
                                                                      .redAccent
                                                                  : Colors
                                                                      .white),
                                                        ),
                                                        NesHourglassLoadingIndicator(),
                                                      ],
                                                    ));
                                              },
                                            )

                                            // NesButton.iconText(
                                            //   text: formattedTime,

                                            //   type: NesButtonType.primary,
                                            //   icon: NesIcons.hourglassMiddle,
                                            //   onPressed: () {},
                                            // ),
                                            ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void changeHeading() {
    return setState(() {
      _heading =
          'Stage ${_currentLevel.value} is about hdbxhud dhu x xex e e.You can cbcnr';
    });
  }

  buildStages() {
    List<Widget> x = [];
    for (var element in levels.sublist(0, _flags.length)) {
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

  // addHints() {
  //   if (_hints.length < 5) {
  //     Timer.periodic(const Duration(seconds: 15), (timer) {
  //       setState(() {
  //         if (_hints.length < 5) {
  //           _hints.add('hint ${_hints.length + 1}');
  //         }
  //       });

  //       if (_hints.length == 5) {
  //         timer.cancel(); // Cancel the timer after adding 5 hints
  //       }
  //     });
  //   }
  // }

  void getdata() async {
    await firestore.collection('flags').orderBy('no').get().then((value) {
      for (var element in value) {
        _flags.add({
          'no': element['no'],
          'password': element['password'],
          'qs': element['qs'],
          'h1': element['h1'],
          'h2': element['h2']
        });
      }
    });
    setState(() {});
  }
}
