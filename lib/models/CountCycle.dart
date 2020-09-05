class CountCycle {
  final int count;
  final String title;

  CountCycle(this.count, this.title);

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) =>
      other != null &&
      other is CountCycle &&
      this.count == other.count &&
      this.title == other.title;
}
