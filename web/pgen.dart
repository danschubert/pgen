
#import('dart:html');
#import('dart:math');

void main() {
  InputElement lowerCase = query('#lowerCase');
  InputElement upperCase = query('#upperCase');
  InputElement numbers = query('#numbers');
  InputElement special = query('#special');
  InputElement generate = query('#generate');

  // Read previous checkbox values from local storage.
  readElementValue(lowerCase);
  readElementValue(upperCase);
  readElementValue(numbers);
  readElementValue(special);
  generate.disabled = !canGenerate();

  // Add checkbox event handlers which stores the last checkbox
  // state into the local storage.
  addElementHandler(lowerCase);
  addElementHandler(upperCase);
  addElementHandler(numbers);
  addElementHandler(special);
  addElementHandler(generate);

  // Automatically generate first password
  if (!generate.disabled) {
    generatePassword();
  }
}

void generatePassword() {
  List<int> charCodes = createCharPool();

  // Create password from character pool.
  Random random = new Random();
  StringBuffer result = new StringBuffer();
  for (int i = 0; i < 10; i++) {
    int charCode = charCodes[random.nextInt(charCodes.length)];
    result.addCharCode(charCode);
  }

  // Show resulting password.
  OutputElement password = query('#password');
  password.value = result.toString();
}

List<int> createCharPool() {
  InputElement lowerCase = query('#lowerCase');
  InputElement upperCase = query('#upperCase');
  InputElement numbers = query('#numbers');
  InputElement special = query('#special');
  InputElement generate = query('#generate');

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
    charPool.add("!#\$%&()*+,-./:;<=>?@[]^_{}");
  }
  return charPool.toString().charCodes();
}

bool canGenerate() {
  InputElement lowerCase = query('#lowerCase');
  InputElement upperCase = query('#upperCase');
  InputElement numbers = query('#numbers');
  InputElement special = query('#special');

  return (lowerCase.checked || upperCase.checked ||
      numbers.checked || special.checked);
}

void readElementValue(InputElement elem) {
  String saved = window.localStorage[elem.id];
  if (saved != null) {
    if (elem.type == 'checkbox') {
      elem.checked = (saved == "true") ? true : false;
    }
  }
}

void addElementHandler(InputElement elem) {
  if (elem.type == 'checkbox') {
    elem.on.click.add((Event e) {
      window.localStorage[elem.id] = elem.checked.toString();
      InputElement generate = query('#generate');
      generate.disabled = !canGenerate();
    });
  } else if (elem.type == 'submit') {
    if (elem.id == 'generate') {
      elem.on.click.add((Event e) {
        generatePassword();
      });
    }
  }
}
