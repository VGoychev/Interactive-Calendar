import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/register/register.dart';
import 'package:interactive_calendar_app/utils/validations/form_validation.dart';
import 'package:interactive_calendar_app/widgets/custom_checkbox.dart';
import 'package:interactive_calendar_app/widgets/custom_textformfield.dart';

class RegisterView extends StatelessWidget {
  final RegisterState state;

  const RegisterView(this.state, {super.key});
  @override
  Widget build(BuildContext context) {
    final isDarkMode = state.widget.themeMode == ThemeMode.dark;
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
              const Text('Register', style: TextStyle(fontSize: 32),),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextFormfield(
                  controller: state.nameCtrl,
                  validator: FormValidation.validateName,
                  label: 'Enter your name',
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
                  label: 'Enter your password',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextFormfield(
                  controller: state.confirmPassCtrl,
                  validator: FormValidation.validatePassword,
                  obsecure: true,
                  label: 'Confirm password',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomCheckbox(
                  label: 'I agree to the terms & conditions.',
                  value: state.agreedToTerms,
                  onChanged: state.setAgreement,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: state.register, child: const Text('Register')),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
