class ParentCategory {
  String? id;
  String? name;
  String? description;
  String? handle;
  int? rank;

  ParentCategory({
    this.id,
    this.name,
    this.description,
    this.handle,
    this.rank,
  });

  factory ParentCategory.fromJson(Map<String, dynamic> json) {
    return ParentCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      handle: json['handle'],
      rank: json['rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'handle': handle,
      'rank': rank,
    };
  }
}
