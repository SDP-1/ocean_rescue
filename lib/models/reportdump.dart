// reportdump.dart

class DumpReport {
  final String name;             // Name of the dump
  final String description;      // Description of the dump
  final String urgencyLevel;     // Urgency level: Low, Normal, High, Urgent
  final String location;         // Location of the dump

  // Constructor to initialize all fields
  DumpReport({
    required this.name,
    required this.description,
    required this.urgencyLevel,
    required this.location,
  });

  // Method to convert the object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'urgencyLevel': urgencyLevel,
      'location': location,
    };
  }

  // Named constructor to create a DumpReport from a JSON object
  factory DumpReport.fromJson(Map<String, dynamic> json) {
    return DumpReport(
      name: json['name'],
      description: json['description'],
      urgencyLevel: json['urgencyLevel'],
      location: json['location'],
    );
  }

  @override
  String toString() {
    return 'DumpReport{name: $name, description: $description, urgencyLevel: $urgencyLevel, location: $location}';
  }
}
