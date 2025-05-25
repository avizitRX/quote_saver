import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quote_saver/widgets/Xemail_field.dart';
import 'package:quote_saver/widgets/Xpassword_field.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/message_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignupRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Saver - Sign Up'),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Future.microtask(() {
              context.go('/global-feed');
            });
          } else if (state is AuthError) {
            showMessageDialog(context, 'Authentication Error', state.message);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Your Account',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.brightness ==
                                          Brightness.light
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32.0),
                          XemailField(emailController: _emailController),
                          const SizedBox(height: 16.0),
                          XpasswordField(
                            passwordController: _passwordController,
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: state is AuthLoading ? null : _onSignup,
                            child: const Text('Sign Up'),
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed:
                                state is AuthLoading
                                    ? null
                                    : () => context.go('/'),
                            child: const Text('Already have an account? Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is AuthLoading) const LoadingIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
