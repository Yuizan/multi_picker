import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_picker/picker_tree.dart';

class MultiPicker extends StatefulWidget {
  MultiPicker(
      {Key key,
      String title,
      String confirmText,
      @required this.children,
      this.onConfirm})
      : title = (title == null ? "" : title),
        confirmText = (confirmText == null ? "Confirm" : confirmText),
        super(key: key);

  final List<List<Map<int, String>>> children;

  final String title;

  final String confirmText;

  final void Function(List<Map<int, String>>) onConfirm;

  @override
  _MultiPickerState createState() => _MultiPickerState();
}

class _MultiPickerState extends State<MultiPicker> {
  List<Map<int, String>> selectedRows = [];

  PickerTree pickerTree;

  @override
  void initState() {
    super.initState();
    initShowList();
  }

  void initShowList() {
    pickerTree = new PickerTree();
    widget.children.forEach((list) {
      list.forEach((node) {
        pickerTree.add(node.keys.first, node.values.first);
      });
    });

    if (selectedRows.length == 0 &&
        widget.children.length > 0 &&
        widget.children.first.length > 0) {
      selectedRows.add(widget.children.first.first);

      fillSelectedRows();
    }
  }

  void onClickConfirm() {
    if (widget.onConfirm != null) {
      widget.onConfirm(selectedRows);
    }
  }

  void onChangePicker(int position, int index) {
    if (index == 0) {
      selectedRows[index] = {
        pickerTree.root[position].k: pickerTree.root[position].v
      };
    } else {
      Map<int, String> topNode = selectedRows[index - 1];
      Node node = pickerTree.get(topNode.keys.first).children[position];
      selectedRows[index] = {node.k: node.v};
    }

    for (int i = index + 1, length = selectedRows.length; i < length; i++) {
      selectedRows.removeAt(index + 1);
    }
    fillSelectedRows();
  }

  void fillSelectedRows() {
    for (;;) {
      Node node = pickerTree.get(selectedRows.last.keys.first);
      if (node == null || node.children.length == 0) {
        this.setState(() {
          selectedRows = selectedRows;
        });
        break;
      }
      selectedRows.add({node.children.first.k: node.children.first.v});
    }
  }

  Iterable<Widget> _renderTitle(int index) {
    Iterable<Widget> widgets = [];
    if (index == 0) {
      widgets = pickerTree.root.map((node) {
        return Container(
          width: double.maxFinite,
          child: Center(
            child: Text(node.v),
          ),
        );
      });
    } else {
      Map<int, String> obj = selectedRows[index - 1];
      widgets = pickerTree.get(obj.keys.first).children.map((node) {
        return Container(
          width: double.maxFinite,
          child: Center(
            child: Text(node.v),
          ),
        );
      });
    }
    return widgets;
  }

  Iterable<Widget> _renderPicker() {
    List<Widget> list = [];
    for (int i = 0; i < widget.children.length; i++) {
      list.add(Expanded(
        child: CupertinoPicker(
          itemExtent: 45,
          backgroundColor: Colors.white,
          onSelectedItemChanged: (position) {
            onChangePicker(position, i);
          },
          children: _renderTitle(i).toList(),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
              border: new Border.all(color: Colors.white, width: 5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, size: 24, color: Colors.black54),
                ),
                Text(widget.title,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: onClickConfirm,
                  child: Container(
                      height: 45,
                      child: Center(
                          child: Text(widget.confirmText,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)))),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _renderPicker().toList(),
            ),
          ),
        ],
      ),
    );
  }
}
