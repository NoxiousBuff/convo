import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hint/prototypes/phone/phone_auth_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PhoneAuthView extends StatelessWidget {
  const PhoneAuthView({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PhoneAuthViewModel>.reactive(
        viewModelBuilder: () => PhoneAuthViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: const CupertinoNavigationBar(
                middle: Text('PhoneAuth'),
              ),
              body: SizedBox(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 50),
                    if(model.phoneAuthCredential != null) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(model.phoneAuthCredential!.providerId),
                    ),
                    const Divider(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: model.phoneTech,
                      ),
                    ),
                    const Divider(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(onPressed: () => model.signUpWithPhone(), child: const Text('Sign Up')),
                    )
                  ],
                ),
              ),
            ));
  }
}
