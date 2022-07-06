import 'package:ali_project_app/bLoc/auth/auth_bloc.dart';
import 'package:ali_project_app/bLoc/cubit/videos_cubit.dart';
import 'package:ali_project_app/view/pages/form/sign_up_page.dart';
import 'package:ali_project_app/view/pages/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => VideosCubit(),
        ),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        routes: {
          "page_map": (context) => MapWidget(),
        },
        debugShowCheckedModeBanner: false,
        home: SignUpPage(),
      ),
    );
  }
}
