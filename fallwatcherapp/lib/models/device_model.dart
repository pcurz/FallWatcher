class Device {
  final String mac;
  final String name;
  String status;

  Device({required this.mac, required this.name, this.status = 'good'});

  Map<String, String> toJson() => {
        'mac': mac,
        'name': name,
        'status': status,
      };

  static Device fromJson(Map<String, String> json) {
    return Device(
      mac: json['mac']!,
      name: json['name']!,
      status: json['status']!,
    );
  }
}
