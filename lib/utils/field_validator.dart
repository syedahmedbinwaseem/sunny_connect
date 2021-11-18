class FieldValidator {
  static String validateEmail(String value) {
    print("validateEmail : $value ");

    if (value.isEmpty) return "Enter email";

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return "Email address is not valid";
    }

    return null;
  }

  /// Password matching expression. Password must be at least 4 characters,
  /// no more than 8 characters, and must include at least one upper case letter,
  /// one lower case letter, and one numeric digit.
  static String validateField(String value,) {
    

    if (value.isEmpty) return "Field Required!";
    
    return null;
  }

  static String validatePassword(String value) {
    print("validatepassword : $value ");

    if (value.isEmpty) return "Enter password";
    if (value.length <= 6) {
      return "password must be more than 6 characters!";
    }
    return null;
  }
  
  static String validateFieldLen(String value) {
    print("validatepassword : $value ");

    if (value.isEmpty) return "Field Required*";
    if (value.length < 5) {
      return "Field must have more than 4 characters!";
    }
    return null;
  }




}
