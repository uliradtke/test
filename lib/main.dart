import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventur Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BarcodeScannerScreen(),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String scannedCode = "Halte einen Barcode in die Kamera";
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventur Live-Scanner')),
      body: Column(
        children: [
          // Oberer Teil: Der Live-Kamerastream
          Expanded(
            flex: 4,
            child: isScanning
                ? MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          setState(() {
                            scannedCode = barcode.rawValue!;
                            isScanning = false; // Scan pausieren nach Erfolg
                          });
                          break;
                        }
                      }
                    },
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        "Scan pausiert",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
          ),
          // Unterer Teil: Anzeige des Ergebnisses und Kontrollknöpfe
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Erkanntes Ergebnis:",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    scannedCode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (!isScanning)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isScanning = true;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Nächster Artikel"),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
