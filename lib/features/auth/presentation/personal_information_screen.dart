import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/core/utils/jwt_utils.dart';
import 'package:planthor_ios_application/core/widgets/planthor_app_bar.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/member.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/member_profile_provider.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;

  bool _populatedFromApi = false;

  @override
  void initState() {
    super.initState();
    final claims = _readClaims();

    String firstName = '';
    String lastName = '';
    if (claims?['given_name'] != null) {
      firstName = claims!['given_name'] as String;
      lastName = (claims['family_name'] as String?) ?? '';
    } else if (claims?['name'] != null) {
      final parts = (claims!['name'] as String).split(' ');
      firstName = parts.isNotEmpty ? parts.first : '';
      lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    _firstNameController = TextEditingController(text: firstName);
    _middleNameController = TextEditingController(
      text: claims?['middle_name'] as String? ?? '',
    );
    _lastNameController = TextEditingController(text: lastName);
    _emailController = TextEditingController(
      text:
          (claims?['email'] as String?) ??
          (claims?['preferred_username'] as String?) ??
          '',
    );
    _descriptionController = TextEditingController();
  }

  Map<String, dynamic>? _readClaims() {
    final token = ref.read(authProvider).valueOrNull;
    if (token == null) return null;
    try {
      return decodeJwtPayload(token.accessToken);
    } catch (_) {
      return null;
    }
  }

  void _populateFromMember(Member member) {
    if (_populatedFromApi) return;
    _populatedFromApi = true;
    _firstNameController.text = member.firstName;
    _middleNameController.text = member.middleName ?? '';
    _lastNameController.text = member.lastName;
    _descriptionController.text = member.description ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile update coming soon.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Member?>>(memberProfileProvider, (_, next) {
      final member = next.valueOrNull;
      if (member != null) _populateFromMember(member);
    });

    // Populate immediately if already resolved (e.g. cache hit)
    final memberAsync = ref.watch(memberProfileProvider);
    if (memberAsync.valueOrNull != null) {
      _populateFromMember(memberAsync.valueOrNull!);
    }

    final claims = _readClaims();
    final displayName =
        (claims?['name'] as String?) ??
        (claims?['preferred_username'] as String?) ??
        'User';

    final avatarUrl = memberAsync.valueOrNull?.pathAvatar.isNotEmpty == true
        ? memberAsync.valueOrNull!.pathAvatar
        : (claims?['avatarUrl'] as String?) ?? '';

    return Scaffold(
      appBar: const PlanthorAppBar(showBack: true),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textMain,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Update your profile details and contact information.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  _AvatarWithEdit(avatarUrl: avatarUrl),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildField('First Name', _firstNameController),
          const SizedBox(height: 20),
          _buildField('Middle Name', _middleNameController),
          const SizedBox(height: 20),
          _buildField('Last Name', _lastNameController),
          const SizedBox(height: 20),
          _buildField(
            'Email Address',
            _emailController,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
          ),
          const SizedBox(height: 20),
          _buildField('Description', _descriptionController, maxLines: 3),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.planthorBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: readOnly ? AppColors.textMuted : AppColors.textMain,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly
                ? AppColors.surfaceContainer
                : AppColors.surfaceBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.planthorBlue),
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarWithEdit extends StatelessWidget {
  const _AvatarWithEdit({required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surfaceCard, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.surfaceContainerLow,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              onBackgroundImageError: avatarUrl.isNotEmpty ? (_, _) {} : null,
              child: avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 64, color: AppColors.outline)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.planthorBlue,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surfaceCard, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
