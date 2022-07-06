import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../../app/theme.dart';
import './sign_in_page.dart';
import '../../../bLoc/auth/auth_bloc.dart';
import '../home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _dateCtl = TextEditingController();
  final TextEditingController _nameCtl = TextEditingController();
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _passwordCtl = TextEditingController();
  final TextEditingController _addressCtl = TextEditingController();
  final TextEditingController _nomorHpCtl = TextEditingController();
  final TextEditingController _hobbyCtl = TextEditingController();

  // Validasi input user
  bool isValid() {
    if (_nameCtl.text.isEmpty) {
      return false;
    } else if (_emailCtl.text.isEmpty) {
      return false;
    } else if (_passwordCtl.text.isEmpty) {
      return false;
    } else if (_addressCtl.text.isEmpty) {
      return false;
    } else if (_dateCtl.text.isEmpty) {
      return false;
    } else if (_nomorHpCtl.text.isEmpty) {
      return false;
    } else if (_hobbyCtl.text.isEmpty) {
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _dateCtl.dispose();
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _addressCtl.dispose();
    _nomorHpCtl.dispose();
    _hobbyCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
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
      builder: (context, authState) {
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
                  'Daftar Sekarang',
                  style: kGreyTextStyle.copyWith(
                      fontWeight: regular, fontSize: 16, color: Colors.green),
                ),
                Text(
                  'Selamat datang di Dolanan',
                  style: kBlackTextStyle.copyWith(
                      fontWeight: semiBold, fontSize: 24, color: Colors.green),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                CustomTextField(
                  nameTextField: 'Nama Lengkap',
                  iconTextField: const Icon(
                    Icons.account_circle,
                    color: Colors.black,
                  ),
                  controller: _nameCtl,
                ),
                CustomTextField(
                  nameTextField: 'Email',
                  iconTextField: const Icon(
                    Icons.markunread,
                    color: Colors.black,
                  ),
                  controller: _emailCtl,
                ),
                CustomTextField(
                  nameTextField: 'Password',
                  iconTextField: const Icon(
                    Icons.password,
                    color: Colors.black,
                  ),
                  controller: _passwordCtl,
                  isPassword: true,
                ),

                /// Input Tanggal Lahir

                TextField(
                  controller: _dateCtl,
                  decoration: InputDecoration(
                    hintText: 'Tanggal Lahir',
                    hintStyle: kBlackTextStyle.copyWith(
                      fontWeight: regular,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 92, 92, 92),
                    ),
                    filled: true,
                    fillColor: kGreyColor,
                    suffixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                    suffixIconColor: const Color.fromARGB(255, 92, 92, 92),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: kPrimaryColor,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onTap: () async {
                    DateTime? date = DateTime(1900);
                    FocusScope.of(context).requestFocus(FocusNode());
                    date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    _dateCtl.text =
                        DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                CustomTextField(
                  nameTextField: 'Alamat',
                  iconTextField: const Icon(
                    Icons.add_home_work,
                    color: Colors.black,
                  ),
                  controller: _addressCtl,
                ),
                CustomTextField(
                  nameTextField: 'Nomor Hp',
                  iconTextField: const Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  controller: _nomorHpCtl,
                ),
                CustomTextField(
                  nameTextField: 'Hobby',
                  iconTextField:
                      const Icon(Icons.menu_book, color: Colors.black),
                  controller: _hobbyCtl,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return CustomButton(
                      textButton: 'Daftar',
                      onPressFunc: () {
                        isValid()
                            ? context.read<AuthBloc>().add(
                                  AuthRegisterEvent(
                                    name: _nameCtl.text,
                                    email: _emailCtl.text,
                                    password: _passwordCtl.text,
                                    tanggalLahir: _dateCtl.text,
                                    alamat: _addressCtl.text,
                                    nomorHp: _nomorHpCtl.text,
                                    hobby: _hobbyCtl.text,
                                  ),
                                )
                            : showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Empty Field'),
                                  content: const Text('Please fill all field'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                      },
                      buttonColor: Colors.green,
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
                          builder: (context) => const SignInPage(),
                        ));
                  },
                  child: Text(
                    'Sudah ada akun? Login Sekarang',
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
      },
    );
  }
}
