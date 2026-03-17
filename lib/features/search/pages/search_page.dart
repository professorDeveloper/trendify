import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _recentSearches = ['Hoodie for Men', 'Nike', 'Polo Shirt'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  InkWell(
                    focusColor: AppColors.grey200,
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: AppColors.grey900,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          color: AppColors.grey900,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search Trends...',
                          hintStyle: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: AppColors.grey400,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.grey400,
                            size: 20,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.grey400,
                              size: 20,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.grey100,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (_recentSearches.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey900,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _recentSearches.clear()),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentSearches.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                  itemBuilder: (_, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _recentSearches[i],
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey600,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => setState(() => _recentSearches.removeAt(i)),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.grey400,
                      ),
                    ),
                    onTap: () {
                      _controller.text = _recentSearches[i];
                      _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _recentSearches[i].length),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}