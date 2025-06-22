class ScanResult {
  final String ocrText;
  final String extractedInfo;
  final DateTime timestamp;

  ScanResult({
    required this.ocrText,
    required this.extractedInfo,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'ocrText': ocrText,
        'extractedInfo': extractedInfo,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
        ocrText: json['ocrText'],
        extractedInfo: json['extractedInfo'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}