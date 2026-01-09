import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:vans/providers/user_provider.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cpfController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    _nameController = TextEditingController(text: userProvider.userName);
    _emailController = TextEditingController(text: userProvider.userEmail);
    _phoneController = TextEditingController(
      text: userProvider.userData?['phone'] ?? '',
    );
    _cpfController = TextEditingController(
      text: userProvider.userData?['cpf'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final userProvider = context.read<UserProvider>();
      await userProvider.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Container(
          color: AppColors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header azul com foto
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                  decoration: const BoxDecoration(color: AppColors.primaryBlue),
                  child: Column(
                    children: [
                      // Botão editar/salvar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _isEditing ? _saveProfile : _toggleEdit,
                            icon: Icon(
                              _isEditing ? Icons.check : Icons.edit,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      // Foto do perfil
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.white,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userProvider.userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userProvider.userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Formulário
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações Pessoais',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nome
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nome completo',
                          icon: Icons.person_outline,
                          enabled: _isEditing,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite seu nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email (não editável)
                        _buildTextField(
                          controller: _emailController,
                          label: 'E-mail',
                          icon: Icons.email_outlined,
                          enabled: false,
                          helperText: 'O e-mail não pode ser alterado',
                        ),
                        const SizedBox(height: 16),

                        // Telefone
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Telefone',
                          icon: Icons.phone_outlined,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),

                        // CPF (não editável)
                        _buildTextField(
                          controller: _cpfController,
                          label: 'CPF',
                          icon: Icons.badge_outlined,
                          enabled: false,
                          helperText: 'O CPF não pode ser alterado',
                        ),
                        const SizedBox(height: 32),

                        // Botão salvar (visível apenas quando editando)
                        if (_isEditing)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOrange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Salvar Alterações',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white,
                                      ),
                                    ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Botão cancelar (visível apenas quando editando)
                        if (_isEditing)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  // Restaurar valores originais
                                  _nameController.text = userProvider.userName;
                                  _phoneController.text =
                                      userProvider.userData?['phone'] ?? '';
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: AppColors.primaryGray,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGray,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    String? helperText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperStyle: TextStyle(
          color: AppColors.primaryGray.withOpacity(0.7),
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icon,
          color: enabled ? AppColors.primaryBlue : AppColors.primaryGray,
        ),
        filled: true,
        fillColor: enabled ? AppColors.white : AppColors.backgroudGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
      ),
    );
  }
}
