import 'package:abrascadabra/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'button.dart';
import 'error_form.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key : key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String selectedOption = "Bébé né avant le terme";
  String emailToContact = "emailnumero1@bla.bla";
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController explanationController = TextEditingController();
  bool checkBoxValue = false;
  ErrorType formError = ErrorType.none;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire'),
      ),
      body: SafeArea( child :Expanded(
    child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ma demande concene :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: const Text('Bébé né avant le terme'),
              value: 'Bébé né avant le terme',
              groupValue: selectedOption,
              onChanged: (String? value){
                setState(() {
                  selectedOption = "Bébé né avant le terme";
                  emailToContact = emailPremature;
                });
              },
            ),
            RadioListTile(
              title: const Text('Bébé né sous X'),
              value: 'Bébé né sous X',
              groupValue: selectedOption,
              onChanged: (String? value) {
                setState(() {
                  selectedOption = "Bébé né sous X";
                  emailToContact = emailBornX;
                });
              },
            ),
            RadioListTile(
              title: const Text('Bébé étoile'),
              value: 'Bébé étoile',
              groupValue: selectedOption,
              onChanged: (String? value) {
                setState(() {
                  selectedOption = "Bébé étoile";
                  emailToContact = emailBabyStar;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Pseudo ou Nom',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: explanationController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Expliquez votre demande',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: checkBoxValue,
                  onChanged: (bool? value) {
                    setState(() {
                      checkBoxValue = !checkBoxValue;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'Je comprends que les données que je transmets à l\'association ne pourront pas être utilisées autrement que pour me contacter dans le cadre de l\'aide que j\'ai sollicitée',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Button(
              onPressed: () {
                submitForm();
              },
              title: 'Envoyer',
            ),
          ],
        ),
      ),
    ),
      ),
    );
  }

  void sendEmailNoErrors(ErrorType errorType, String subject, String body) {
    switch (errorType) {
      case ErrorType.emailNoValid:
        showAlert("Email non valide", "veuillez fournir un email valide", context);
        formError = ErrorType.none;
        break;
      case ErrorType.emailorphoneEmpty:
        formError = ErrorType.emailorphoneEmpty;
        showAlert("informations manquantes","Vous devez renseigner un e-mail ou un numéro de téléphone", context);
        formError = ErrorType.none;
        break;
      case ErrorType.acceptConditons:
        showAlert("Conditions générales non acceptées","Vous devez accepter les conditions générales", context);
        formError = ErrorType.none;
        break;
      case ErrorType.none:
        sendEmail(context, subject, body);
        break;
    }
  }

  Future<void> submitForm() async {
    String option = selectedOption ?? '';
    String email = emailController.text;
    String phone = phoneController.text;
    String name = nameController.text;
    String bodyEmail = explanationController.text;
    bool checkBoxChecked = checkBoxValue;

    checkCheckBox(checkBoxChecked);
    isEmailValid(email, phone);
    checkEmptyStrings(email, phone);

    sendEmailNoErrors(formError,option.toString(), bodyEmail);


  }

  void isEmailValid(String email, String phone) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    phone.isNotEmpty ? null :
    emailRegex.hasMatch(email) ? null : formError = ErrorType.emailNoValid ;
  }

  void checkEmptyStrings(String string1, String string2) {
    (string1.isEmpty || string2.isEmpty) ? null : formError = ErrorType.emailorphoneEmpty;
  }

  void checkCheckBox(bool check) {
    check ? null : formError = ErrorType.acceptConditons;
  }


  void showAlert(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme l'alerte
              },
            ),
          ],
        );
      },
    );
  }

  void sendEmail(BuildContext context, String subject, String body) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'debehogne.david@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body' : "blabla",
      }),
    );

    launchUrl(emailLaunchUri);
  }
}