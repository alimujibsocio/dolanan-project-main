import 'package:ali_project_app/view/pages/product_page.dart';
import 'package:ali_project_app/view/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ali_project_app/view/pages/edit_profile.dart';
import 'package:ali_project_app/model/user_model.dart';
import '../../app/theme.dart';
import '../pages/form/sign_in_page.dart';
import '../../bLoc/auth/auth_bloc.dart';

class AppDrawer extends StatefulWidget {
  final String idUser;
  final UserModel user;
  const AppDrawer({Key? key, required this.idUser, required this.user})
      : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    loadDataUser();
    super.initState();
  }

  loadDataUser() {
    context.read<AuthBloc>().add(AuthLoadDataUserEvent(widget.idUser));
  }

  launchWhatsApp() async {
    const link = WhatsAppUnilink(
      phoneNumber: '+6285269267157',
      text: "Selamat datang di Dolanan App, ada yang bisa dibantu?",
    );
    // ignore: deprecated_member_use
    await launch('$link');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInPage(),
              ),
              (route) => false);
        } else if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      child: Drawer(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return Column(
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(state.user.photoUrl),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  AppBar(
                    elevation: 0,
                    backgroundColor: Colors.green,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Text(
                              state.user.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'hoby: ${state.user.hobby}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Pengaturan'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(widget.user),
                          )).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.question_answer_outlined),
                    title: const Text('Kirim Masukan'),
                    onTap: () {
                      launchWhatsApp();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.star_border_outlined),
                    title: const Text('Beri Bintang'),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const ProductPage(),
                      //     ));
                    },
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthSignOutEvent());
                    },
                    child: Text(
                      'Sign out',
                      style: kGreyTextStyle.copyWith(
                          fontWeight: light, color: Colors.green),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
