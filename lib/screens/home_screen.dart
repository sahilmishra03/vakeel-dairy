import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_case_screen.dart';
import 'view_all_cases_screen.dart';
import '../providers/case_provider.dart';
import '../generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CaseProvider>(context, listen: false).initialize();
    });
  }

  // Theme Constants
  static const Color kPrimaryBlack = Color(0xFF111111);
  static const Color kCardBg = Color(0xFFF9F9F9); // Very light grey
  static const Color kBorderColor = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return Consumer<CaseProvider>(
      builder: (context, caseProvider, child) {
        final todayHearings = caseProvider.todayHearings;
        final activeCasesCount = caseProvider.activeCasesCount;

        return Scaffold(
          backgroundColor: Colors.white,
          // --- App Bar ---
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    color: kPrimaryBlack,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
                const Text(
                  'Advocate Portal',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: kPrimaryBlack,
                ),
              ),
              const SizedBox(width: 8),
            ],
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

          // --- Body ---
          body: RefreshIndicator(
            onRefresh: () async => caseProvider.initialize(),
            color: kPrimaryBlack,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              physics: const AlwaysScrollableScrollPhysics(),
              // Ensure the scroll view takes at least screen height to center items
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      150, // Adjust for AppBar
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Dashboard Card
                    _buildActiveCasesCard(
                      kPrimaryBlack,
                      activeCasesCount,
                      todayHearings.length,
                    ),

                    const SizedBox(height: 35),

                    // 2. Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.todaysHearings,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: kPrimaryBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (todayHearings
                            .isNotEmpty) // Only show "See All" if there are items
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ViewAllCasesScreen(),
                                ),
                              );
                            },
                            child: Text(
                              l10n.viewAll,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 3. List or BIG Empty State
                    if (todayHearings.isEmpty)
                      _buildEmptyState()
                    else
                      ...todayHearings.map(
                        (caseItem) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildHearingCard(
                            caseId: caseItem.id,
                            caseNumber: caseItem.caseNumber,
                            caseType: caseItem.caseType,
                            courtName: caseItem.courtName,
                            clientName: caseItem.clientName,
                            opponentName: caseItem.opponentName,
                            status: caseItem.status,
                            caseProvider: caseProvider,
                          ),
                        ),
                      ),

                    // Bottom spacing for FAB
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Widget: Active Cases Dashboard ---
  Widget _buildActiveCasesCard(
    Color primaryColor,
    int activeCasesCount,
    int todayHearingsCount,
  ) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.gavel_rounded, color: Colors.white, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$todayHearingsCount ${l10n.scheduledToday}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            l10n.activeCases,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$activeCasesCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              height: 1.0,
              letterSpacing: -2.0,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget: BIG Empty State ---
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      // Padding pushes it down to visually center it in the remaining space
      padding: const EdgeInsets.only(top: 60.0, bottom: 40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(35), // Bigger padding for circle
              decoration: BoxDecoration(color: kCardBg, shape: BoxShape.circle),
              child: Icon(
                Icons.free_breakfast_outlined,
                size: 80,
                color: Colors.grey[400],
              ), // Huge Icon (80px)
            ),
            const SizedBox(height: 25),
            Text(
              l10n.noHearingsToday,
              style: TextStyle(
                fontSize: 22, // Bigger Title
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enjoy your free time!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ), // Bigger Subtitle
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: Hearing Card ---
  Widget _buildHearingCard({
    required String caseId,
    required String caseNumber,
    required String caseType,
    required String courtName,
    required String clientName,
    required String opponentName,
    required String status,
    required CaseProvider caseProvider,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kCardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kBorderColor),
                  ),
                  child: Text(
                    caseNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Monospace',
                      color: kPrimaryBlack,
                    ),
                  ),
                ),

                Row(
                  children: [
                    _buildStatusBadge(status),
                    const SizedBox(width: 5),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: Colors.grey),
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editCase(caseId, caseProvider);
                        } else if (value == 'delete') {
                          _deleteCase(caseId, caseProvider);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text("Edit Case", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: kBorderColor),
          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      color: kPrimaryBlack,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: clientName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const TextSpan(
                        text: "  vs.  ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: opponentName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      courtName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      caseType,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status == 'Active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? kPrimaryBlack : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? kPrimaryBlack : Colors.grey.shade400,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade600,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Case?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await caseProvider.deleteCase(caseId);
    }
  }
}
