import 'dart:typed_data';
import 'dart:convert';

class Event {
  final String id;
  final String judul;
  final String tanggal;
  final String deskripsi;
  final Uint8List? gambarBytes;

  Event({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.deskripsi,
    this.gambarBytes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'judul': judul,
        'tanggal': tanggal,
        'deskripsi': deskripsi,
        'gambar': gambarBytes != null ? base64Encode(gambarBytes!) : null,
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        judul: json['judul'],
        tanggal: json['tanggal'],
        deskripsi: json['deskripsi'],
        gambarBytes:
            json['gambar'] != null ? base64Decode(json['gambar']) : null,
      );
}
