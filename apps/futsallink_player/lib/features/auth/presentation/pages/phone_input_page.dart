import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:country_picker/country_picker.dart';
import '../bloc/auth_bloc.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({Key? key}) : super(key: key);

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isSubmitting = false;
  Country _selectedCountry = Country(
    phoneCode: '55',
    countryCode: 'BR',
    e164Sc: 55,
    geographic: true,
    level: 1,
    name: 'Brazil',
    example: '11999999999',
    displayName: 'Brazil (BR) [+55]',
    displayNameNoCountryCode: 'Brazil (BR)',
    e164Key: '55-BR-0',
    fullExampleWithPlusSign: '+5511999999999',
  );
  
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
  
  // Formata o número de telefone para exibição com espaços e traços
  String _formatPhoneNumber(String text) {
    // Implementar formatação específica baseada no país selecionado
    // Para Brasil: (99) 99999-9999
    if (_selectedCountry.countryCode == 'BR') {
      if (text.length > 2) {
        text = '(${text.substring(0, 2)}) ${text.substring(2)}';
      }
      if (text.length > 10) {
        text = '${text.substring(0, 10)}-${text.substring(10)}';
      }
    }
    return text;
  }

  void _initiateVerification() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      // Remove todos os caracteres não numéricos
      final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
      
      // Formato E.164 com o código do país
      final phoneNumber = '+${_selectedCountry.phoneCode}$cleanPhone';
      
      context.read<AuthBloc>().add(
        InitiatePhoneVerificationEvent(
          phoneNumber: phoneNumber,
        ),
      );
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira seu número de telefone';
    }
    
    // Removendo caracteres não numéricos para validação
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    // Verificação básica de comprimento mínimo
    if (digitsOnly.length < 8) {
      return 'Digite um número de telefone válido';
    }
    
    // Verificação específica para Brasil
    if (_selectedCountry.countryCode == 'BR' && digitsOnly.length < 10) {
      return 'Digite um número com DDD (mín. 10 dígitos)';
    }
    
    return null;
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        // Tema escuro para o seletor de países
        backgroundColor: FutsallinkColors.darkBackground,
        textStyle: FutsallinkTypography.body1.copyWith(
          color: Colors.white,
        ),
        searchTextStyle: FutsallinkTypography.body1.copyWith(
          color: Colors.white,
        ),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        inputDecoration: InputDecoration(
          hintText: 'Buscar país',
          hintStyle: FutsallinkTypography.body1.copyWith(
            color: Colors.white70,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white70,
          ),
          filled: true,
          fillColor: FutsallinkColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      showPhoneCode: true, 
      searchAutofocus: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          // Limpa o campo do telefone ao trocar de país para evitar formatação incorreta
          _phoneController.clear();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            setState(() {
              _isSubmitting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PhoneVerificationSentState) {
            final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
            final phoneNumber = '+${_selectedCountry.phoneCode}$cleanPhone';
            
            Navigator.pushNamed(
              context, 
              '/phone-verification',
              arguments: {
                'verificationId': state.verificationId,
                'phoneNumber': phoneNumber,
              },
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomLogoHeader(
                        showBackButton: true,
                        onBackPressed: () => Navigator.of(context).pop(),
                        bottomPadding: 60,
                      ),
                      
                      const SizedBox(height: FutsallinkSpacing.lg),
                      
                      const ScreenTitle(
                        text: 'Verificação por Telefone',
                        bottomPadding: 8.0,
                      ),
                      const SizedBox(height: FutsallinkSpacing.sm),
                      const SubtitleText(
                        text: 'Enviaremos um código de verificação por SMS',
                      ),
                      
                      const SizedBox(height: FutsallinkSpacing.xl),
                      
                      InkWell(
                        onTap: _showCountryPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: FutsallinkColors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedCountry.flagEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedCountry.name,
                                      style: FutsallinkTypography.body1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '+${_selectedCountry.phoneCode}',
                                      style: FutsallinkTypography.body2.copyWith(
                                        color: Colors.amberAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: _selectedCountry.example,
                          prefixIcon: const Icon(Icons.phone, color: Colors.white54),
                          filled: true,
                          fillColor: FutsallinkColors.cardBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: FutsallinkTypography.body1.copyWith(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              // Limita o número máximo de dígitos com base no país
                              int maxLength = 11; // Padrão (Brasil)
                              if (_selectedCountry.countryCode != 'BR') {
                                maxLength = 15; // Outros países
                              }
                              
                              final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                              if (text.length > maxLength) {
                                return oldValue;
                              }
                              
                              // Formata o número conforme digita
                              final formattedText = _formatPhoneNumber(text);
                              return TextEditingValue(
                                text: formattedText,
                                selection: TextSelection.collapsed(offset: formattedText.length),
                              );
                            },
                          ),
                        ],
                        validator: _validatePhone,
                      ),
                      
                      const SizedBox(height: FutsallinkSpacing.xl),
                      
                      PrimaryButton(
                        text: 'ENVIAR',
                        isLoading: state is AuthLoading || _isSubmitting,
                        onPressed: state is AuthLoading || _isSubmitting ? null : _initiateVerification,
                      ),
                      
                      const SizedBox(height: FutsallinkSpacing.lg),
                      
                      Center(
                        child: CustomLink(
                          text: 'Usar verificação por e-mail',
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/email-verification');
                          },
                        ),
                      ),
                      const SizedBox(height: FutsallinkSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}