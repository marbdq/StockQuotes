class Quote {
  String quote;
  String name;
  String value;
  String change;

  Quote(
      {this.quote = 'GAA', this.name = '', this.value = '', this.change = ''});

  String get valueChange => '$value ($change)';

  @override
  String toString() {
    return '${quote.toUpperCase()}: $value';
  }
}
