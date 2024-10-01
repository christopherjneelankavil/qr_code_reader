import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final MobileScannerController _controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  bool _isScanComplete = false;
  bool _isTorchedOn = false;

  void _toggleTorch() {
    setState(() {
      _isTorchedOn = !_isTorchedOn;
    });
    _controller.toggleTorch();
  }

  // Function to show the pop-up when scan is complete
  void _showScanCompletePopup(BuildContext context, String rawValue) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Color(0xFF2D2D2D),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Scan complete",
                style: GoogleFonts.bitter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SelectableText(
                rawValue,
                style: GoogleFonts.bitter(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D0D0D),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the pop-up
                  setState(() {
                    _isScanComplete = false; // Allow scanning again
                  });
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: MobileScanner(
                    controller: _controller,
                    onDetect: (capture) {
                      if (!_isScanComplete) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null) {
                            // Show the popup with the scan result
                            _showScanCompletePopup(context, barcode.rawValue!);
                            setState(() {
                              _isScanComplete = true;
                            });
                            if (kDebugMode) {
                              print('RawValue: ${barcode.rawValue}');
                            }
                            break;
                          }
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(onPressed: (){
                  _toggleTorch();
                }, icon: (_isTorchedOn) ? const Icon(IconsaxPlusBold.flash_slash) : const Icon(IconsaxPlusBold.flash), color: Colors.white, iconSize: 40),
                const SizedBox(height: 20),
                Text(
                  'Place your QR code in front of the camera',
                  style: GoogleFonts.bitter(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
