import 'package:doan_tmdt/model/dialog_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// Class dữ liệu
class Province {
  final String idProvince;
  final String name;

  Province({required this.idProvince, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      idProvince: json['idProvince'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class District {
  final String idProvince;
  final String idDistrict;
  final String name;

  District({
    required this.idProvince,
    required this.idDistrict,
    required this.name,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      idProvince: json['idProvince'] ?? '',
      idDistrict: json['idDistrict'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Commune {
  final String idDistrict;
  final String idCommune;
  final String name;

  Commune({
    required this.idDistrict,
    required this.idCommune,
    required this.name,
  });

  factory Commune.fromJson(Map<String, dynamic> json) {
    return Commune(
      idDistrict: json['idDistrict'] ?? '',
      idCommune: json['idCommune'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

// Hàm tải dữ liệu
Future<List<Province>> fetchProvinces() async {
  final String response =
      await rootBundle.loadString('assets/vietnam_address.json');
  final Map<String, dynamic> data = json.decode(response);

  if (data['province'] is List) {
    final List<dynamic> provincesJson = data['province'];
    return provincesJson.map((json) => Province.fromJson(json)).toList();
  } else {
    throw Exception(
        'Dữ liệu không đúng định dạng. \'province\' không phải là List.');
  }
}

Future<List<District>> fetchDistricts() async {
  final String response =
      await rootBundle.loadString('assets/vietnam_address.json');
  final Map<String, dynamic> data = json.decode(response);

  if (data['district'] is List) {
    final List<dynamic> districtsJson = data['district'];
    return districtsJson.map((json) => District.fromJson(json)).toList();
  } else {
    throw Exception(
        'Dữ liệu không đúng định dạng. \'district\' không phải là List.');
  }
}

Future<List<Commune>> fetchCommunes() async {
  final String response =
      await rootBundle.loadString('assets/vietnam_address.json');
  final Map<String, dynamic> data = json.decode(response);

  if (data['commune'] is List) {
    final List<dynamic> communesJson = data['commune'];
    return communesJson.map((json) => Commune.fromJson(json)).toList();
  } else {
    throw Exception(
        'Dữ liệu không đúng định dạng. \'commune\' không phải là List.');
  }
}

class SelectionDialog extends StatefulWidget {
  @override
  State<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  Future<List<Province>>? futureProvinces;
  Future<List<District>>? futureDistricts;
  Future<List<Commune>>? futureCommunes;

  List<Province> provinces = [];
  List<District> districts = [];
  List<Commune> communes = [];

  Province? selectedProvince;
  District? selectedDistrict;
  Commune? selectedCommune;
  String additionalAddress = "";

  @override
  void initState() {
    super.initState();
    futureProvinces = fetchProvinces();
    futureDistricts = fetchDistricts();
    futureCommunes = fetchCommunes();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change the address'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<List<Province>>(
              future: futureProvinces,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Lỗi tỉnh thành: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có dữ liệu tỉnh thành'));
                } else {
                  provinces = snapshot.data!;
                  return DropdownButton<Province>(
                    hint: Text('Province'),
                    value: selectedProvince,
                    onChanged: (Province? newValue) {
                      setState(() {
                        selectedProvince = newValue;
                        selectedDistrict = null; // Reset selected district
                        selectedCommune = null; // Reset selected commune
                        // Load districts based on selected province
                        futureDistricts = fetchDistricts();
                      });
                    },
                    items: provinces
                        .map<DropdownMenuItem<Province>>((Province value) {
                      return DropdownMenuItem<Province>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            if (selectedProvince != null)
              FutureBuilder<List<District>>(
                future: futureDistricts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Lỗi quận huyện: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có dữ liệu quận huyện'));
                  } else {
                    districts = snapshot.data!
                        .where(
                            (d) => d.idProvince == selectedProvince!.idProvince)
                        .toList();
                    return DropdownButton<District>(
                      hint: Text('District'),
                      value: selectedDistrict,
                      onChanged: (District? newValue) {
                        setState(() {
                          selectedDistrict = newValue;
                          selectedCommune = null; // Reset selected commune
                          // Load communes based on selected district
                          futureCommunes = fetchCommunes();
                        });
                      },
                      items: districts
                          .map<DropdownMenuItem<District>>((District value) {
                        return DropdownMenuItem<District>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            if (selectedDistrict != null)
              FutureBuilder<List<Commune>>(
                future: futureCommunes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Lỗi phường xã: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có dữ liệu phường xã'));
                  } else {
                    communes = snapshot.data!
                        .where(
                            (c) => c.idDistrict == selectedDistrict!.idDistrict)
                        .toList();
                    return DropdownButton<Commune>(
                      hint: Text('Village'),
                      value: selectedCommune,
                      onChanged: (Commune? newValue) {
                        setState(() {
                          selectedCommune = newValue;
                        });
                      },
                      items: communes
                          .map<DropdownMenuItem<Commune>>((Commune value) {
                        return DropdownMenuItem<Commune>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            // Thêm TextField để người dùng nhập thêm địa chỉ nếu cần thiết
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Add detailed address (if any)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    additionalAddress = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Trả về dữ liệu đã chọn khi nhấn OK
            if (selectedProvince != null &&
                selectedDistrict != null &&
                selectedCommune != null) {
              Navigator.of(context).pop({
                'province': selectedProvince,
                'district': selectedDistrict,
                'commune': selectedCommune,
                'additionalAddress': additionalAddress,
              });
            } else {
              // Hiển thị thông báo nếu chưa chọn đầy đủ
              MsgDialog.MSG(context, 'Notification',
                  'Please select complete information');
            }
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng dialog mà không trả về dữ liệu
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
