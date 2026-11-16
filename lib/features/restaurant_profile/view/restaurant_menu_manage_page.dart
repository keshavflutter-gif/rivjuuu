import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Model representing a single dish/item on the menu
class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final String? imageAsset;
  final String categoryId;
  final bool isAvailable;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageAsset,
    required this.categoryId,
    this.isAvailable = true,
  });

  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? price,
    String? imageAsset,
    String? categoryId,
    bool? isAvailable,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageAsset: imageAsset ?? this.imageAsset,
      categoryId: categoryId ?? this.categoryId,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

/// Model representing a category of items (e.g. Main dishes, Desserts)
class MenuCategoryModel {
  final String id;
  final String name;

  const MenuCategoryModel({
    required this.id,
    required this.name,
  });
}

/// Model representing uploaded menu files/photos
class MenuFileModel {
  final String id;
  final String title;
  final String subtitle;
  final bool isPdf;
  final String? imageAsset;

  const MenuFileModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isPdf = false,
    this.imageAsset,
  });
}

/// Restaurant Menu Management screen matching [menu-manage.html]
class RestaurantMenuManagePage extends StatefulWidget {
  const RestaurantMenuManagePage({super.key});

  @override
  State<RestaurantMenuManagePage> createState() =>
      _RestaurantMenuManagePageState();
}

class _RestaurantMenuManagePageState extends State<RestaurantMenuManagePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _photosSectionKey = GlobalKey();

  int _selectedChipIndex = 0; // 0: Menu items, 1: Photos & PDF

  late List<MenuCategoryModel> _categories;
  late List<MenuItemModel> _menuItems;
  late List<MenuFileModel> _menuFiles;

  @override
  void initState() {
    super.initState();
    _categories = [
      const MenuCategoryModel(id: 'main', name: 'Main dishes'),
      const MenuCategoryModel(id: 'desserts', name: 'Desserts'),
      const MenuCategoryModel(id: 'drinks', name: 'Drinks'),
    ];

    _menuItems = [
      const MenuItemModel(
        id: '1',
        name: 'Cacio e pepe',
        description: 'Tonnarelli, pecorino romano, black pepper',
        price: '3,900 HUF',
        imageAsset: 'assets/pasta.jpg',
        categoryId: 'main',
      ),
      const MenuItemModel(
        id: '2',
        name: 'Penne all’arrabbiata',
        description: 'Tomato, garlic, chilli, parsley',
        price: '3,400 HUF',
        imageAsset: 'assets/penne.jpg',
        categoryId: 'main',
      ),
      const MenuItemModel(
        id: '3',
        name: 'Margherita',
        description: 'San Marzano, fior di latte, basil',
        price: '3,600 HUF',
        imageAsset: 'assets/pizza.jpg',
        categoryId: 'main',
      ),
      const MenuItemModel(
        id: '4',
        name: 'Tiramisu della Nonna',
        description: 'Mascarpone, espresso, cocoa',
        price: '1,900 HUF',
        imageAsset: 'assets/tiramisu.jpg',
        categoryId: 'desserts',
      ),
      const MenuItemModel(
        id: '5',
        name: 'House lemonade',
        description: 'Lemon, mint, soda',
        price: '1,200 HUF',
        imageAsset: null,
        categoryId: 'drinks',
      ),
    ];

    _menuFiles = [
      const MenuFileModel(
        id: 'f1',
        title: 'Full menu, autumn 2026',
        subtitle: 'PDF · 4 pages · uploaded 1 Oct',
        isPdf: true,
      ),
      const MenuFileModel(
        id: 'f2',
        title: 'Menu page 1',
        subtitle: 'JPG · uploaded 1 Oct',
        isPdf: false,
        imageAsset: 'assets/pasta.jpg',
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPhotosSection() {
    final context = _photosSectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onChipSelected(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedChipIndex = index;
    });
    if (index == 1) {
      _scrollToPhotosSection();
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _openAddMenuItemSheet({MenuItemModel? itemToEdit}) {
    HapticFeedback.selectionClick();
    final nameCtrl = TextEditingController(text: itemToEdit?.name ?? '');
    final descCtrl = TextEditingController(text: itemToEdit?.description ?? '');
    final priceCtrl = TextEditingController(
      text: itemToEdit?.price.replaceAll(' HUF', '') ?? '',
    );
    String selectedCatId = itemToEdit?.categoryId ??
        (_categories.isNotEmpty ? _categories.first.id : 'main');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        itemToEdit == null ? 'Add menu item' : 'Edit menu item',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.cream,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Category',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _categories.map((cat) {
                      final isSelected = cat.id == selectedCatId;
                      return ChoiceChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            setSheetState(() => selectedCatId = cat.id);
                          }
                        },
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.navy,
                        ),
                        selectedColor: AppColors.navy,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.navy
                                : AppColors.line,
                          ),
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  _buildInputLabel('Item name'),
                  const SizedBox(height: 6),
                  _buildTextField(nameCtrl, 'e.g. Cacio e pepe'),
                  const SizedBox(height: 14),
                  _buildInputLabel('Description'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    descCtrl,
                    'e.g. Tonnarelli, pecorino romano, black pepper',
                  ),
                  const SizedBox(height: 14),
                  _buildInputLabel('Price (HUF)'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    priceCtrl,
                    'e.g. 3,900',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        final priceStr = priceCtrl.text.trim();
                        final formattedPrice = priceStr.isEmpty
                            ? '0 HUF'
                            : (priceStr.endsWith('HUF')
                                ? priceStr
                                : '$priceStr HUF');

                        setState(() {
                          if (itemToEdit == null) {
                            _menuItems.add(
                              MenuItemModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                name: name,
                                description: descCtrl.text.trim(),
                                price: formattedPrice,
                                categoryId: selectedCatId,
                                imageAsset: null,
                              ),
                            );
                          } else {
                            final idx = _menuItems.indexWhere(
                                (it) => it.id == itemToEdit.id);
                            if (idx != -1) {
                              _menuItems[idx] = itemToEdit.copyWith(
                                name: name,
                                description: descCtrl.text.trim(),
                                price: formattedPrice,
                                categoryId: selectedCatId,
                              );
                            }
                          }
                        });
                        Navigator.pop(ctx);
                        HapticFeedback.mediumImpact();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        itemToEdit == null ? 'Add item' : 'Save changes',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openAddCategorySheet() {
    HapticFeedback.selectionClick();
    final catCtrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add category',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.cream,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputLabel('Category name'),
              const SizedBox(height: 6),
              _buildTextField(catCtrl, 'e.g. Appetizers, Starters, Wines'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final name = catCtrl.text.trim();
                    if (name.isEmpty) return;
                    final id =
                        'cat_${DateTime.now().millisecondsSinceEpoch}';
                    setState(() {
                      _categories.add(MenuCategoryModel(id: id, name: name));
                    });
                    Navigator.pop(ctx);
                    HapticFeedback.mediumImpact();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Create category',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openItemMoreSheet(MenuItemModel item) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      Text(
                        item.price,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.line),
                ListTile(
                  leading: Icon(
                    item.isAvailable
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                    color: AppColors.navy,
                  ),
                  title: Text(
                    item.isAvailable
                        ? 'Mark as sold out / unavailable'
                        : 'Mark as available',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.navy,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      final idx = _menuItems.indexWhere((it) => it.id == item.id);
                      if (idx != -1) {
                        _menuItems[idx] =
                            item.copyWith(isAvailable: !item.isAvailable);
                      }
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.navy,
                  ),
                  title: Text(
                    'Edit item',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.navy,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openAddMenuItemSheet(itemToEdit: item);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFE552E),
                  ),
                  title: Text(
                    'Delete item',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFE552E),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _menuItems.removeWhere((it) => it.id == item.id);
                    });
                    HapticFeedback.mediumImpact();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _simulateUploadFile() {
    HapticFeedback.selectionClick();
    final newId = 'f_${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      _menuFiles.add(
        MenuFileModel(
          id: newId,
          title: 'Menu page ${_menuFiles.length + 1}',
          subtitle: 'JPG · uploaded today',
          isPdf: false,
          imageAsset: 'assets/pizza.jpg',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Menu file uploaded successfully',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppColors.navy,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  void _deleteFile(MenuFileModel file) {
    HapticFeedback.mediumImpact();
    setState(() {
      _menuFiles.removeWhere((f) => f.id == file.id);
    });
  }

  void _replaceFile(MenuFileModel file) {
    HapticFeedback.selectionClick();
    setState(() {
      final idx = _menuFiles.indexWhere((f) => f.id == file.id);
      if (idx != -1) {
        _menuFiles[idx] = MenuFileModel(
          id: file.id,
          title: file.title,
          subtitle: file.isPdf
              ? 'PDF · updated just now'
              : 'JPG · updated just now',
          isPdf: file.isPdf,
          imageAsset: file.imageAsset,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'File replaced successfully',
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppColors.navy,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.navy,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.text.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
          borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            // Top Bar (.bar, style="padding-top: 4px")
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back round button (.round)
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
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

                  // Title (.bar__title)
                  Text(
                    'Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),

                  // Add menu item round coral button
                  GestureDetector(
                    onTap: () => _openAddMenuItemSheet(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.coral),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.coral.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chips Bar (.chips, style="margin-top: 10px")
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Chip 1: Menu items
                    GestureDetector(
                      onTap: () => _onChipSelected(0),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: _selectedChipIndex == 0
                              ? AppColors.navy
                              : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: _selectedChipIndex == 0
                                ? AppColors.navy
                                : AppColors.line,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Menu items',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: _selectedChipIndex == 0
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: _selectedChipIndex == 0
                                  ? Colors.white
                                  : AppColors.navy,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Chip 2: Photos & PDF
                    GestureDetector(
                      onTap: () => _onChipSelected(1),
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: _selectedChipIndex == 1
                              ? AppColors.navy
                              : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: _selectedChipIndex == 1
                                ? AppColors.navy
                                : AppColors.line,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 16,
                              color: _selectedChipIndex == 1
                                  ? Colors.white
                                  : AppColors.navy,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Photos & PDF',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: _selectedChipIndex == 1
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: _selectedChipIndex == 1
                                    ? Colors.white
                                    : AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Menu Content (.scroll)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Render Each Category Block
                    ..._categories.map((cat) {
                      final itemsInCat = _menuItems
                          .where((it) => it.categoryId == cat.id)
                          .toList();
                      return _buildCategorySection(cat, itemsInCat);
                    }),

                    // Add Category Button (.btn .btn--ghost, style="margin-top: 6px")
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: GestureDetector(
                        onTap: _openAddCategorySheet,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_rounded,
                                size: 20,
                                color: AppColors.navy,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Add category',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Menu Photos & PDF Section Header (.cat-head)
                    Container(
                      key: _photosSectionKey,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Menu photos & PDF',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            'Optional',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Render File Cards (.file)
                    ..._menuFiles.map((file) => _buildFileCard(file)),

                    const SizedBox(height: 6),

                    // Upload Button (.upload)
                    _buildUploadButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    MenuCategoryModel cat,
    List<MenuItemModel> items,
  ) {
    final countLabel =
        '${items.length} ${items.length == 1 ? 'item' : 'items'}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header (.cat-head)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cat.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  countLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Card (.card-plain)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No items in this category yet',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: AppColors.text.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      final isLast = index == items.length - 1;
                      return Column(
                        children: [
                          _buildMenuItemRow(item),
                          if (!isLast)
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.line,
                            ),
                        ],
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemRow(MenuItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thumbnail (.mm-item__img)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageAsset != null
                  ? Image.asset(
                      item.imageAsset!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 20,
                            color: Color(0xFFB5AD9F),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: Color(0xFFB5AD9F),
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // Body (.mm-item__body)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 19 / 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                          decoration: item.isAvailable
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!item.isAvailable)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.peach,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Sold out',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFE552E),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  item.description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 17 / 12,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.price,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Action 1: Edit button (.icon-btn)
          GestureDetector(
            onTap: () => _openAddMenuItemSheet(itemToEdit: item),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.line),
              ),
              child: const Center(
                child: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Action 2: More button (.icon-btn)
          GestureDetector(
            onTap: () => _openItemMoreSheet(item, ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.line),
              ),
              child: const Center(
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 18,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(MenuFileModel file) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            // Thumbnail (.file__thumb)
            Container(
              width: 52,
              height: 66,
              decoration: BoxDecoration(
                color: file.isPdf ? const Color(0xFFFFF0EC) : AppColors.cream,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: file.isPdf
                    ? Center(
                        child: Text(
                          'PDF',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.coral,
                          ),
                        ),
                      )
                    : (file.imageAsset != null
                        ? Image.asset(
                            file.imageAsset!,
                            width: 52,
                            height: 66,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 20,
                                  color: Color(0xFFB5AD9F),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 20,
                              color: Color(0xFFB5AD9F),
                            ),
                          )),
              ),
            ),

            const SizedBox(width: 12),

            // Body (.file__body)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    file.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      height: 19 / 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    file.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: AppColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Acts (.file__acts)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Replace action (.icon-btn)
                GestureDetector(
                  onTap: () => _replaceFile(file),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 16,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // Delete action (.icon-btn)
                GestureDetector(
                  onTap: () => _deleteFile(file),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 16,
                        color: Color(0xFFFE552E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: _simulateUploadFile,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: const Color(0xFFD8D3CC),
          strokeWidth: 1.5,
          gap: 5.0,
          dash: 6.0,
          radius: 12.0,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.file_upload_outlined,
                size: 24,
                color: AppColors.coral,
              ),
              const SizedBox(height: 4),
              Text(
                'Upload menu photos or PDF',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'JPG, PNG or PDF',
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter to draw a dashed border matching [.upload { border: 1.5px dashed #d8d3cc; }]
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        final extract = metric.extractPath(
          distance,
          next > metric.length ? metric.length : next,
        );
        canvas.drawPath(extract, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dash != dash ||
        oldDelegate.gap != gap ||
        oldDelegate.radius != radius;
  }
}


