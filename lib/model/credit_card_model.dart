class CreditCard {
  String? id;
  String? cardHolder;
  String? cardNumber;
  String? expiryDate;
  String? cvv;

  CreditCard(
      {this.id, this.cardHolder, this.cardNumber, this.expiryDate, this.cvv});

  CreditCard.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    cardHolder = json['cardHolder'];
    cardNumber = json['cardNumber'];
    expiryDate = json['expiryDate'];
    cvv = json['cvv'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cardHolder'] = this.cardHolder;
    data['cardNumber'] = this.cardNumber;
    data['expiryDate'] = this.expiryDate;
    data['cvv'] = this.cvv;
    return data;
  }
}
