import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'l10n/app_localizations.dart';
import 'dart:math' as math;

class RoomMeasurementScreen extends StatefulWidget {
  const RoomMeasurementScreen({Key? key}) : super(key: key);

  @override
  State<RoomMeasurementScreen> createState() => _RoomMeasurementScreenState();
}

class _RoomMeasurementScreenState extends State<RoomMeasurementScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isMeasuring = false;
  List<Offset> _measurementPoints = [];
  List<MeasurementLine> _measurementLines = [];
  double _scaleFactor = 1.0;
  String _currentMeasurement = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Sprawdź uprawnienia
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      _showPermissionDialog();
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Błąd inicjalizacji aparatu: $e');
    }
  }

  void _showPermissionDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.cameraPermission),
        content: Text(loc.cameraPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(loc.settings),
          ),
        ],
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    
    if (!_isMeasuring) {
      return;
    }

    setState(() {
      _measurementPoints.add(details.localPosition);
    });
    

    if (_measurementPoints.length == 2) {
      _createMeasurementLine();
    }
  }

  void _createMeasurementLine() {
    if (_measurementPoints.length >= 2) {
      final line = MeasurementLine(
        start: _measurementPoints[_measurementPoints.length - 2],
        end: _measurementPoints[_measurementPoints.length - 1],
        id: _measurementLines.length,
      );
      
      setState(() {
        _measurementLines.add(line);
        _measurementPoints.clear();
        _currentMeasurement = 'Długość: ${_calculateDistance(line.start, line.end).toStringAsFixed(2)} cm';
      });
    }
  }

  double _calculateDistance(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    return math.sqrt(dx * dx + dy * dy) * _scaleFactor;
  }

  void _toggleMeasuring() {
    
    setState(() {
      _isMeasuring = !_isMeasuring;
      if (!_isMeasuring) {
        _measurementPoints.clear();
      }
    });
    
  }

  void _clearMeasurements() {
    setState(() {
      _measurementLines.clear();
      _measurementPoints.clear();
      _currentMeasurement = '';
    });
  }

  void _calibrateScale() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.scaleCalibration),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loc.scaleCalibrationMessage),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: loc.realLength,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Tutaj można dodać logikę kalibracji
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Logika kalibracji
            },
            child: Text(loc.measure),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.roomMeasurement),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearMeasurements,
            tooltip: loc.clear,
          ),
          IconButton(
            icon: const Icon(Icons.straighten),
            onPressed: _calibrateScale,
            tooltip: loc.scaleCalibration,
          ),
        ],
      ),
      body: _isCameraInitialized
          ? GestureDetector(
              onTapDown: _onTapDown,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  // Podgląd aparatu
                  Positioned.fill(
                    child: CameraPreview(_cameraController!),
                  ),
                  
                  // Overlay z liniami pomiarowymi
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: MeasurementPainter(
                          lines: _measurementLines,
                          points: _measurementPoints,
                          isMeasuring: _isMeasuring,
                        ),
                      ),
                    ),
                  ),
                  
                  // Wskazówka dla użytkownika
                  if (_isMeasuring && _measurementPoints.isEmpty)
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '👆 Dotknij ekranu, aby zaznaczyć pierwszy punkt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  if (_isMeasuring && _measurementPoints.length == 1)
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '👆 Dotknij ekranu ponownie, aby zaznaczyć drugi punkt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                
                // Panel kontrolny
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status pomiaru
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isMeasuring ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isMeasuring ? loc.measurementMode : loc.startMeasurement,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Aktualny pomiar
                        if (_currentMeasurement.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _currentMeasurement,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 16),
                        
                        // Przyciski kontrolne
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _toggleMeasuring,
                              icon: Icon(_isMeasuring ? Icons.stop : Icons.play_arrow),
                              label: Text(_isMeasuring ? loc.stop : loc.start),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isMeasuring ? Colors.red : Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _clearMeasurements,
                              icon: const Icon(Icons.clear),
                              label: Text(loc.clear),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('${loc.cameraPermission}...'),
                ],
              ),
            ),
    );
  }
}

class MeasurementLine {
  final Offset start;
  final Offset end;
  final int id;

  MeasurementLine({
    required this.start,
    required this.end,
    required this.id,
  });
}

class MeasurementPainter extends CustomPainter {
  final List<MeasurementLine> lines;
  final List<Offset> points;
  final bool isMeasuring;

  MeasurementPainter({
    required this.lines,
    required this.points,
    required this.isMeasuring,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    // Rysuj linie pomiarowe
    for (final line in lines) {
      canvas.drawLine(line.start, line.end, paint);
      
      // Rysuj punkty końcowe
      canvas.drawCircle(line.start, 8, pointPaint);
      canvas.drawCircle(line.end, 8, pointPaint);
      
      // Rysuj etykietę z długością
      final center = Offset(
        (line.start.dx + line.end.dx) / 2,
        (line.start.dy + line.end.dy) / 2,
      );
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${_calculateDistance(line.start, line.end).toStringAsFixed(1)} cm',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
      );
    }

    // Rysuj aktualne punkty podczas pomiaru
    if (isMeasuring) {
      for (final point in points) {
        canvas.drawCircle(point, 10, pointPaint);
      }
    }
  }

  double _calculateDistance(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
