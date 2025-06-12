class DiaryModel {
  int? id;
  String judul;
  String isi;
  String tanggal;
  String jam;

  DiaryModel({
    this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.jam,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
      'jam': jam,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      id: map['id'],
      judul: map['judul'],
      isi: map['isi'],
      tanggal: map['tanggal'],
      jam: map['jam'],
    );
  }
}
