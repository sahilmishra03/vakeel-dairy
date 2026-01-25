import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Ensure these imports match your folder structure
import '../models/case_model.dart';
import '../providers/case_provider.dart';
import '../generated/app_localizations.dart';

class AddCaseScreen extends StatefulWidget {
  final CaseModel? caseModel;

  const AddCaseScreen({super.key, this.caseModel});

  @override
  State<AddCaseScreen> createState() => _AddCaseScreenState();
}

class _AddCaseScreenState extends State<AddCaseScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _caseNoController = TextEditingController();
  final TextEditingController _courtNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _opponentNameController = TextEditingController();
  final TextEditingController _judgeNameController = TextEditingController();

  // Date variables
  DateTime? _previousHearingDate;
  DateTime? _nextHearingDate;

  // Dropdown & Status State
  String? _selectedCaseType;
  String _selectedStatus = 'Active';

  // Constants
  final List<String> _caseTypes = [
    'Civil',
    'Criminal',
    'Family',
    'Corporate',
    'Appellate',
  ];

  // Modern UI Colors
  static const Color kPrimaryBlack = Color(0xFF111111);
  static const Color kInputFill = Color(0xFFF8F9FA);
  static const Color kBorderGrey = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    if (widget.caseModel != null) {
      _populateForm(widget.caseModel!);
    }
  }

  void _populateForm(CaseModel caseModel) {
    setState(() {
      _caseNoController.text = caseModel.caseNumber;
      _selectedCaseType = caseModel.caseType;
      _courtNameController.text = caseModel.courtName;
      _clientNameController.text = caseModel.clientName;
      _opponentNameController.text = caseModel.opponentName;
      _judgeNameController.text = caseModel.judgeName;
      _selectedStatus = caseModel.status;

      // Safe Date Parsing
      try {
        if (caseModel.previousHearing.isNotEmpty) {
          final parts = caseModel.previousHearing.split('-');
          _previousHearingDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
        if (caseModel.nextHearing.isNotEmpty) {
          final parts = caseModel.nextHearing.split('-');
          _nextHearingDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        debugPrint("Date parsing error: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kPrimaryBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.caseModel != null ? l10n.editCase : l10n.addCase,
          style: const TextStyle(
            color: kPrimaryBlack,
            fontWeight: FontWeight.w900, // Extra Bold
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. CASE IDENTITY ---
                _buildSectionTitle(l10n.caseDetails),

                _buildModernTextField(
                  label: l10n.caseNumber,
                  controller: _caseNoController,
                  hint: "e.g. CR-2024-892",
                  icon: Icons.tag,
                  isBold: true, // Emphasize Case No
                ),

                const SizedBox(height: 20),

                Row(children: [Expanded(child: _buildCaseTypeSelector())]),

                const SizedBox(height: 20),

                _buildModernTextField(
                  label: l10n.court,
                  controller: _courtNameController,
                  hint: "e.g. High Court, Room 4",
                  icon: Icons.account_balance,
                ),

                const SizedBox(height: 35),
                const Divider(color: kInputFill, thickness: 2),
                const SizedBox(height: 20),

                // --- 2. PARTIES ---
                _buildSectionTitle(l10n.parties),

                _buildModernTextField(
                  label: l10n.clientName,
                  controller: _clientNameController,
                  hint: l10n.fullName,
                  icon: Icons.person,
                ),

                const SizedBox(height: 20),

                _buildModernTextField(
                  label: l10n.opponentName,
                  controller: _opponentNameController,
                  hint: l10n.opponentPartyName,
                  icon: Icons.gavel, // Different icon to distinguish
                ),

                const SizedBox(height: 20),

                _buildModernTextField(
                  label: l10n.judgeName,
                  controller: _judgeNameController,
                  hint: l10n.honorableJudge,
                  icon: Icons.person_4,
                ),

                const SizedBox(height: 35),
                const Divider(color: kInputFill, thickness: 2),
                const SizedBox(height: 20),

                // --- 3. TIMELINE ---
                _buildSectionTitle(l10n.timeline),

                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: l10n.previousHearing,
                        date: _previousHearingDate,
                        onTap: () => _selectDate(context, "previous"),
                        isPast: true,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildDateField(
                        label: l10n.nextHearing,
                        date: _nextHearingDate,
                        onTap: () => _selectDate(context, "next"),
                        isPast: false, // Highlights the next date
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // --- 4. STATUS ---
                Text(
                  l10n.caseStatus,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: kInputFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorderGrey),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildStatusButton(l10n.active, l10n)),
                      const SizedBox(width: 5),
                      Expanded(child: _buildStatusButton(l10n.closed, l10n)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- SUBMIT ---
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _saveCase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlack,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: kPrimaryBlack.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      widget.caseModel != null ? l10n.save : l10n.addCase,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //                                UI COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: kPrimaryBlack,
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kPrimaryBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: kPrimaryBlack,
          ),
          cursorColor: kPrimaryBlack,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
            filled: true,
            fillColor: kInputFill,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryBlack, width: 1.5),
            ),
          ),
          validator: (value) => value!.isEmpty ? "$label is required" : null,
        ),
      ],
    );
  }

  Widget _buildCaseTypeSelector() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.caseType,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kPrimaryBlack,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _caseTypes.map((type) {
              final isSelected = _selectedCaseType == type;
              final localizedType = _getLocalizedCaseType(type);
              return GestureDetector(
                onTap: () => setState(() => _selectedCaseType = type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryBlack : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected ? kPrimaryBlack : kBorderGrey,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: kPrimaryBlack.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    localizedType,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getLocalizedCaseType(String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case 'civil':
        return l10n.civil;
      case 'criminal':
        return l10n.criminal;
      case 'family':
        return l10n.family;
      case 'corporate':
        return l10n.corporate;
      case 'appellate':
        return l10n.appellate;
      default:
        return type;
    }
  }

  Widget _buildStatusButton(String status, AppLocalizations l10n) {
    // Convert localized status back to English for comparison
    final englishStatus = status == l10n.active
        ? 'Active'
        : status == l10n.closed
        ? 'Closed'
        : status;
    final isSelected = _selectedStatus == englishStatus;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = englishStatus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBlack : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required bool isPast,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kPrimaryBlack,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              color: kInputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorderGrey),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: isPast ? Colors.grey : kPrimaryBlack,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    date != null
                        ? "${date.day}/${date.month}/${date.year}"
                        : l10n.selectDate,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: date != null ? kPrimaryBlack : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  //                                LOGIC
  // ---------------------------------------------------------------------------

  Future<void> _selectDate(BuildContext context, String fieldType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryBlack,
              onPrimary: Colors.white,
              onSurface: kPrimaryBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (fieldType == "previous") {
          _previousHearingDate = picked;
        } else {
          _nextHearingDate = picked;
        }
      });
    }
  }

  void _saveCase() async {
    if (_formKey.currentState!.validate()) {
      // Validate case type selection
      if (_selectedCaseType == null || _selectedCaseType!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a case type'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final caseData = CaseModel(
        id:
            widget.caseModel?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        caseNumber: _caseNoController.text,
        caseType: _selectedCaseType ?? 'Civil',
        courtName: _courtNameController.text,
        clientName: _clientNameController.text,
        opponentName: _opponentNameController.text,
        judgeName: _judgeNameController.text,
        previousHearing: _previousHearingDate != null
            ? "${_previousHearingDate!.day}-${_previousHearingDate!.month}-${_previousHearingDate!.year}"
            : "",
        nextHearing: _nextHearingDate != null
            ? "${_nextHearingDate!.day}-${_nextHearingDate!.month}-${_nextHearingDate!.year}"
            : "",
        status: _selectedStatus,
        isArchived: widget.caseModel?.isArchived ?? false,
        createdAt: widget.caseModel?.createdAt,
      );

      try {
        final caseProvider = Provider.of<CaseProvider>(context, listen: false);
        if (widget.caseModel != null) {
          await caseProvider.updateCase(caseData);
        } else {
          await caseProvider.addCase(caseData);
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}
