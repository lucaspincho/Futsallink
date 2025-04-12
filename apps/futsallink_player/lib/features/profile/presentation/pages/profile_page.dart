import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/core/di/injection_container.dart';
import 'profile_screen.dart';
import '../cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        getPlayer: sl<GetPlayer>(),
        getCurrentUser: sl<GetCurrentUserUseCase>(),
      ),
      child: const ProfileScreen(),
    );
  }
} 