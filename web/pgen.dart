
import 'dart:html';
import 'dart:math';

class PasswordGenerator {
  final int _length = 10;

  final InputElement _lower = query('#lower');
  final InputElement _upper = query('#upper');
  final InputElement _numbers = query('#numbers');
  final InputElement _special = query('#special');
  final InputElement _generate = query('#generate');
  final OutputElement _password = query('#password');

  void initialize() {
    // Read previous checkbox values from local storage.
    _readElementValue(_lower);
    _readElementValue(_upper);
    _readElementValue(_numbers);
    _readElementValue(_special);
    _generate.disabled = !_canGenerate;

    // Add checkbox event handlers which stores the last checkbox
    // state into the local storage.
    _addElementHandler(_lower);
    _addElementHandler(_upper);
    _addElementHandler(_numbers);
    _addElementHandler(_special);
    _addElementHandler(_generate);

    // Automatically generate first password.
    if (!_generate.disabled) {
      _generatePassword();
    }
  }

  bool get _canGenerate => (_lower.checked || _upper.checked ||
      _numbers.checked || _special.checked);

  List<int> _createCharPool() {
    var charPool = new StringBuffer();
    if (_lower.checked) {
      charPool.add("abcdefghijklmnopqrstuvwxyz");
    }
    if (_upper.checked) {
      charPool.add("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (_numbers.checked) {
      charPool.add("0123456789");
    }
    if (_special.checked) {
      charPool.add(r'!#$%&()*+,-./:;<=>?@[]^_{}');
    }
    return charPool.toString().charCodes;
  }

  void _generatePassword() {
    var charCodes = _createCharPool();
    var random = new Random();
    var result = new StringBuffer();
    for (var i = 0; i < _length; i++) {
      var charCode = charCodes[random.nextInt(charCodes.length)];
      result.addCharCode(charCode);
    }
    _password.value = result.toString();
  }

  void _readElementValue(InputElement elem) {
    var saved = window.localStorage[elem.id];
    if (saved != null) {
      if (elem.type == 'checkbox') {
        elem.checked = (saved == "true") ? true : false;
      }
    }
  }

  void _addElementHandler(InputElement elem) {
    if (elem.type == 'checkbox') {
      elem.on.click.add((Event e) {
        window.localStorage[elem.id] = elem.checked.toString();
        _generate.disabled = !_canGenerate;
      });
    } else if (elem.type == 'submit') {
      if (elem.id == 'generate') {
        elem.on.click.add((Event e) {
          _generatePassword();
        });
      }
    }
  }
}

void main() {
  var generator = new PasswordGenerator();
  if (generator != null) {
    generator.initialize();
  }
}
