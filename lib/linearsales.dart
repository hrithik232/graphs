class LinearSales {
  final int years;
  final int salesSc;

  LinearSales(this.years, this.salesSc);

  LinearSales.fromMap(Map<String, dynamic> map)
      : assert(map['years'] != null),
        assert(map['salesSc'] != null),
        years = map['years'],
        salesSc = map['salesSc'];
}
