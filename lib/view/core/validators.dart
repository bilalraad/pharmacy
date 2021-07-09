String? validateEmail(String? email) {
  final emailRegEx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  if (email == null || email.isEmpty) {
    return "Please enter your email";
  } else if (!emailRegEx.hasMatch(email)) {
    return "Please enter a valid email";
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return "Please enter password";
  } else if (password.length < 6) {
    return 'Your password is too short';
  } else {
    if (password.contains(' ')) {
      return 'Password shouldn\'t have spaces';
    }
  }
  return null;
}

String? validatePhoneNo(String? phoneNo) {
  final phoneRegEx = RegExp(r"07[3-9][0-9]{8}");
  if (phoneNo == null || phoneNo.isEmpty) {
    return "Please enter phone number";
  } else if (!phoneRegEx.hasMatch(phoneNo) || phoneNo.length > 11) {
    return "Phone is not correct";
  }
  return null;
}

String? validateName(String? fullName) {
  if (fullName == null || fullName.isEmpty) {
    return "Please enter your name";
  } else if (fullName.length < 8) {
    return "Name is too short";
  }
  return null;
}

String? validateString(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a value";
  }
  return null;
}

String? validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a value";
  } else if (int.tryParse(value) == null) {
    return "Please enter a valid number";
  }
  return null;
}
