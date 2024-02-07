import 'package:cypher_x/app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class EntryPage extends StatelessWidget {
  final TextEditingController _tname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unlock the secrets of CipherX!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Image.asset(
                'assets/ctf.jpg', // Replace with your comic-style image asset
                height: 200.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * .25),
              child: TextField(
                controller: _tname,
                decoration: const InputDecoration(
                  labelText: 'Enter Team Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_tname.text.isEmpty) {
                  NesSnackbar.show(context,
                      type: NesSnackbarType.error,
                      text: 'Submit your team name to enter the game');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        teamName: _tname.text,
                      ), // Replace with your game page
                    ),
                  );
                }
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
