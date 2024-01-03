import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _signUp() {
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

  String? _emailValidator(String? value) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
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
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
              maxLength: 30,
              validator: (value) => _emailValidator(value),
              onSaved: (value) => _enteredEmail = value!,
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLength: 30,
              controller: _passwordController,
              validator: (value) => _passwordValidator(value),
              onSaved: (value) => _enteredPassword = value!,
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLength: 30,
              validator: (value) => _confirmPasswordValidator(value),
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
                  onPressed: _signUp,
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
    );
  }
}
