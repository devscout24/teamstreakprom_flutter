import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpace(20),
            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(),
              ),
            ),
            const Spacer(),

            // Scanner Frame view wrapping the live camera preview
            Center(
              child: SizedBox(
                width: 330.w,
                height: 480.w,
                child: Stack(
                  children: [
                    Container(
                      width: 330.w,
                      height: 480.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: MobileScanner(
                        controller: _controller,
                        onDetect: (capture) {
                          if (_isScanned) return;
                          final List<Barcode> barcodes = capture.barcodes;
                          if (barcodes.isNotEmpty) {
                            final String? rawValue = barcodes.first.rawValue;
                            debugPrint("Scanned QR Code Value: $rawValue");
                            setState(() {
                              _isScanned = true;
                            });
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.scanResultScreen,
                            );
                          }
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(painter: _ScannerFramePainter()),
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(24),

            Text(
              "Position QR code within the frame",
              style: TextStyle(
                fontFamily: "SF Pro",
                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const Spacer(),

            // Bottom Scan Trigger Button (Simulated scan for emulator testing)
            GestureDetector(
              onTap: () {
                if (_isScanned) return;
                setState(() {
                  _isScanned = true;
                });
                Navigator.pushReplacementNamed(
                  context,
                  Routes.scanResultScreen,
                );
              },
              child: Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 2.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1E222B),
                      width: 4.w,
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF28F31), Color(0xFF72E84F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpace(40),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to draw those beautiful gradient corner guides
class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double cornerSize = 24.w;
    final double strokeThickness = 2.w;
    final double radius = 24.r;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeThickness
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFFF28F31), Color(0xFF72E84F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    // Top-Left Corner
    final topLeftPath = Path()
      ..moveTo(0, cornerSize)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..lineTo(cornerSize, 0);
    canvas.drawPath(topLeftPath, paint);

    // Top-Right Corner
    final topRightPath = Path()
      ..moveTo(width - cornerSize, 0)
      ..lineTo(width - radius, 0)
      ..quadraticBezierTo(width, 0, width, radius)
      ..lineTo(width, cornerSize);
    canvas.drawPath(topRightPath, paint);

    // Bottom-Left Corner
    final bottomLeftPath = Path()
      ..moveTo(0, height - cornerSize)
      ..lineTo(0, height - radius)
      ..quadraticBezierTo(0, height, radius, height)
      ..lineTo(cornerSize, height);
    canvas.drawPath(bottomLeftPath, paint);

    // Bottom-Right Corner
    final bottomRightPath = Path()
      ..moveTo(width - cornerSize, height)
      ..lineTo(width - radius, height)
      ..quadraticBezierTo(width, height, width, height - radius)
      ..lineTo(width, height - cornerSize);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
