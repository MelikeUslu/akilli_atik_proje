final class Location {
  const Location({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  bool get isValid {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Location &&
            other.latitude == latitude &&
            other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
