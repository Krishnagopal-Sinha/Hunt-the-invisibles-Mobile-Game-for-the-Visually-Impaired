import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 30.0,
                  )
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Information',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Divider(
                    color: Colors.white,
                    endIndent: 20.0,
                    indent: 20.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 8.0, right: 8.0, bottom: 18.0),
                        child: Column(children: [
                        Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          highlightColor: Colors.white
                          ,
                          child: Text('Click Here for Privacy Policy',
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.blue,
                              wordSpacing: 1.0,
                              letterSpacing: 1.0,

                              overflow: TextOverflow.ellipsis,
                              fontSize: screenWidth * 4.8,decoration: TextDecoration.underline,
                            ),),
                          onTap: ()=>launchUrl(Uri.parse("https://www.termsfeed.com/live/5daf69c9-c35b-4325-ac25-0b362408f0d3")),
                        ),
                      ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Recently, due to some personal incident I realised how bad the support for apps and games is for people with Vision Impairment really is. To combat this, this game app was made.\n'
                              'While this app was mainly designed for audience who are Visually Impaired, it can be enjoyed by everyone.\n',
                              maxLines: 15,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                wordSpacing: 1.0,
                                letterSpacing: 1.0,
                                overflow: TextOverflow.ellipsis,
                                fontSize: screenWidth * 4.8,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Note:\n'
                              'In case haptics/vibration is not working for you, make sure it is turned on from:\n'
                              'Settings>Sound&Vibration>Touch Vibration\n'
                              'OR,\n'
                              'Accessibility>Vibration&Haptics>Touch Feedback.',
                              maxLines: 10,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                wordSpacing: 1.0,
                                letterSpacing: 1.0,
                                overflow: TextOverflow.ellipsis,
                                fontSize: screenWidth * 4.6,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
