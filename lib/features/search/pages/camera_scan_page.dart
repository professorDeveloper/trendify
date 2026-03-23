import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trendify/core/theme/app_colors.dart';
import 'gallery_picker.dart';

class CameraScanPage extends StatefulWidget {
  const CameraScanPage({super.key});

  @override
  State<CameraScanPage> createState() => _CameraScanPageState();
}

class _CameraScanPageState extends State<CameraScanPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;

  bool _isInitialized = false;
  bool _hasPermission = false;
  bool _isLoading = true;
  String? _errorMessage;

  late AnimationController _scanAnimController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _scanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanAnimController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _initCamera());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
      if (mounted) setState(() => _isInitialized = false);
    } else if (state == AppLifecycleState.resumed &&
        _hasPermission &&
        _cameras.isNotEmpty) {
      _startCamera(_cameras[_currentCameraIndex]);
    }
  }

  Future<void> _initCamera() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (!mounted) return;

    if (!status.isGranted) {
      setState(() {
        _hasPermission = false;
        _isLoading = false;
      });
      return;
    }

    setState(() => _hasPermission = true);

    try {
      _cameras = await availableCameras();
      if (!mounted) return;
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No camera found on this device.';
          _isLoading = false;
        });
        return;
      }
      await _startCamera(_cameras[_currentCameraIndex]);
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to open camera.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _startCamera(CameraDescription camera) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _isInitialized = false;
    });

    final old = _cameraController;
    _cameraController = null;
    try {
      await old?.dispose();
    } catch (_) {}

    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _cameraController = controller;
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Start camera error: $e');
      try {
        await controller.dispose();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _errorMessage = 'Camera could not be started.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2 || !mounted) return;
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _takePicture() async {
    final ctrl = _cameraController;
    if (ctrl == null ||
        !ctrl.value.isInitialized ||
        ctrl.value.isTakingPicture) return;
    try {
      final file = await ctrl.takePicture();
      if (!mounted) return;
      Navigator.pop(context, file.path);
    } catch (e) {
      debugPrint('takePicture error: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanAnimController.dispose();
    _cameraController?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) =>
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  const Spacer(),
                  if (_isInitialized) _buildScanFrame(),
                  const Spacer(),
                  if (_isInitialized) _buildBottomBar(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (!_hasPermission) return _buildPermissionScreen();

    if (_errorMessage != null) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Text(
          _errorMessage!,
          style: GoogleFonts.urbanist(color: AppColors.grey400, fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_isInitialized && _cameraController != null) {
      return CameraPreview(_cameraController!);
    }

    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildPermissionScreen() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.primary,
              size: 44,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Camera Access Required',
            style: GoogleFonts.urbanist(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'To use visual search, please allow camera access from your device settings.',
            style: GoogleFonts.urbanist(
              color: AppColors.grey400,
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                await openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Open Settings',
                style: GoogleFonts.urbanist(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: _initCamera,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.grey700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.urbanist(
                  color: AppColors.grey300,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(
                color: AppColors.grey500,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          _CircleBtn(icon: Icons.more_vert_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildScanFrame() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: AspectRatio(
        aspectRatio: 0.72,
        child: AnimatedBuilder(
          animation: _scanAnimation,
          builder: (_, __) => CustomPaint(
            painter: _ScanFramePainter(progress: _scanAnimation.value),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ActionBtn(
            icon: Icons.photo_library_outlined,
            onTap: () async {
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                    builder: (_) => const GalleryPickerPage()),
              );
              if (result != null && mounted) {
                Navigator.pop(context, result);
              }
            },
          ),
          GestureDetector(
            onTap: _takePicture,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.25),
                    blurRadius: 20,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          _ActionBtn(
            icon: Icons.flip_camera_ios_outlined,
            onTap: _flipCamera,
          ),
        ],
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

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 24),
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  final double progress;
  const _ScanFramePainter({required this.progress});

  static const _color = AppColors.primary;
  static const _cornerLen = 28.0;
  static const _radius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..style = PaintingStyle.fill,
    );

    final cp = Paint()
      ..color = _color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void corner(double ox, double oy, bool fx, bool fy) {
      final dx = fx ? -1.0 : 1.0;
      final dy = fy ? -1.0 : 1.0;
      canvas.drawPath(
        Path()
          ..moveTo(ox + dx * _cornerLen, oy)
          ..lineTo(ox + dx * _radius, oy)
          ..arcToPoint(Offset(ox, oy + dy * _radius),
              radius: const Radius.circular(_radius),
              clockwise: !(fx ^ fy))
          ..lineTo(ox, oy + dy * _cornerLen),
        cp,
      );
    }

    corner(0, 0, false, false);
    corner(size.width, 0, true, false);
    corner(0, size.height, false, true);
    corner(size.width, size.height, true, true);

    final y = size.height * progress;
    canvas.drawLine(
      Offset(20, y),
      Offset(size.width - 20, y),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _color.withOpacity(0),
            _color.withOpacity(0.9),
            _color.withOpacity(0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, y - 20, size.width, 40))
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_ScanFramePainter old) => old.progress != progress;
}