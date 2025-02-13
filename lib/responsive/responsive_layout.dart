import 'package:flutter/material.dart';
import 'package:alcurno_transcribe/providers/user_provider.dart';
import 'package:alcurno_transcribe/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  late Future<void> _refreshUserFuture;

  @override
  void initState() {
    super.initState();
    _refreshUserFuture = addData();
  }

  addData() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > webScreenSize) {
              // 600 can be changed to 900 if you want to display tablet screen with mobile screen layout
              return widget.webScreenLayout;
            }
            return widget.mobileScreenLayout;
          });
        }
      },
    );
  }
}
