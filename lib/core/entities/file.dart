class FileEntity {
  String filename;
  String filepath;

  FileEntity({
    required this.filename,
    required this.filepath,
  });
  // Convert File to JSON
  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'filepath': filepath,
    };
  }

  // Convert JSON to File
  factory FileEntity.fromJson(Map<String, dynamic> json) {
    return FileEntity(
      filename: json['filename'],
      filepath: json['filepath'],
    );
  }

  @override
  String toString() {
    return 'FileEntity{filename: $filename, filepath: $filepath}';
  }
}
