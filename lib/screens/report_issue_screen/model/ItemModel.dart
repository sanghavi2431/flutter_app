/// label : "Nigeria"
/// value : 1

class ItemModel {
  ItemModel({
    String? label,
    int? value,
  }) {
    _label = label;
    _value = value;
  }

  ItemModel.fromJson(dynamic json) {
    _label = json['label']?.toString();
    _value = int.tryParse(json['value']?.toString() ?? '0');
  }

  String? _label;
  int? _value;

  String? get label => _label;
  int? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }
}
