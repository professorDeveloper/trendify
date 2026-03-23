import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:trendify/core/theme/app_colors.dart';

class GalleryPickerPage extends StatefulWidget {
  const GalleryPickerPage({super.key});

  @override
  State<GalleryPickerPage> createState() => _GalleryPickerPageState();
}

class _GalleryPickerPageState extends State<GalleryPickerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _hasPermission = false;
  bool _isLoading = true;

  List<AssetEntity> _photos = [];
  List<AssetPathEntity> _albums = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestAndLoad());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _requestAndLoad() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    PermissionStatus storageStatus = await Permission.photos.status;
    if (storageStatus.isDenied) {
      storageStatus = await Permission.photos.request();
    }

    final pmResult = await PhotoManager.requestPermissionExtend();
    if (!mounted) return;

    if (!pmResult.isAuth && !pmResult.hasAccess) {
      setState(() {
        _hasPermission = false;
        _isLoading = false;
      });
      return;
    }

    setState(() => _hasPermission = true);
    await Future.wait([_loadPhotos(), _loadAlbums()]);
  }

  Future<void> _loadPhotos() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );
      if (!mounted) return;
      if (albums.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }
      final assets = await albums.first.getAssetListPaged(page: 0, size: 100);
      if (mounted) setState(() {
        _photos = assets;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('loadPhotos: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAlbums() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      if (mounted) setState(() => _albums = albums);
    } catch (e) {
      debugPrint('loadAlbums: $e');
    }
  }

  Future<void> _onPhotoTap(AssetEntity asset) async {
    final file = await asset.file;
    if (file != null && mounted) Navigator.pop(context, file.path);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: KeyboardDismissOnTap(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.28,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: const Color(0xFF1A1A1A)),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CircleBtn(
                              icon: Icons.close_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            Text(
                              'Scanning...',
                              style: GoogleFonts.urbanist(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                            _CircleBtn(
                              icon: Icons.more_vert_rounded,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select from Gallery',
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTabBar(),
                      const SizedBox(height: 4),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelStyle: GoogleFonts.urbanist(
            fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.urbanist(
            fontSize: 14, fontWeight: FontWeight.w500),
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.grey600,
        tabs: const [Tab(text: 'Photos'), Tab(text: 'Albums')],
      ),
    );
  }

  Widget _buildBody() {
    if (!_hasPermission) return _buildPermissionDenied();
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    return TabBarView(
      controller: _tabController,
      children: [_buildPhotosGrid(), _buildAlbumsGrid()],
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_library_outlined,
                  color: AppColors.primary, size: 38),
            ),
            const SizedBox(height: 20),
            Text(
              'Gallery Access Required',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Allow access to your photos to select an image for visual search.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.grey500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  'Open Settings',
                  style: GoogleFonts.urbanist(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _requestAndLoad,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.grey300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Try Again',
                  style: GoogleFonts.urbanist(
                    color: AppColors.grey700,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.urbanist(
                    color: AppColors.grey500, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosGrid() {
    if (_photos.isEmpty) {
      return Center(
        child: Text('No photos found',
            style: GoogleFonts.urbanist(
                color: AppColors.grey500, fontSize: 15)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: _photos.length,
      itemBuilder: (_, i) => _PhotoThumb(
        asset: _photos[i],
        onTap: () => _onPhotoTap(_photos[i]),
      ),
    );
  }

  Widget _buildAlbumsGrid() {
    if (_albums.isEmpty) {
      return Center(
        child: Text('No albums found',
            style: GoogleFonts.urbanist(
                color: AppColors.grey500, fontSize: 15)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: _albums.length,
      itemBuilder: (_, i) => _AlbumCard(
        album: _albums[i],
        onTap: () => _openAlbum(_albums[i]),
      ),
    );
  }

  Future<void> _openAlbum(AssetPathEntity album) async {
    final assets = await album.getAssetListPaged(page: 0, size: 100);
    if (!mounted) return;
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => _AlbumDetailPage(
          albumName: album.name,
          assets: assets,
        ),
      ),
    );
    if (result != null && mounted) Navigator.pop(context, result);
  }
}

class KeyboardDismissOnTap extends StatelessWidget {
  final Widget child;
  const KeyboardDismissOnTap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}

class _PhotoThumb extends StatefulWidget {
  final AssetEntity asset;
  final VoidCallback onTap;
  const _PhotoThumb({required this.asset, required this.onTap});

  @override
  State<_PhotoThumb> createState() => _PhotoThumbState();
}

class _PhotoThumbState extends State<_PhotoThumb> {
  Uint8List? _thumb;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await widget.asset.thumbnailDataWithSize(
        const ThumbnailSize(240, 240));
    if (mounted) setState(() => _thumb = bytes);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: _thumb != null
          ? Image.memory(_thumb!, fit: BoxFit.cover)
          : Container(color: AppColors.grey200),
    );
  }
}

class _AlbumCard extends StatefulWidget {
  final AssetPathEntity album;
  final VoidCallback onTap;
  const _AlbumCard({required this.album, required this.onTap});

  @override
  State<_AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<_AlbumCard> {
  Uint8List? _cover;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final count = await widget.album.assetCountAsync;
    final assets = await widget.album.getAssetListPaged(page: 0, size: 1);
    Uint8List? cover;
    if (assets.isNotEmpty) {
      cover = await assets.first
          .thumbnailDataWithSize(const ThumbnailSize(300, 300));
    }
    if (mounted) setState(() {
      _count = count;
      _cover = cover;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _cover != null
                  ? Image.memory(_cover!, fit: BoxFit.cover,
                  width: double.infinity)
                  : Container(
                color: AppColors.grey200,
                child: const Center(
                  child: Icon(Icons.photo_library_outlined,
                      color: AppColors.grey400, size: 32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.album.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          Text(
            '$_count items',
            style: GoogleFonts.urbanist(
                fontSize: 12, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}

class _AlbumDetailPage extends StatelessWidget {
  final String albumName;
  final List<AssetEntity> assets;

  const _AlbumDetailPage({
    required this.albumName,
    required this.assets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.grey900, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          albumName,
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.grey900,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: assets.length,
        itemBuilder: (_, i) => _PhotoThumb(
          asset: assets[i],
          onTap: () async {
            final file = await assets[i].file;
            if (file != null && context.mounted) {
              Navigator.pop(context, file.path);
            }
          },
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}