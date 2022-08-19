import 'dart:convert';

import 'package:http/http.dart' as http;

class Quotes {
  late String sId;
  late String author;
  late String content;
  late List<String> tags;
  late String authorSlug;
  late int length;
  late String dateAdded;
  late String dateModified;

  Quotes({
    required this.sId,
    required this.author,
    required this.content,
    required this.tags,
    required this.authorSlug,
    required this.length,
    required this.dateAdded,
    required this.dateModified,
  });

  Quotes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    author = json['author'];
    content = json['content'];
    tags = json['tags'].cast<String>();
    authorSlug = json['authorSlug'];
    length = json['length'];
    dateAdded = json['dateAdded'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['author'] = author;
    data['content'] = content;
    data['tags'] = tags;
    data['authorSlug'] = authorSlug;
    data['length'] = length;
    data['dateAdded'] = dateAdded;
    data['dateModified'] = dateModified;
    return data;
  }
}

class QuoteServiceHander {
  static Future<List<Quotes>> getQuotes(int index) async {
    List<Quotes> result = [];
    try {
      Uri uri = Uri.parse(
        'https://api.quotable.io/quotes?page=$index',
      );
      final response = await http.get(
        uri,
      );
      if (response.statusCode != 200) {
        print(response.body);
        throw Exception("Error Occured!");
      }
      List<dynamic> data = json.decode(
        response.body,
      )['results'] as List<dynamic>;

      for (int i = 0; i < 5; i++) {
        result.add(
          Quotes.fromJson(data[i]),
        );
      }
    } catch (_) {
      print(_.toString());
    }
    return result;
  }
}
