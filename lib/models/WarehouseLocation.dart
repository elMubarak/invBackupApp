class WarehouseLocation {
  final String locationID;
  final String title;

  WarehouseLocation(this.locationID, this.title);

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) =>
      other != null &&
          other is WarehouseLocation &&
          this.locationID == other.locationID &&
          this.title == other.title;
}
