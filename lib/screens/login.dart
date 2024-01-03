import 'package:flutter/material.dart';
import 'package:workout_app/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isLoading = false;

  void _trySubmit() {
    FocusScope.of(context).unfocus(); // close keyboard

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      print(_enteredEmail);
      print(_enteredPassword);
      // use those values to send our auth request ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please sign in to continue',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                maxLength: 30,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      const Icon(Icons.email),
                      const SizedBox(width: 5),
                      Text(
                        'EMAIL',
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12)
                              .fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _enteredEmail = value!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLength: 30,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      const Icon(Icons.lock),
                      const SizedBox(width: 5),
                      Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12)
                              .fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _enteredPassword = value!,
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    onPressed: _trySubmit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('LOGIN'),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (ctx) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Sign up'),
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
