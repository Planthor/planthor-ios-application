import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/layout/app_spacing.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/bloc/mock_plan_changes_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';

class PlanFormScreen extends ConsumerStatefulWidget {
  const PlanFormScreen({super.key, this.plan});

  final PersonalPlan? plan;

  bool get isEditing => plan != null;

  @override
  ConsumerState<PlanFormScreen> createState() => _PlanFormScreenState();
}

class _PlanFormScreenState extends ConsumerState<PlanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late String _sportType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    _nameController = TextEditingController(text: plan?.name ?? '');
    _targetController = TextEditingController(
      text: plan == null ? '' : plan.target.toStringAsFixed(1),
    );
    _sportType = _sportFromIcon(plan?.icon);
    final dates = _parseDateRange(plan?.dateRange);
    _startDate = dates.$1;
    _endDate = dates.$2;
    _nameController.addListener(_refreshSubmitState);
    _targetController.addListener(_refreshSubmitState);
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_refreshSubmitState)
      ..dispose();
    _targetController
      ..removeListener(_refreshSubmitState)
      ..dispose();
    super.dispose();
  }

  void _refreshSubmitState() => setState(() {});

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty &&
      (double.tryParse(_targetController.text) ?? 0) > 0 &&
      _startDate != null &&
      _endDate != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            label: widget.isEditing ? 'Edit Plan' : 'Create New Plan',
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin(context),
                  AppSpacing.lg,
                  AppSpacing.pageMargin(context),
                  AppSpacing.xl,
                ),
                children: [
                  const _FieldLabel('PLAN NAME'),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    key: const Key('plan-name-field'),
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      hintText: 'e.g. Summer Marathon Prep',
                    ),
                    validator: (value) {
                      final name = value?.trim() ?? '';
                      if (name.isEmpty) return 'Plan name is required';
                      if (name.length > 50) {
                        return 'Plan name cannot exceed 50 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _FieldLabel('SPORT TYPE'),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    key: const Key('sport-type-field'),
                    initialValue: _sportType,
                    decoration: _inputDecoration(
                      prefixIcon: Icon(
                        _sportIcon(_sportType),
                        color: AppColors.brandDark,
                        size: 22,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.brandDark,
                    ),
                    items: const ['Run', 'Ride', 'Swim', 'Walk']
                        .map(
                          (sport) => DropdownMenuItem(
                            value: sport,
                            child: Text(sport),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sportType = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _FieldLabel('TARGET DISTANCE'),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    key: const Key('target-distance-field'),
                    controller: _targetController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration(
                      hintText: 'e.g. 100',
                      suffixText: 'KM',
                    ),
                    validator: (value) {
                      if ((double.tryParse(value ?? '') ?? 0) <= 0) {
                        return 'Enter a target greater than 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _FieldLabel('START DATE'),
                  const SizedBox(height: AppSpacing.sm),
                  _DateField(
                    key: const Key('start-date-field'),
                    value: _startDate,
                    hintText: 'Month, Day, Year',
                    onTap: () => _selectDate(isStart: true),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const _FieldLabel('END DATE'),
                  const SizedBox(height: AppSpacing.sm),
                  _DateField(
                    key: const Key('end-date-field'),
                    value: _endDate,
                    hintText: 'Month, Day, Year',
                    onTap: () => _selectDate(isStart: false),
                    errorText: _endDate != null && _endDate!.isBefore(_today())
                        ? 'End date cannot be in the past'
                        : _startDate != null &&
                              _endDate != null &&
                              _endDate!.isBefore(_startDate!)
                        ? 'End date must be after start date'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  SizedBox(
                    height: 60,
                    child: FilledButton(
                      key: const Key('save-plan-button'),
                      onPressed: _canSubmit ? _savePlan : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        disabledBackgroundColor: AppColors.controlSurface,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        widget.isEditing ? 'UPDATE PLAN' : 'SAVE PLAN',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? now)
          : (_endDate ?? _startDate ?? now),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startDate = selected;
      } else {
        _endDate = selected;
      }
    });
  }

  void _savePlan() {
    if (!_formKey.currentState!.validate() || !_canSubmit) return;
    if (_endDate!.isBefore(_today()) || _endDate!.isBefore(_startDate!)) {
      setState(() {});
      return;
    }

    final existing = widget.plan;
    final plan = PersonalPlan(
      id:
          existing?.id ??
          'mock-${DateTime.now().microsecondsSinceEpoch.toString()}',
      name: _nameController.text.trim(),
      dateRange:
          '${_formatShortDate(_startDate!)} - ${_formatShortDate(_endDate!)}',
      current: existing?.current ?? 0,
      target: double.parse(_targetController.text),
      unit: 'km',
      icon: _sportIcon(_sportType),
      status: existing?.status ?? PlanStatus.active,
      description: existing?.description,
    );

    final notifier = ref.read(mockPlanChangesProvider.notifier);
    if (widget.isEditing) {
      notifier.update(plan);
      context.go('/plans/${plan.id}', extra: plan);
    } else {
      notifier.create(plan);
      context.go('/plans');
    }
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.montserrat(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    super.key,
    required this.value,
    required this.hintText,
    required this.onTap,
    this.errorText,
  });

  final DateTime? value;
  final String hintText;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: _inputDecoration(
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: AppColors.brandDark,
            size: 21,
          ),
          errorText: errorText,
        ),
        child: Text(
          value == null ? hintText : _formatLongDate(value!),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: value == null ? AppColors.inactive : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({
  String? hintText,
  Widget? prefixIcon,
  String? suffixText,
  String? errorText,
}) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: AppColors.borderSubtle),
  );
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixText: suffixText,
    errorText: errorText,
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.mdLg,
      vertical: AppSpacing.md,
    ),
    constraints: const BoxConstraints(minHeight: 56),
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.brand, width: 1.5),
    ),
    errorBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.destructive),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: const BorderSide(color: AppColors.destructive, width: 1.5),
    ),
    hintStyle: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.inactive,
    ),
    suffixStyle: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.brandDark,
    ),
  );
}

(DateTime?, DateTime?) _parseDateRange(String? range) {
  if (range == null || range.isEmpty) return (null, null);
  final matches = RegExp(r'(\w+)\s+(\d{1,2}),\s+(\d{4})').allMatches(range);
  if (matches.length < 2) return (null, null);
  final values = matches.take(2).map((match) {
    return DateTime(
      int.parse(match.group(3)!),
      _months.indexOf(match.group(1)!),
      int.parse(match.group(2)!),
    );
  }).toList();
  return (values[0], values[1]);
}

String _formatShortDate(DateTime date) =>
    '${_months[date.month]} ${date.day}, ${date.year}';

String _formatLongDate(DateTime date) =>
    '${_monthsLong[date.month]}, ${date.day}${_ordinal(date.day)}, ${date.year}';

String _ordinal(int day) {
  if (day >= 11 && day <= 13) return 'th';
  return switch (day % 10) {
    1 => 'st',
    2 => 'nd',
    3 => 'rd',
    _ => 'th',
  };
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

String _sportFromIcon(IconData? icon) {
  if (icon == Icons.directions_bike) return 'Ride';
  if (icon == Icons.pool) return 'Swim';
  if (icon == Icons.directions_walk) return 'Walk';
  return 'Run';
}

IconData _sportIcon(String sport) => switch (sport) {
  'Ride' => Icons.directions_bike,
  'Swim' => Icons.pool,
  'Walk' => Icons.directions_walk,
  _ => Icons.directions_run,
};

const _months = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _monthsLong = [
  '',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
