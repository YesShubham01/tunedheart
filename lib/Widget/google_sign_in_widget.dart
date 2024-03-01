import 'package:flutter/material.dart';

import '../Services/FireAuth Service/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback ontap_start;
  final VoidCallback ontap_stop;

  const GoogleSignInButton(
      {super.key, required this.ontap_start, required this.ontap_stop});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  _check_login() async {
    if (Authenticate.isLoggedIn()) {
      // ignore: use_build_context_synchronously
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const SelectPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed!'),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(255, 255, 255, 1)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                widget.ontap_start();
                setState(() {
                  _isSigningIn = true;
                });

                if (await Authenticate.continueWithGoogle()) {
                  _check_login();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed!'),
                      duration:
                          Duration(seconds: 3), // Adjust the duration as needed
                    ),
                  );
                }

                setState(() {
                  _isSigningIn = false;
                });
                widget.ontap_stop();
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("images/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
