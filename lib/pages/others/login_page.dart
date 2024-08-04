import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_of_meme/services/providers/meme_song_provider.dart';
import 'package:sound_of_meme/widgets/custom_textfield.dart';
import 'package:sound_of_meme/widgets/skip_button.dart';
import 'package:sound_of_meme/widgets/submit_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: const [
          SkipButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome User",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 45),
              CustomTextfield(
                hintText: "Enter your email",
                labelText: "Email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty";
                  } else if (!(value.contains("@"))) {
                    return "Invalid email";
                  }
                  return null;
                },
              ),
              if (!isLogin)
                CustomTextfield(
                  hintText: "Enter your full name",
                  labelText: "Full name",
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Full name cannot be empty";
                    }
                    return null;
                  },
                ),
              CustomTextfield(
                hintText: "Enter your password",
                labelText: "Password",
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  } else if (value.length < 6) {
                    return "Password should be atleast 6 characters";
                  }
                  return null;
                },
              ),
              SubmitButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<MemeSongProvider>(
                      context,
                      listen: false,
                    ).authFunction(
                      context,
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      userName: nameController.text.trim(),
                    );
                    
                  }
                },
              ),
              const SizedBox(height: 20),
              MaterialButton(
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLoading
                      ? "Loading..."
                      : !isLogin
                          ? "Already have an account?"
                          : "Don't have an account?",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
