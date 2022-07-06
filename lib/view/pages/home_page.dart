import 'package:ali_project_app/bLoc/cubit/videos_cubit.dart';
import 'package:ali_project_app/view/pages/edit_profile.dart';
import 'package:ali_project_app/view/pages/form/upload_video_page.dart';
import 'package:ali_project_app/view/pages/video_player/video_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:line_icons/line_icons.dart';
import '../widgets/app_drawer.dart';
import '../../model/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage(this.user, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void loadVideos() {
    context.read<VideosCubit>().fetchVideos();
  }

  @override
  void initState() {
    loadVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 30),
          child: const Text(
            "Dolanan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconBadge(
            icon: Icon(Icons.notifications_outlined),
            itemCount: 1,
            badgeColor: Colors.red,
            itemColor: Colors.white,
            hideZero: true,
            onTap: () {
              print('notif');
            },
          )
        ],
      ),
      drawer: AppDrawer(
        idUser: widget.user.id,
        user: widget.user,
      ),
      body: BlocBuilder<VideosCubit, VideosState>(
        builder: (context, state) {
          if (state is VideosSuccess) {
            return state.videos.isEmpty
                ? const Center(
                    child: Text("Tidak ada data video"),
                  )
                : ListView.builder(
                    itemCount: state.videos.length,
                    itemBuilder: (context, index) {
                      return VideoApp(state.videos[index].videoUrl);
                    },
                  );
          } else if (state is VideosLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: [
          // NOTE: HOME MENU
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
                onTap: () {
                  print(123);
                  Navigator.pushNamed(context, "page_map");
                  // showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return AlertDialog(
                  //         title: Text("Sedang Proses"),
                  //         content: Text(
                  //             "Anda akan mendapat notifikasi jika sudah selesai"),
                  //       );
                  //     });
                },
                child: Icon(
                  LineIcons.home,
                  size: 30,
                  color: Colors.black,
                )),
          ),
          //toko
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sedang Proses"),
                        content: Text(
                            "Anda akan mendapat notifikasi jika sudah selesai"),
                      );
                    });
              },
              child: Icon(
                LineIcons.shoppingBag,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),

          // NOTE: Upload MENU
          BottomNavigationBarItem(
            label: 'Upload',
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadVideoPage(),
                  ),
                ).then((_) {
                  loadVideos();
                });
              },
              child: const Icon(
                Icons.add_box_outlined,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
//data video
          BottomNavigationBarItem(
            label: 'Video',
            icon: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sedang Proses"),
                        content: Text(
                            "Anda akan mendapat notifikasi jika sudah selesai"),
                      );
                    });
              },
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          // NOTE: PROFILE MENU
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => EditProfilePage(widget.user),
                //     )).then((value) {
                //   setState(() {});
                // });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sedang Proses"),
                        content: Text(
                            "Anda akan mendapat notifikasi jika sudah selesai"),
                      );
                    });
              },
              child: Icon(
                LineIcons.search,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
