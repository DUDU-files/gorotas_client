import 'package:flutter/material.dart';
import 'package:vans/screens/contents/profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfileContent(),
    );
  }
}
