import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivjuuu/core/constants/app_colors.dart';
import 'package:rivjuuu/core/routes/app_router.dart';

class FriendModel {
  final String id;
  final String name;
  final String initials;
  final String status;
  final Color avatarBg;
  final Color avatarColor;

  const FriendModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.status,
    required this.avatarBg,
    required this.avatarColor,
  });
}

class FriendRequestModel {
  final String id;
  final String name;
  final String initials;
  final String info;
  final Color avatarBg;
  final Color avatarColor;
  final bool isSent;

  const FriendRequestModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.info,
    required this.avatarBg,
    required this.avatarColor,
    this.isSent = false,
  });
}

class FriendsView extends StatefulWidget {
  final int initialTab;

  const FriendsView({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  late int _selectedTab;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;

  final List<FriendModel> _allFriends = const [
    FriendModel(
      id: '1',
      name: 'Anna Kovács',
      initials: 'AK',
      status: 'Last visit · Trattoria Nonna Rosa',
      avatarBg: Color(0xFFFFE8E0),
      avatarColor: Color(0xFFB8330F),
    ),
    FriendModel(
      id: '2',
      name: 'Bence Tóth',
      initials: 'BT',
      status: 'Last visit · Kōya Sushi & Ramen',
      avatarBg: Color(0xFFFDF0D9),
      avatarColor: Color(0xFF7A4A00),
    ),
    FriendModel(
      id: '3',
      name: 'Zsófia Balogh',
      initials: 'ZS',
      status: 'Last visit · Café Mókus',
      avatarBg: Color(0xFFE9E3D8),
      avatarColor: Color(0xFF3F3F46),
    ),
    FriendModel(
      id: '4',
      name: 'Dávid Molnár',
      initials: 'DM',
      status: 'Activity is private',
      avatarBg: Color(0xFF18181B),
      avatarColor: Color(0xFFFFFFFF),
    ),
    FriendModel(
      id: '5',
      name: 'Lilla Kiss',
      initials: 'LK',
      status: 'Last visit · Bamba Burger Bar',
      avatarBg: Color(0xFFFFE8E0),
      avatarColor: Color(0xFFB8330F),
    ),
  ];

  late List<FriendRequestModel> _receivedRequests;
  late List<FriendRequestModel> _sentRequests;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _scrollController = ScrollController();
    _receivedRequests = [
      const FriendRequestModel(
        id: 'r1',
        name: 'Péter Nagy',
        initials: 'PN',
        info: '4 mutual friends',
        avatarBg: Color(0xFFFDF0D9),
        avatarColor: Color(0xFF7A4A00),
      ),
      const FriendRequestModel(
        id: 'r2',
        name: 'Eszter Farkas',
        initials: 'EF',
        info: '1 mutual friend',
        avatarBg: Color(0xFFE9E3D8),
        avatarColor: Color(0xFF3F3F46),
      ),
    ];
    _sentRequests = [
      const FriendRequestModel(
        id: 's1',
        name: 'Anna Szabó',
        initials: 'AS',
        info: 'Pending',
        avatarBg: Color(0xFFFFE8E0),
        avatarColor: Color(0xFFB8330F),
        isSent: true,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<FriendModel> get _filteredFriends {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _allFriends;
    return _allFriends
        .where(
          (f) =>
              f.name.toLowerCase().contains(query) ||
              f.status.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (.bar from friends.html)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Friends',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) _searchController.clear();
                      });
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _isSearching ? AppColors.navy : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Center(
                        child: Icon(
                          _isSearching ? Icons.close : LucideIcons.search,
                          size: 19,
                          color: _isSearching ? Colors.white : AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Optional Search bar
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search friends...',
                    prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF71717A)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.coral),
                    ),
                  ),
                ),
              ),

            // Tab Bar (.tabs matching rv3.css & reference screenshot)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.line,
                    width: 1.0,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildTabItem(
                      label: 'Friends \u00b7 32',
                      index: 0,
                    ),
                    const SizedBox(width: 22),
                    _buildTabItem(
                      label: 'Requests \u00b7 ${_receivedRequests.length}',
                      index: 1,
                    ),
                  ],
                ),
              ),
            ),

            // Tab Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedTab == 0) ..._buildFriendsList(),
                    if (_selectedTab == 1) ..._buildRequestsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required int index,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedTab = index;
        });
      },
      child: SizedBox(
        height: 46,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.navy : const Color(0xFF71717A),
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFriendsList() {
    final friends = _filteredFriends;
    return friends.asMap().entries.map((entry) {
      final index = entry.key;
      final friend = entry.value;
      final isLast = index == friends.length - 1;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pushNamed(
            AppRoutes.userProfile,
            arguments: {
              'name': friend.name,
              'initials': friend.initials,
              'subtitle': friend.status.contains('private')
                  ? 'Private profile · Joined Mar 2026'
                  : 'Food lover · Joined Mar 2026',
              'avatarBg': friend.avatarBg,
              'avatarColor': friend.avatarColor,
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(
                    bottom: BorderSide(
                      color: AppColors.line,
                      width: 1.0,
                    ),
                  ),
          ),
          child: Row(
            children: [
              // Avatar circle (.av-sm)
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: friend.avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    friend.initials,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: friend.avatarColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Person Body (.person__body)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      friend.status,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF71717A),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              // More button (.more)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showFriendOptions(friend.name),
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: Icon(
                      Icons.more_horiz_rounded,
                      size: 20,
                      color: Color(0xFF71717A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildRequestsList() {
    return [
      if (_receivedRequests.isNotEmpty) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 0, 6),
          child: Text(
            'RECEIVED',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.72,
              color: const Color(0xFF71717A),
            ),
          ),
        ),
        ..._receivedRequests.asMap().entries.map((entry) {
          final index = entry.key;
          final req = entry.value;
          final isLast = index == _receivedRequests.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(
                        color: AppColors.line,
                        width: 1.0,
                      ),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: req.avatarBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      req.initials,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: req.avatarColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        req.info,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF71717A),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _receivedRequests.remove(req);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Accepted ${req.name}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.coral,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Accept',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _receivedRequests.remove(req);
                        });
                      },
                      child: Container(
                        height: 34,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Center(
                          child: Text(
                            'Decline',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
      if (_sentRequests.isNotEmpty) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 6),
          child: Text(
            'SENT',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.72,
              color: const Color(0xFF71717A),
            ),
          ),
        ),
        ..._sentRequests.asMap().entries.map((entry) {
          final index = entry.key;
          final req = entry.value;
          final isLast = index == _sentRequests.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(
                        color: AppColors.line,
                        width: 1.0,
                      ),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: req.avatarBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      req.initials,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: req.avatarColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        req.info,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF71717A),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _sentRequests.remove(req);
                    });
                  },
                  child: Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel request',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ];
  }

  void _showFriendOptions(String friendName) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4CEBA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Options card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 52),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(LucideIcons.messageCircle, size: 18, color: AppColors.navy),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Message',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.line),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(ctx).pop();
                          setState(() {
                            _allFriends.removeWhere((f) => f.name == friendName);
                          });
                        },
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 52),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBE8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(LucideIcons.userMinus, size: 18, color: Color(0xFFC2380F)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Unfriend $friendName',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFC2380F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel button
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
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
}
