import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/core/di/injection_container.dart';
import 'profile_edit_screen.dart';
import '../cubit/profile_edit_cubit.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileEditCubit(
        getPlayer: sl<GetPlayer>(),
        playerRepository: sl<PlayerRepository>(),
        getCurrentUser: sl<GetCurrentUserUseCase>(),
      ),
      child: const ProfileEditScreen(),
    );
  }
} 