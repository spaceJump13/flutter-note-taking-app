// login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_uas/HomePage.dart';
import 'package:flutter_uas/model/pin.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<String> _pin = [];
  // final TextEditingController _pinController = TextEditingController();

  void _login() async {
    String pin = _pin.join('');
    var boxPin = Hive.box<Pin>('pinBoxes');
    var pinValue = boxPin.get('pin');

    if (pinValue != null && pinValue.pin == pin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Login Failed',
            style: TextStyle(fontSize: 22.0),
          ),
          content: const Text(
            'Invalid PIN. Please try again.',
            style: TextStyle(fontSize: 17.0),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _pin.clear();
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_pin.isNotEmpty) _pin.removeLast();
      } else if (_pin.length < 4) {
        _pin.add(value);
      }

      if (_pin.length == 4) {
        _login();
      }
    });
  }

  Widget _buildBackspaceKey() {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onKeyPressed('backspace'),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.grey[300],
          ),
          child: const Center(
            child: Icon(
              Icons.backspace,
              size: 24.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinDot({required bool filled}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        color: filled ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
      ),
    );
  }

  Widget _buildKey(String value) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onKeyPressed(value),
        child: Container(
          margin: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.grey[300],
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: AppBar(
            title: const Center(
                child: Text('LOGIN',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 25))),
            automaticallyImplyLeading: false, // Remove the back button
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return _buildPinDot(filled: index < _pin.length);
            }),
          ),
          const SizedBox(height: 40.0),
          const Text(
            'Enter PIN',
            style: TextStyle(
              fontSize: 18.0,
              color: Color.fromARGB(255, 175, 175, 175),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildKey('1'),
                    _buildKey('2'),
                    _buildKey('3'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildKey('4'),
                    _buildKey('5'),
                    _buildKey('6'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildKey('7'),
                    _buildKey('8'),
                    _buildKey('9'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    _buildKey('0'),
                    _buildBackspaceKey(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
