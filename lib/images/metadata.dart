import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:exif/exif.dart';
import 'package:geocoding/geocoding.dart';

class Metadata extends StatelessWidget {
  final AssetEntity asset;

  const Metadata({super.key, required this.asset});

  Future<Map<String, String>> extractMetadata() async {
    var file = await asset.file;
    if (file == null) {
      return {};
    }
    var bytes = await file.readAsBytes();
    var tags = await readExifFromBytes(bytes);

    Map<String, String> metadata = {};
    if (tags.isNotEmpty) {
      tags.forEach((key, value) {
        metadata[key] = value.toString();
      });
    }

    return metadata;
  }

  Future<String> getAddressFromGPS(Map<String, String> metadata) async {
    if (metadata.containsKey('GPSLatitude') &&
        metadata.containsKey('GPSLongitude')) {
      try {
        double latitude = convertToDegree(metadata['GPSLatitude']!);
        double longitude = convertToDegree(metadata['GPSLongitude']!);
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          return placemarks.first.locality ?? 'Unknown location';
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
    return 'GPS data 없음';
  }

  double convertToDegree(String dmsString) {
    List<String> dms = dmsString.split(',');
    List<String> parts = dms.map((s) => s.split('/')).expand((i) => i).toList();
    double degrees = double.parse(parts[0]) / double.parse(parts[1]);
    double minutes = double.parse(parts[2]) / double.parse(parts[3]);
    double seconds = double.parse(parts[4]) / double.parse(parts[5]);
    return degrees + (minutes / 60) + (seconds / 3600);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메타텍스트')),
      body: FutureBuilder<Map<String, String>>(
        future: extractMetadata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('메타없음', style: TextStyle(fontSize: 10)));
          } else {
            Map<String, String> metadata = snapshot.data!;
            print(metadata);
            return FutureBuilder<String>(
              future: getAddressFromGPS(metadata),
              builder: (context, addressSnapshot) {
                if (addressSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (addressSnapshot.hasError) {
                  return Center(child: Text('Error: ${addressSnapshot.error}'));
                } else {
                  String address = addressSnapshot.data ?? '주소 없음';
                  return SizedBox(
                      height: 100,
                      child: ListTile(
                          title:
                              const Text('메타:', style: TextStyle(fontSize: 8)),
                          subtitle: Text(
                              metadata.entries
                                  .map(
                                      (entry) => "${entry.key}: ${entry.value}")
                                  .join("\n"),
                              style: const TextStyle(fontSize: 6)),
                          trailing: Text('주소: $address',
                              style: const TextStyle(fontSize: 6))));
                }
              },
            );
          }
        },
      ),
    );
  }
}
