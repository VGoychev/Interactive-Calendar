import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar.dart';
import 'package:interactive_calendar_app/screens/login/login.dart';
import 'package:interactive_calendar_app/screens/register/register.dart';
import 'package:interactive_calendar_app/utils/validations/form_validation.dart';
import 'package:interactive_calendar_app/widgets/custom_textformfield.dart';

class LoginView extends StatelessWidget {
  final LoginState state;

  const LoginView(this.state, {super.key});
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: state.widget.onToggleTheme,
            icon: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: isDarkMode ? Colors.black : Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: state.formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineLarge,
                  children: [
                    const TextSpan(text: 'Sign\n'),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 78.0),
                        child: Text(
                          'In',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextFormfield(
                  controller: state.emailCtrl,
                  validator: FormValidation.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  label: 'Enter your email',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextFormfield(
                  controller: state.passCtrl,
                  validator: FormValidation.validatePassword,
                  obsecure: true,
                  keyboardType: TextInputType.text,
                  label: 'Enter your password',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: state.login, child: const Text('Log in')),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Register here.',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Register(
                                onToggleTheme: state.widget.onToggleTheme,
                                themeMode: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? ThemeMode.dark
                                    : ThemeMode.light,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                    text: 'Continue as ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                          text: 'guest.',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Calendar(
                                    onToggleTheme: state.widget.onToggleTheme,
                                    themeMode: isDarkMode
                                        ? ThemeMode.dark
                                        : ThemeMode.light,
                                  ),
                                ),
                              );
                            })
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
