import 'package:flutter/material.dart';
import 'package:flutter_practice/ONDC%20/ondc_view_cart.dart';




class OndcCart extends StatefulWidget {
  const OndcCart({super.key});

  @override
  State<OndcCart> createState() => _OndcCartState();
}

class _OndcCartState extends State<OndcCart> {

  bool viewcart =false;
  double totalCost =0;
  int number_of_items=0;

  List<Map<String,dynamic>> nImages=[
    {
      'name': 'Tomato',
      'supplier':'Himalaya Store',
      'price': 200,
      'count':0,
      'image': NetworkImage("https://images.unsplash.com/photo-1607305387299-a3d9611cd469?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dG9tYXRvfGVufDB8fDB8fHww"),
    },
    {
      'name': 'Lemon',
      'supplier':'Bigg Basket',
      'price': 100,
      'count':0,
      'image': NetworkImage("https://images.unsplash.com/photo-1590502593747-42a996133562?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bGVtb258ZW58MHx8MHx8fDA%3D"),
    },
    {
      'name': 'Egg',
      'supplier':'Instamart',
      'price': 400,
      'count':0,
      'image': NetworkImage("https://images.unsplash.com/photo-1577111426685-1b46c38b90f5?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGVnZ3xlbnwwfHwwfHx8MA%3D%3D"),
    },
    {
      'name': 'Onion',
      'supplier':'MyHawkr',
      'price': 300,
      'count':0,
      'image': NetworkImage("https://images.unsplash.com/photo-1508747703725-719777637510?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fG9uaW9ufGVufDB8fDB8fHww"),
    },
    {
      'name': 'Potato',
      'supplier':'RelianceMart',
      'price': 500,
      'count':0,
      'image': NetworkImage("https://images.unsplash.com/photo-1590165482129-1b8b27698780?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cG90YXRvfGVufDB8fDB8fHww"),
    }
  ];

  void incrementCount(int index) {
    setState(() {
      nImages[index]['count']++;
      number_of_items++;
      totalCost=totalCost+nImages[index]['price'];
    });
  }

  void decrementCount(int index){
    setState(() {
      nImages[index]['count']--;
      number_of_items--;
      totalCost=totalCost-nImages[index]['price'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ondc cart')
      ),
      body: ListView.builder(
        itemCount: nImages.length,
          itemBuilder: (BuildContext context,int index){
            final String name = nImages[index]['name'];
            final NetworkImage image = nImages[index]['image'];
            final String supplier = nImages[index]['supplier'];
            final int price =nImages[index]['price'];
             int count=nImages[index]['count'];

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
              Flexible(
                flex: 2,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    count == 0 ?
                    ElevatedButton(
                      onPressed: (){
                        incrementCount(index);
                        setState(() {
                          viewcart=true;
                        });
                      },
                      child: Text('Add',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                    )
                        :
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              decrementCount(index);
                            }, icon: Icon(Icons.remove_circle_outline)),
                            Text('$count'),
                            IconButton(onPressed: (){
                              incrementCount(index);
                            }, icon: Icon(Icons.add_circle_outline)),
                          ],
                        )
                  ],
                ),
              )
            ],
          ),
        );
      }),
      bottomSheet: viewcart == false ? SizedBox()
          :
      Container(height: 80,
        color: Colors.amber,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('$number_of_items Items added',
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                  Text('₹$totalCost',
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                ],
              ),
              ElevatedButton(
                  onPressed: (){
                    List<Map<String, dynamic>> selectedItems = nImages.where((item) => item['count'] > 0).toList();

                    selectedItems.forEach((item) {
                      print(item);
                    });
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>OndcViewCart(
                          cartItems: selectedItems,
                          nImages: nImages,
                          updateItemCount: (name, count) {
                            print('------------>$name and $count');
                            for(int i=0;i<nImages.length;i++){
                              if(nImages[i]['name']==name){
                                setState(() {
                                  nImages[i]['count'] = count;
                                });
                              }
                            }
                        },)));
                  },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),fixedSize: Size(150, 100),
                  backgroundColor: Colors.indigo
                ),

                  child: Text('View Cart'),)
            ],
          ),
        ),
      ),
    );
  }
}
