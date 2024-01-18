import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/firestore/firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FireStoreClass _db = FireStoreClass();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredWeight = '';
  var _enteredHeight = '';
  String? errorMessage = '';

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus(); // close keyboard

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await Auth().createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final User? user = _auth.currentUser;
        if (user != null) {
          await _db.createNewUser(
            uid: user.uid,
            weight: _enteredWeight,
            height: _enteredHeight,
          );
        }
        if (!context.mounted) {
          return;
        }
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
          errorMessage = e.message;
        });

        if (!context.mounted) {
          return;
        }
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(errorMessage!),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
                  'Create Account',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                  const pattern =
                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                  final regExp = RegExp(pattern);

                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }

                  if (!regExp.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) => _enteredEmail = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
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
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Password must contain at least one uppercase letter';
                  }
                  if (!value.contains(RegExp(r'[a-z]'))) {
                    return 'Password must contain at least one lowercase letter';
                  }
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Password must contain at least one digit';
                  }
                  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    return 'Password must contain at least one special character';
                  }
                  return null;
                },
                onSaved: (value) => _enteredPassword = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      const Icon(Icons.lock),
                      const SizedBox(width: 5),
                      Text(
                        'CONFIRM PASSWORD',
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
                    return 'Please enter a password confirmation';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Row(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).iconTheme.color!,
                                  BlendMode.srcIn),
                              child: Image.asset('assets/weight.png'),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'WEIGHT (KG)',
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
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter your weight';
                        }
                        if (200 <= double.parse(value) ||
                            double.parse(value) <= 20) {
                          return 'Please enter a valid weight';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredWeight = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 5),
                            Text(
                              'HEIGHT (CM)',
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
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter your height';
                        }
                        if (200 <= double.parse(value) ||
                            double.parse(value) <= 20) {
                          return 'Please enter a valid height';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredHeight = value!,
                    ),
                  ),
                ],
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
                    onPressed: _isLoading ? null : _signUp,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('SIGN UP'),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
