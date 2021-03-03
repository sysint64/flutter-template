class SerdesJson {
  final bool convertToSnakeCase;
  final bool toJson;
  final bool fromJson;

  const SerdesJson({
    this.convertToSnakeCase = false,
    this.toJson = true,
    this.fromJson = true,
  });
}
