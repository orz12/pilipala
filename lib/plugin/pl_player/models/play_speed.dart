enum PlaySpeed {
  one,
  two,
}

extension PlaySpeedExtension on PlaySpeed {
  static final List<String> _descList = [
    '1.0',
    '2.0',
  ];
  String get description => _descList[index];

  static final List<double> _valueList = [
    1.0,
    2.0,
  ];
  double get value => _valueList[index];
  double get defaultValue => _valueList[0];
}

enum KeepLastSpeed {
  never,
  same_playlist,
  always,
}

extension KeepLastSpeedDesc on KeepLastSpeed {
  static final List<String> _descList = [
    '永不',
    '仅在同一合集内',
    '总是',
  ];
  String get description => _descList[index];
}

extension KeepLastSpeedCode on KeepLastSpeed {
  static final List<String> _codeList = [
    'never',
    'same_playlist',
    'always',
  ];
  String get code => _codeList[index];

  static KeepLastSpeed? fromCode(String code) {
    final index = _codeList.indexOf(code);
    if (index != -1) {
      return KeepLastSpeed.values[index];
    }
    return null;
  }
}
