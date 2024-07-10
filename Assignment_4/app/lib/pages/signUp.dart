import 'package:app/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/components/textField.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignUpScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  SignUpScreen({super.key});

  void progress(BuildContext context) {
    showDialog(context: context, builder: (context) {
      return const Center(child: CircularProgressIndicator());
    });
  }

  signUp(BuildContext context) async {
    progress(context);
    try {
      // validate inputs

      UserCredential data = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: usernameController.text, password: passwordController.text);

      if (data.user == null) {
        throw Exception(AppLocalizations.of(context)!.failedReg);
      }
      
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.regSuccess, backgroundColor: Colors.green);
    }catch (e){
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.failedReg, backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  googleSignUp() {
    print('Google clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 40, right: 30, left: 30),
          child: Column(
            children: [
              Icon(
                Icons.person_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!.happyTo,
                style: TextStyle(
                  fontSize: 12,
                  decoration: TextDecoration.none,
                  color: Colors.grey[700],
                
                ),
              ),
              SizedBox(height: 30),
              Textfield(icon: Icon(Icons.lock), controller: usernameController, hintText: AppLocalizations.of(context)!.email, obscureText: false),
              SizedBox(height: 15),
              Textfield(icon: Icon(Icons.password), controller: passwordController, hintText: AppLocalizations.of(context)!.password, obscureText: true),
              SizedBox(height: 15),
              Textfield(icon: Icon(Icons.password), controller: confirmpasswordController, hintText: AppLocalizations.of(context)!.confirmPas, obscureText: true),
              CustomButton(onTap: () => signUp(context), text: AppLocalizations.of(context)!.signIn),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Divider(thickness: .5, color: Colors.grey.shade700,)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.orCont,
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.none,
                        color: Colors.grey[700],
                      ),
                      
                    ),
                  ),
                  Expanded(child: Divider(thickness: .5, color: Colors.grey.shade700,)),
                ],
              ),
              Center(
                child: GestureDetector(
                  onTap: googleSignUp,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      border: Border.all(color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Image(
                      image: AssetImage('assets/images/google.png'),
                      height: 60,
                    )
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