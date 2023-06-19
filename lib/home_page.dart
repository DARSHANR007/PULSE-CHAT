import 'package:animate_do/animate_do.dart';
import 'package:chat_bot/feature_box.dart';
import 'package:chat_bot/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'openai_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;

  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: Text(
            'P U L S E',
            style: GoogleFonts.exo2(fontSize: 40),
          ),
        ),

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height:10,
            ),
            // virtual assistant picture
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white)),
              child: Center(
                child: FloatingActionButton(
                    onPressed: () async {
                      if (await speechToText.hasPermission &&
                          speechToText.isNotListening) {
                        await startListening();
                      } else if (speechToText.isListening) {
                        final speech =
                            await openAIService.chatGPTAPI(lastWords);

                        generatedContent = speech;
                        setState(() {});
                        await systemSpeak(speech);

                        await stopListening();
                      } else {
                        initSpeechToText();
                      }
                    },
                    child: Icon(
                      speechToText.isListening ? Icons.stop : Icons.mic,
                    )),
              ),
            ),
            // chat bubble
            FadeInRight(
              child: Visibility(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        generatedContent == null
                            ? 'Hello, what task can I do for you?'
                            : generatedContent!,
                        style: GoogleFonts.exo2(
                            fontSize: generatedContent == null ? 25 : 18)),
                  ),
                ),
              ),
            ),

            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    'FEATURES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // features list
            Visibility(
              visible: generatedContent == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      descriptionText:
                          'Unleash the Power of Artificial Intelligence in Your Conversations. Engage in Smart, Dynamic Dialogues with our Intelligent Chatbot.',
                    ),
                  ),
                  SizedBox(height:25 ,),
                  Container(
                    height: 150,
                    width: 340,
                    decoration: BoxDecoration(
                      color:Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(child: Text("Tap the microphone to speak",style:GoogleFonts.exo2(fontSize: 20,color: Colors.black),)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
