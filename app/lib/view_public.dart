import 'package:app/shoppList.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRecepie extends StatefulWidget {
  Map<String, dynamic> items;
  ViewRecepie({required this.items});

  @override
  State<ViewRecepie> createState() => _EditListState();
}

class _EditListState extends State<ViewRecepie> {
  @override
  Widget build(BuildContext context) {
    ShoppList model = Provider.of<ShoppList>(context, listen: true);

    List<Widget> ingridiens = context
        .watch<ShoppList>()
        .getIngridientWidget(widget.items['ingridients']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.items['name']),
      ),
      body: Column(
        //mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
              onPressed: () {
                //context.push('/edit', extra: widget.items);
                db
                    .collection('lists')
                    .doc(user?.uid)
                    .collection('shopps')
                    .doc(widget.items['name'])
                    .set({
                  'name': widget.items['name'],
                  'list': widget.items['list']
                });
                // for (Map<String, dynamic> e in widget.items['list']){

                // }
              },
              child: const Text('Make shopplist')),
          Flexible(
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                children: context
                    .watch<ShoppList>()
                    .getPublicItemWidget(widget.items['list'])),
          ),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.all(8.0),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                //shrinkWrap: true,
                itemCount: ingridiens.length,
                itemBuilder: (BuildContext context, int index) {
                  return ingridiens[index];
                }),
          ),
        ],
      ),
    );
  }
}
