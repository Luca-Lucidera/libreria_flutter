class Book {
  String id;
  String title;
  int purchased;
  int read;
  String type;
  String status;
  String publisher;
  double price;
  double rating;
  String comment;

  Book(this.id, this.title, this.purchased, this.read, this.type, this.status,
      this.publisher, this.price, this.rating, this.comment);

  Book.empty()
      : id = "",
        purchased = 1,
        read = 0,
        title = "",
        type = "Manga",
        status = "Plan To Read",
        publisher = "JPOP",
        price = 1.0,
        rating = 0.0,
        comment = "";

  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        purchased = json['purchased'],
        read = json['read'],
        type = json['type'],
        status = json['status'],
        publisher = json['publisher'],
        price = json['price'] + .0,
        rating = json['rating'] + .0,
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

  factory Book.cloneWith(Book source) {
    return Book(
      source.id,
      source.title,
      source.purchased,
      source.read,
      source.type,
      source.status,
      source.publisher,
      source.price,
      source.rating,
      source.comment
    );
  }
}
