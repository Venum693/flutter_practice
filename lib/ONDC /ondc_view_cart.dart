import 'package:flutter/material.dart';

class OndcViewCart extends StatefulWidget {
   List<Map<String, dynamic>> cartItems;
  final List<Map<String, dynamic>> nImages;
  final Function(String, int) updateItemCount;// Callback function


  OndcViewCart({required this.cartItems, required this.nImages, required this.updateItemCount});

  @override
  _OndcViewCartState createState() => _OndcViewCartState();
}

class _OndcViewCartState extends State<OndcViewCart> {


  void decrementCount(String name) {
    int index = widget.cartItems.indexWhere((item) => item['name'] == name);
    print('$name================');
    if (index != -1 && widget.cartItems[index]['count'] > 0) {
      setState(() {
        //widget.cartItems[index]['count']--;
        for (int i = 0; i < widget.nImages.length; i++) {
          if (widget.nImages[i]['name'] == name) {
            widget.nImages[i]['count']--;
            break;
          }
        }
        widget.updateItemCount(name, widget.cartItems[index]['count']);
      });
    }
  }

  void incrementCount(String name) {
    int index = widget.cartItems.indexWhere((item) => item['name'] == name);
    print('$name================');
    if (index != -1) {
      setState(() {
        //widget.cartItems[index]['count']++;
        for (int i = 0; i < widget.nImages.length; i++) {
          if (widget.nImages[i]['name'] == name) {
            widget.nImages[i]['count']++;
            break;
          }
        }
        widget.updateItemCount(name, widget.cartItems[index]['count']);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final String name = widget.cartItems[index]['name'];
          final NetworkImage image = widget.cartItems[index]['image'];
          final String supplier = widget.cartItems[index]['supplier'];
          final int price = widget.cartItems[index]['price'];
          final int count = widget.cartItems[index]['count'];

          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: Image(
                        image: image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Flexible(
                  flex: 2,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      Text(supplier,style: TextStyle(fontSize: 16,)),
                      Text('₹$price',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      //decrementCount(index);
                      decrementCount(name);
                    }, icon: Icon(Icons.remove_circle_outline)),
                    Text('$count',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                    IconButton(onPressed: (){
                      //incrementCount(index);
                      incrementCount(name);
                    }, icon: Icon(Icons.add_circle_outline))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }


}
