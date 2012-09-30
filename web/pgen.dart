
#import('dart:html');
#import('dart:math');

void main() {
  InputElement lowerCase = query('#lowerCase');
  InputElement upperCase = query('#upperCase');
  InputElement numbers = query('#numbers');
  InputElement special = query('#special');
  InputElement generate = query('#generate');

  // Read previous checkbox values from local storage.
  readCheckboxValue(lowerCase);
  readCheckboxValue(upperCase);
  readCheckboxValue(numbers);
  readCheckboxValue(special);
  generate.disabled = !canGenerate();

  // Add checkbox event handlers which stores the last checkbox
  // state into the local storage.
  addCheckboxHandler(lowerCase);
  addCheckboxHandler(upperCase);
  addCheckboxHandler(numbers);
  addCheckboxHandler(special);

  generate.on.click.add((Event e) {
    generatePassword();
  });
  if (!generate.disabled) {
    generatePassword();
  }
}

void generatePassword() {
  InputElement lowerCase = query('#lowerCase');
  InputElement upperCase = query('#upperCase');
  InputElement numbers = query('#numbers');
  InputElement special = query('#special');
  InputElement generate = query('#generate');
  OutputElement password = query('#password');

  // Prepare character pool.
  StringBuffer charPool = new StringBuffer();
  if (lowerCase.checked) {
    charPool.add("abcdefghijklmnopqrstuvwxyz");
  }
  if (upperCase.checked) {
    charPool.add("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  }
  if (numbers.checked) {
    charPool.add("0123456789");
  }
  if (special.checked) {
    charPool.add("!\"#\$%&'()*+,-'./:;<=>?@[\\]^_{|}~");
  }
  List<int> charCodes = charPool.toString().charCodes();

  // Create passwort from character pool.
  Random random = new Random();
  StringBuffer result = new StringBuffer();
  for (int i = 0; i < 10; i++) {
    result.addCharCode(charCodes[random.nextInt(charPool.length)]);
  }
  password.value = result.toString();
}

bool canGenerate() {
  InputElement lowerCase = query('#lowerCase');
  InputElement upperCase = query('#upperCase');
  InputElement numbers = query('#numbers');
  InputElement special = query('#special');
  return (lowerCase.checked || upperCase.checked ||
      numbers.checked || special.checked);
}

void readCheckboxValue(InputElement checkbox) {
  String saved = window.localStorage[checkbox.id];
  if (saved != null) {
    checkbox.checked = (saved == "true") ? true : false;
  }
}

void addCheckboxHandler(InputElement checkbox) {
  checkbox.on.click.add((Event e) {
    window.localStorage[checkbox.id] = checkbox.checked.toString();
    InputElement generate = query('#generate');
    generate.disabled = !canGenerate();
  });
}
