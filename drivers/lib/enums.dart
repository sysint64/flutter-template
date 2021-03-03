class EnumString {
  static String parce<T>(T enumItem) {
    if (enumItem == null) {
      return null;
    } else {
      return enumItem.toString().split('.')[1];
    }
  }

  static T fromString<T>(List<T> enumValues, String value) {
    if (value == null) {
      return null;
    } else {
      return enumValues.singleWhere(
        (enumItem) => EnumString.parce(enumItem) == value,
        orElse: () => null,
      );
    }
  }
}
