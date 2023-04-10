import 'dart:ffi';

class Book {
  final String id;
  final String title;
  final int purchased;
  final int read;
  final String type;
  final String status;
  final String publisher;
  final String price;
  final int rating;
  final String comment;

  Book(this.id, this.title, this.purchased, this.read, this.type, this.status,
      this.publisher, this.price, this.rating, this.comment);

  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        purchased = json['purchased'],
        read = json['read'],
        type = json['type'],
        status = json['status'],
        publisher = json['publisher'],
        price = '${json['price']}',
        rating = json['rating'],
        comment = json['comment'];
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'purchased': purchased,
        'read': read,
        'type': type,
        'status': status,
        'publisher': publisher,
        'price': price,
        'rating': rating,
        'comment': comment,
      };
}
