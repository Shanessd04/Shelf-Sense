// lib/services/local_entity_extractor.dart
Map<String, String> extractEntitiesLocally(String ocrText) {
  String? productName;
  String? expiryDate;

  final lines = ocrText.split('\n');

  for (var line in lines) {
    if (line.toLowerCase().contains('expiry')) {
      expiryDate = line.split(RegExp(r'[:\-]')).last.trim();
    } else if (line.trim().isNotEmpty && productName == null) {
      productName = line.trim();
    }
  }

  return {
    'product': productName ?? 'Unknown Product',
    'expiry': expiryDate ?? 'Unknown Expiry',
  };
}