import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LudoAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _speechToText = SpeechToText();
  var _recognizedWords = '';
  List<LocaleName> _locales = [];
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _getCorrectLocale();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _getCorrectLocale() async {
    _locales = await _speechToText.locales();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onWordsRecognized);
    setState(() {});
  }

  void _stopListening() async {
    _recognizedWords = '';
    await _speechToText.stop();
    setState(() {});
  }

  void _onWordsRecognized(SpeechRecognitionResult result) {
    setState(() {
      _recognizedWords += ' ${result.recognizedWords}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Ludo AI'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  for (var locale in _locales)
                    Text('${locale.localeId} - ${locale.name}'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(50),
                      backgroundColor: _speechToText.isListening
                          ? ButtonTheme.of(context).colorScheme!.onPrimary
                          : ButtonTheme.of(context).colorScheme!.primary,
                    ),
                    child: _speechToText.isListening
                        ? Icon(Icons.mic, size: 50, color: Colors.red)
                        : Icon(Icons.mic_off, size: 50, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _speechToText.isNotListening
                            ? _startListening()
                            : _stopListening();
                      });
                    },
                  ),
                  Text(_speechEnabled ? _recognizedWords : 'Listening not available'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
