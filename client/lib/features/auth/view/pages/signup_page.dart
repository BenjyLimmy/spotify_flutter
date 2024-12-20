import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/core/widgets/scrollable_form.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch - Observes and rebuilds the widget or function whenever the provider's state changes.
    // Watch AuthViewModel Provider for any state change
    final bool isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    // ref.listen - Listens to CHANGES in a provider's state and allows
    // to perform side effects (e.g., navigation, showing a dialog/snackbar).
    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          // When there is data (UserModel), i.e. signup is successful,
          // Navigate to login page
          data: (data) {
            // Get ScaffoldMessenger instance then cascades hiding and showing of the new snackbar
            // using the instance
            showSnackBar(
              context,
              'Account created successfully! Please log in.',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          error: (error, st) {
            showSnackBar(
              context,
              error.toString(),
            );
          },
          loading: () {},
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ScrollableForm(
                formKey: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up.',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(30),
                    CustomField(
                      hintText: 'Name',
                      controller: nameController,
                    ),
                    const Gap(15),
                    CustomField(
                      hintText: 'Email',
                      controller: emailController,
                    ),
                    const Gap(15),
                    CustomField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObscureText: true,
                    ),
                    const Gap(20),
                    AuthGradientButton(
                      buttonText: 'Sign Up',
                      onTap: () async {
                        // Calls validator function inside CustomField(s)
                        if (formKey.currentState!.validate()) {
                          // call read to provider to access the function
                          await ref
                              .read(authViewModelProvider.notifier)
                              .signUpUser(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        }
                      },
                    ),
                    const Gap(20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: const [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                  color: Palette.gradient2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
