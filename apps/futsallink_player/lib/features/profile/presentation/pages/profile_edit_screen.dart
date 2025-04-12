import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:intl/intl.dart';
import '../cubit/profile_edit_cubit.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _currentTeamController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  
  String _position = '';
  String _dominantFoot = '';
  DateTime _birthday = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    context.read<ProfileEditCubit>().loadProfile();
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _bioController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _currentTeamController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }
  
  void _populateFields(Player player) {
    _firstNameController.text = player.firstName;
    _lastNameController.text = player.lastName;
    _nicknameController.text = player.nickname ?? '';
    _bioController.text = player.bio ?? '';
    _heightController.text = player.height.toString();
    _weightController.text = player.weight.toString();
    _currentTeamController.text = player.currentTeam ?? '';
    _position = player.position;
    _dominantFoot = player.dominantFoot;
    _birthday = player.birthday;
    _birthdayController.text = DateFormat('dd/MM/yyyy').format(player.birthday);
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: FutsallinkColors.primary,
              onPrimary: Colors.white,
              surface: Color(0xFF001E3C),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF001E3C),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(_birthday);
      });
    }
  }
  
  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileEditCubit>().saveChanges(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        nickname: _nicknameController.text,
        position: _position,
        dominantFoot: _dominantFoot,
        bio: _bioController.text,
        birthday: _birthday,
        height: int.tryParse(_heightController.text) ?? 0,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        currentTeam: _currentTeamController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001528),
      body: SafeArea(
        child: BlocConsumer<ProfileEditCubit, ProfileEditState>(
          listener: (context, state) {
            if (state is ProfileEditSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil atualizado com sucesso!'),
                  backgroundColor: FutsallinkColors.success,
                ),
              );
              Navigator.pop(context);
            } else if (state is ProfileEditError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: FutsallinkColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com voltar e título
                _buildHeader(),
                
                // Conteúdo principal
                if (state is ProfileEditLoading) 
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: FutsallinkColors.primary,
                      ),
                    ),
                  )
                else if (state is ProfileEditLoaded) 
                  _buildContent(state)
                else if (state is ProfileEditError)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: FutsallinkColors.error,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erro ao carregar perfil',
                            style: FutsallinkTypography.headline3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: FutsallinkTypography.body2.copyWith(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProfileEditCubit>().loadProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FutsallinkColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: FutsallinkSpacing.lg,
                                vertical: FutsallinkSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Expanded(
                    child: SizedBox.shrink(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FutsallinkSpacing.md,
        vertical: FutsallinkSpacing.lg,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Editar Perfil',
            style: FutsallinkTypography.headline3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProfileEditLoaded state) {
    // Inicializar os campos com os dados do player
    if (_firstNameController.text.isEmpty) {
      _populateFields(state.player);
    }
    
    return Expanded(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(FutsallinkSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de perfil
              _buildProfileImageSelector(state),
              
              const SizedBox(height: 32),
              
              // Informações básicas
              _buildBasicInfoSection(),
              
              const SizedBox(height: 24),
              
              // Informações físicas e esportivas
              _buildSportsInfoSection(),
              
              const SizedBox(height: 24),
              
              // Biografia
              _buildBiographySection(),
              
              const SizedBox(height: 32),
              
              // Botão Salvar
              _buildSaveButton(state),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSelector(ProfileEditLoaded state) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.read<ProfileEditCubit>().pickImage();
        },
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: _buildProfileImage(state),
              child: _buildProfileImagePlaceholder(state),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FutsallinkColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF001528),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  ImageProvider? _buildProfileImage(ProfileEditLoaded state) {
    if (state.selectedImage != null) {
      return FileImage(state.selectedImage!);
    } else if (state.player.profileImage != null && 
               state.player.profileImage!.isNotEmpty) {
      return NetworkImage(state.player.profileImage!);
    }
    return null;
  }
  
  Widget? _buildProfileImagePlaceholder(ProfileEditLoaded state) {
    final hasProfileImage = state.player.profileImage != null && 
                           state.player.profileImage!.isNotEmpty;
    final hasSelectedImage = state.selectedImage != null;
    
    if (!hasProfileImage && !hasSelectedImage) {
      return const Icon(
        Icons.person,
        size: 60,
        color: Colors.grey,
      );
    }
    return null;
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações Básicas',
          style: FutsallinkTypography.subtitle1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _firstNameController,
          label: 'Nome',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nome é obrigatório';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _lastNameController,
          label: 'Sobrenome',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Sobrenome é obrigatório';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nicknameController,
          label: 'Apelido (opcional)',
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: _buildTextField(
              controller: _birthdayController,
              label: 'Data de Nascimento',
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: Colors.grey,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Data de nascimento é obrigatória';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSportsInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações Esportivas',
          style: FutsallinkTypography.subtitle1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Posição',
          value: _position,
          items: const [
            'Goleiro',
            'Fixo',
            'Ala esquerda',
            'Ala direita',
            'Pivô',
            'Ponta direita',
            'Ponta esquerda',
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _position = value;
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Posição é obrigatória';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Pé Dominante',
          value: _dominantFoot,
          items: const ['Direito', 'Esquerdo'],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _dominantFoot = value;
              });
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pé dominante é obrigatório';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _currentTeamController,
          label: 'Time Atual (opcional)',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _heightController,
                label: 'Altura (cm)',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Altura é obrigatória';
                  }
                  final height = int.tryParse(value);
                  if (height == null || height < 100 || height > 250) {
                    return 'Altura inválida';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _weightController,
                label: 'Peso (kg)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Peso é obrigatório';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 150) {
                    return 'Peso inválido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBiographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biografia',
          style: FutsallinkTypography.subtitle1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _bioController,
          label: 'Conte um pouco sobre você (opcional)',
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildSaveButton(ProfileEditLoaded state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isUpdating ? null : _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: FutsallinkColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: FutsallinkColors.primary.withOpacity(0.5),
        ),
        child: state.isUpdating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Salvando...',
                    style: FutsallinkTypography.button.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                'Salvar alterações',
                style: FutsallinkTypography.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: FutsallinkTypography.body1.copyWith(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: FutsallinkTypography.body2.copyWith(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF001E3C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isNotEmpty ? value : null,
      style: FutsallinkTypography.body1.copyWith(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: FutsallinkTypography.body2.copyWith(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF001E3C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      dropdownColor: const Color(0xFF001E3C),
    );
  }
} 