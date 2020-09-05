class ReturnReason {
  final String reasonCode;
  final String title;

  ReturnReason(this.reasonCode, this.title);

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) =>
      other != null &&
      other is ReturnReason &&
      this.reasonCode == other.reasonCode;
}
