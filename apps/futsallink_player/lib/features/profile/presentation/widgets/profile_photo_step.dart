import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/profile/presentation/cubit/profile_creation_cubit.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoStep extends StatefulWidget {
  const ProfilePhotoStep({Key? key}) : super(key: key);

  @override
  State<ProfilePhotoStep> createState() => _ProfilePhotoStepState();
}

class _ProfilePhotoStepState extends State<ProfilePhotoStep> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeStep();
  }

  void _initializeStep() {
    final state = context.read<ProfileCreationCubit>().state;
    if (state is ProfileCreationActive) {
      // Marca a etapa como válida independentemente da foto
      // já que esta etapa é opcional
      if (!state.isCurrentStepValid) {
        context.read<ProfileCreationCubit>().emit(state.copyWith(isCurrentStepValid: true));
      }
    }
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
      _uploadImage(_selectedImage!);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      _uploadImage(_selectedImage!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    await context.read<ProfileCreationCubit>().updateProfileImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocBuilder<ProfileCreationCubit, ProfileCreationState>(
                builder: (context, state) {
                  String? imageUrl;
                  bool isUploading = false;
                  String? errorMessage;

                  if (state is ProfileCreationActive) {
                    imageUrl = state.player.profileImage;
                    isUploading = state.isUploading;
                    errorMessage = state.errorMessage;
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ScreenTitle(
                        text: 'ESCOLHA SUA FOTO DE PERFIL',
                        bottomPadding: 8.0,
                      ),
                      
                      const SubtitleText(
                        text: 'Sua foto de perfil pode ser vista por outras pessoas. Escolha aquela foto com uma pegada de craque.',
                      ),
                      
                      const SizedBox(height: 48),
                      
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            _buildProfileImage(imageUrl, isUploading),
                            if (!isUploading)
                              Container(
                                decoration: BoxDecoration(
                                  color: FutsallinkColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add_a_photo, color: Colors.white),
                                  onPressed: _showImageSourceDialog,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      if (isUploading)
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text('Fazendo upload da sua foto...'),
                            ],
                          ),
                        ),
                        
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        
                      const SizedBox(height: 16),
                      
                      // Texto informativo sobre a foto ser opcional
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: FutsallinkColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Foto de perfil é opcional',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Uma boa foto de perfil aumenta suas chances de ser notado por clubes e empresários. Você pode adicionar ou alterar sua foto a qualquer momento.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Espaçamento extra no final (como nas outras telas)
                      const SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(String? imageUrl, bool isUploading) {
    final size = MediaQuery.of(context).size.width * 0.4;

    if (isUploading) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_selectedImage != null) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 80,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: FutsallinkColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher foto de perfil'),
          content: const Text('Selecione de onde você deseja obter a foto'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _takePicture();
              },
              child: const Text('Câmera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImageFromGallery();
              },
              child: const Text('Galeria'),
            ),
          ],
        );
      },
    );
  }
} 