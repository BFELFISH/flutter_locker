class AssertUtils {
  static String getAssertImagePath(String imageName, {String postfix = '.png'}) {
    if (imageName.startsWith('images/')) {
      return imageName;
    } else {
      return 'images/$imageName$postfix';
    }
  }
}
