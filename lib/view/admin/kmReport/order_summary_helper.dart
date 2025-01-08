import 'package:flutter/material.dart';

class SummaryTable extends StatelessWidget {
  final double totalKm;
  final int totalParcelCount;
  final double totalAmount;
  final int totalOrders;

  const SummaryTable({
    Key? key,
    required this.totalKm,
    required this.totalParcelCount,
    required this.totalAmount,
    required this.totalOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('No')),
        DataColumn(label: Text('Beschreibung')),
        DataColumn(label: Text('Menge ')),
        DataColumn(label: Text('Einzelpreis')),
        DataColumn(label: Text('Mwst')),
        DataColumn(label: Text('Preis in CHF')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('151')),
          const DataCell(Text('Quickrun GmbH Auto K.M')),
          const DataCell(Text('0.6')),
          DataCell(Text((totalKm * 2).toStringAsFixed(2))),
          const DataCell(Text('8.1%')),
          DataCell(Text(
              (((totalKm * 2 * 0.6) * (8.1 / 100)) + (totalKm * 2 * 0.6))
                  .toStringAsFixed(2))),
        ]),
        DataRow(cells: [
          const DataCell(Text('152')),
          const DataCell(Text('Quickrun GmbH Abholen 1')),
          const DataCell(Text('5')),
          DataCell(Text(totalOrders.toString())),
          const DataCell(Text('8.1%')),
          DataCell(Text((((totalOrders * 5) * (8.1 / 100)) + (totalOrders * 5))
              .toStringAsFixed(2))),
        ]),
        DataRow(cells: [
          const DataCell(Text('153')),
          const DataCell(Text('Quickrun GmbH Abholen 2 bis ---')),
          const DataCell(Text('2.5')),
          DataCell(Text((totalParcelCount - totalOrders).toString())),
          const DataCell(Text('8.1%')),
          DataCell(Text(
              ((((totalParcelCount - totalOrders) * 2.5) * (8.1 / 100)) +
                      ((totalParcelCount - totalOrders) * 2.5))
                  .toStringAsFixed(2))),
        ]),
        DataRow(cells: [
          const DataCell(Text('154')),
          const DataCell(Text('Quickrun GmbH Lieferung 1')),
          const DataCell(Text('5')),
          DataCell(Text(totalParcelCount.toString())),
          const DataCell(Text('8.1%')),
          DataCell(Text(
              (((totalParcelCount * 5) * (8.1 / 100)) + (totalParcelCount * 5))
                  .toStringAsFixed(2))),
        ]),
        DataRow(cells: [
          const DataCell(Text('155')),
          const DataCell(Text('Quickrun GmbH App')),
          const DataCell(Text('150')),
          const DataCell(Text('1')),
          const DataCell(Text('8.1%')),
          const DataCell(Text('150')),
        ]),
        DataRow(cells: [
          const DataCell(Text('157')),
          const DataCell(Text('Bezahlung in bar')),
          const DataCell(Text('0')),
          const DataCell(Text('0')),
          const DataCell(Text('0')),
          DataCell(Text('-${totalAmount.toStringAsFixed(2)}')),
        ]),
      ],
    );
  }
}
