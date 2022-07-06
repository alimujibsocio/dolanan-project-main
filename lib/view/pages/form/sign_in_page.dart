import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_button_login_with.dart';
import '../../../app/theme.dart';
import './sign_up_page.dart';
import '../../../bLoc/auth/auth_bloc.dart';
import '../home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30.0,
          left: 24.0,
          right: 24.0,
        ),
        child: ListView(
          children: [
            Text(
              'Masuk Sekarang',
              style: kGreyTextStyle.copyWith(
                fontWeight: regular,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            Text(
              'Selamat datang di Dolanan',
              style: kBlackTextStyle.copyWith(
                fontWeight: semiBold,
                fontSize: 24,
                color: Colors.green,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            CustomTextField(
              nameTextField: 'Email',
              iconTextField: const Icon(
                Icons.markunread,
                color: Colors.black,
              ),
              controller: _emailC,
            ),
            CustomTextField(
              nameTextField: 'Password',
              iconTextField: const Icon(
                Icons.password,
                color: Colors.black,
              ),
              controller: _passwordC,
              isPassword: true,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, authState) {
                if (authState is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(authState.user),
                    ),
                    (route) => false,
                  );
                } else if (authState is AuthFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(authState.error),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return CustomButton(
                  textButton: 'Masuk',
                  onPressFunc: () {
                    context.read<AuthBloc>().add(
                          AuthSignInEvent(
                            email: _emailC.text,
                            password: _passwordC.text,
                          ),
                        );
                  },
                  buttonColor: Colors.green,
                );
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Divider(),
            const SizedBox(
              height: 10.0,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, authState) {
                if (authState is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(authState.user),
                    ),
                    (route) => false,
                  );
                } else if (authState is AuthFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(authState.error),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoadingGoogle) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    CustomButtonLoginWith(
                      textLoginWith: 'Masuk dengan Google',
                      logoLoginWith: 'assets/logo_google.png',
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthSignInWithGoogle());
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
              },
              child: Text(
                'Belum ada akun? Daftar Sekarang',
                style: kGreyTextStyle.copyWith(
                    fontWeight: light, color: Colors.green),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
