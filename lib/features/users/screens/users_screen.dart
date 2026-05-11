import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/providers/user_provider.dart';
import 'package:supermoms/src/providers/auth_provider.dart';
import 'package:supermoms/src/models/user_model.dart';
import 'package:supermoms/src/utils/hash_utils.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  InputDecoration _inputStyle(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.headerMid.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      );

  void _showEditProfileDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.displayName ?? '');
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: _inputStyle('Nom', Icons.person),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              decoration: _inputStyle('Email', Icons.email),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.headerMid,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                final userProvider = context.read<UserProvider>();
                final authProvider = context.read<AuthProvider>();

                // Vérifier si l'email a changé et s'il est unique
                if (emailController.text.toLowerCase() != user.email.toLowerCase()) {
                  final allUsers = userProvider.users; 
                  if (allUsers.any((u) => u.email.toLowerCase() == emailController.text.toLowerCase() && u.id != user.id)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cet email est déjà utilisé par un autre compte.')),
                    );
                    return;
                  }
                }

                final updatedUser = user.copyWith(
                  displayName: nameController.text,
                  email: emailController.text,
                );

                await userProvider.updateUser(updatedUser);
                await authProvider.updateCurrentUser(updatedUser);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil mis à jour avec succès')),
                  );
                }
              }
            },
            child: const Text('ENREGISTRER'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, UserModel user) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isOldVisible = false;
    bool isNewVisible = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Changer le mot de passe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: !isOldVisible,
                  decoration: _inputStyle('Mot de passe actuel', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(isOldVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => isOldVisible = !isOldVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: newPasswordController,
                  obscureText: !isNewVisible,
                  decoration: _inputStyle('Nouveau mot de passe', Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(isNewVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => isNewVisible = !isNewVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !isNewVisible,
                  decoration: _inputStyle('Confirmer le mot de passe', Icons.lock_clock),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ANNULER'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.headerMid,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                if (oldPasswordController.text.isEmpty ||
                    newPasswordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez remplir tous les champs')),
                  );
                  return;
                }

                // Vérifier l'ancien mot de passe
                if (hashPassword(oldPasswordController.text) != user.password) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le mot de passe actuel est incorrect')),
                  );
                  return;
                }

                if (newPasswordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Les nouveaux mots de passe ne correspondent pas')),
                  );
                  return;
                }

                if (newPasswordController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le mot de passe doit contenir au moins 6 caractères')),
                  );
                  return;
                }

                final updatedUser = user.copyWith(
                  password: hashPassword(newPasswordController.text),
                );

                await context.read<UserProvider>().updateUser(updatedUser);
                await context.read<AuthProvider>().updateCurrentUser(updatedUser);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mot de passe modifié avec succès')),
                  );
                }
              },
              child: const Text('MODIFIER'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              await context.read<AuthProvider>().deleteCurrentUser();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compte supprimé avec succès')),
                );
              }
            },
            child: const Text('SUPPRIMER'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          GradientHeader(
            height: 200,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.displayName ?? 'Utilisateur',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildProfileItem(
                  icon: Icons.edit_note,
                  title: 'Modifier mes informations',
                  subtitle: 'Nom, Email',
                  onTap: () => _showEditProfileDialog(context, user),
                ),
                const SizedBox(height: 15),
                _buildProfileItem(
                  icon: Icons.lock_reset,
                  title: 'Changer le mot de passe',
                  subtitle: 'Sécurité de votre compte',
                  onTap: () => _showChangePasswordDialog(context, user),
                ),
                const SizedBox(height: 15),
                _buildProfileItem(
                  icon: Icons.delete_forever,
                  title: 'Supprimer mon compte',
                  subtitle: 'Action irréversible',
                  onTap: () => _showDeleteAccountDialog(context),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => context.read<AuthProvider>().signOut(),
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text('SE DÉCONNECTER', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.headerMid.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.headerMid),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
