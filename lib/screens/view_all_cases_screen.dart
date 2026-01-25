import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_case_screen.dart';
import '../models/case_model.dart';
import '../providers/case_provider.dart';
import '../providers/locale_provider.dart';
import '../generated/app_localizations.dart';

class ViewAllCasesScreen extends StatefulWidget {
  const ViewAllCasesScreen({super.key});

  @override
  State<ViewAllCasesScreen> createState() => _ViewAllCasesScreenState();
}

class _ViewAllCasesScreenState extends State<ViewAllCasesScreen> {
  String _selectedFilter = '';
  final TextEditingController _searchController = TextEditingController();

  // Theme Constants
  static const Color kPrimaryBlack = Color(0xFF111111);
  static const Color kCardBg = Color(0xFFF9F9F9);
  static const Color kBorderColor = Color(0xFFEEEEEE);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCases);
    // Initialize with localized string after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _selectedFilter = l10n.allCases;
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCases);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCases() {
    setState(() {
      // Triggers rebuild to filter data
    });
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  // Helper method to map localized filter back to English for comparison
  String _mapLocalizedFilterToEnglish(
    String localizedFilter,
    AppLocalizations l10n,
  ) {
    switch (localizedFilter) {
      case 'सिविल': // Hindi Civil
        return 'Civil';
      case 'आपराधिक': // Hindi Criminal
        return 'Criminal';
      case 'पारिवारिक': // Hindi Family
        return 'Family';
      case 'कॉर्पोरेट': // Hindi Corporate
        return 'Corporate';
      case 'अपीलीय': // Hindi Appellate
        return 'Appellate';
      default:
        return localizedFilter; // Return as-is for English or All Cases
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<CaseProvider>(
      builder: (context, caseProvider, child) {
        // --- 1. Filter Logic ---
        List<CaseModel> filteredCases = caseProvider.allCases;

        // Apply type filter
        if (_selectedFilter != l10n.allCases) {
          // Map localized filter back to English for comparison
          String filterType = _mapLocalizedFilterToEnglish(
            _selectedFilter,
            l10n,
          );
          filteredCases = filteredCases
              .where((c) => c.caseType == filterType)
              .toList();
        }

        // Apply search filter
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          filteredCases = filteredCases.where((c) {
            return c.clientName.toLowerCase().contains(query) ||
                c.caseNumber.toLowerCase().contains(query) ||
                c.opponentName.toLowerCase().contains(query);
          }).toList();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          // --- AppBar ---
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: kPrimaryBlack,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              l10n.allCases,
              style: const TextStyle(
                color: kPrimaryBlack,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),

          // --- FAB ---
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCaseScreen()),
              );
            },
            backgroundColor: kPrimaryBlack,
            elevation: 4,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              l10n.addCase,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: Column(
            children: [
              // --- 1. Search Bar ---
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: kCardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorderColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    cursorColor: kPrimaryBlack,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: l10n.searchCases,
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),

              // --- 2. Filter Tabs ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, bottom: 15),
                child: Row(
                  children: [
                    _buildFilterChip(l10n.allCases),
                    _buildFilterChip(l10n.civil),
                    _buildFilterChip(l10n.criminal),
                    _buildFilterChip(l10n.family),
                    _buildFilterChip(l10n.corporate),
                    _buildFilterChip(l10n.appellate),
                    const SizedBox(width: 20), // End padding
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: kBorderColor),

              // --- 3. Case List ---
              Expanded(
                child: filteredCases.isEmpty
                    ? _buildEmptyState() // Big Empty State
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: filteredCases.length,
                        itemBuilder: (context, index) {
                          final caseItem = filteredCases[index];
                          return _buildCaseListItem(caseItem, caseProvider);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Widget: Modern Filter Chip ---
  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => _selectFilter(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBlack : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? kPrimaryBlack : kBorderColor),
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
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // --- Widget: List Item Card ---
  Widget _buildCaseListItem(CaseModel caseItem, CaseProvider provider) {
    final l10n = AppLocalizations.of(context)!;

    // Generate Type Avatar Code (e.g. Civil -> CI)
    String typeCode = caseItem.caseType.length > 2
        ? caseItem.caseType.substring(0, 2).toUpperCase()
        : "NA";

    return GestureDetector(
      onTap: () => _editCase(caseItem.id, provider),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Black Avatar Box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: kPrimaryBlack,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  typeCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // 2. Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: Client vs Opponent
                  Text(
                    "${caseItem.clientName} vs ${caseItem.opponentName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryBlack,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle: Case No • Court
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: kCardBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          caseItem.caseNumber,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Monospace',
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "•  ${caseItem.courtName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 3. Status & Menu
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatusBadge(caseItem.status),
                const SizedBox(height: 8),

                // Three Dots Menu
                SizedBox(
                  height: 24,
                  width: 24,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_horiz, color: Colors.grey[400]),
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteCase(caseItem.id, provider);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, size: 18),
                            const SizedBox(width: 10),
                            Text(l10n.deleteCase),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: Status Badge ---
  Widget _buildStatusBadge(String status) {
    final l10n = AppLocalizations.of(context)!;
    bool isActive = status == 'Active';
    final isHindi =
        Provider.of<LocaleProvider>(context).locale.languageCode == 'hi';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        status == 'Active' ? l10n.active : l10n.closed,
        style: TextStyle(
          fontSize: isHindi ? 14 : 10, // Much larger font for Hindi
          fontWeight: FontWeight.w700,
          color: isActive ? Colors.green.shade800 : Colors.grey.shade700,
        ),
      ),
    );
  }

  // --- Widget: BIG Empty State ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: kCardBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No cases found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // --- Logic ---
  void _editCase(String caseId, CaseProvider caseProvider) async {
    final caseModel = caseProvider.getCaseById(caseId);
    if (caseModel != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCaseScreen(caseModel: caseModel),
        ),
      );
    }
  }

  void _deleteCase(String caseId, CaseProvider caseProvider) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.deleteCaseTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(l10n.deleteCaseMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.delete,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await caseProvider.deleteCase(caseId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Case deleted successfully'),
            backgroundColor: kPrimaryBlack,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
