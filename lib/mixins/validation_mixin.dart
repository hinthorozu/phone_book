class ValidationMixin {
  String validateTwoChracterWithSpace(String value) {
    if (value.isEmpty) {
      return "Ad boş olamaz";
    }
    return null;
  }

  String validateEmail(String value) {
    if (!value.contains("@")) {
      return "girilen değer bir email adresi değildir. Lütfen doğru giriniz.";
    }
    return null;
  }
}
