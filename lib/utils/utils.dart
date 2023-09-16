// Utils Class To Validation All TextFormFields

class Utils {
  String? isEmailValid(String? email) {
    return email!.contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
        ? null
        : "Enter a valid Email";
  }

  String? isUserNameValid(String? userName) {
    return userName!.length < 3 ? "Can not be empty" : null;
  }

  String? isTitleValid(String? title) {
    return title!.length < 3 ? "Can not be empty" : null;
  }

  String? isPasswordValid(String? password) {
    return password!.length < 8 ? "Enter at least 8 characters" : null;
  }
}
