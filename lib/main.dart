import 'package:e1/pages/CarScreen.dart';
import 'package:flutter/material.dart';
import 'package:e1/models/Producto.dart';

List<Producto> productos = [
  Producto(1, "Mouse","Mouse Inhalambrico barato", 10, 3000, false, null)
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: myHomePage(),
    );
  }
}

class myHomePage extends StatefulWidget {
  const myHomePage({super.key});

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  TextEditingController cantidadEditingAddToCart = TextEditingController(text: "0");
  //controladores del formulario
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescripcionController = TextEditingController();
  TextEditingController productCantidadController = TextEditingController();
  TextEditingController productPrecioController = TextEditingController();
   List<Producto> productosInCar = [];

  agregarProducto(){
    setState(() {
      var prodToAdd = Producto(
          productos.length + 1,
          productNameController.value.text.toString(),
          productDescripcionController.value.text.toString(),
          int.parse(productCantidadController.value.text.toString()),
          num.parse(productPrecioController.value.text.toString()),
          false,
          null
      );
      productos.add(prodToAdd);
    });
  }

  refrescarLista(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return ShoppingCarScreen(productosAComprar: productosInCar);
                  })
              ).then((value) => {
                refrescarLista()
              });
            },
          )
        ],
      ),
    body: SafeArea(
        child:Padding(
          padding: EdgeInsets.all(8),
          child: productos.isEmpty ? sinMatriculas() : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                    child: ListTile(
                      title: Text("${productos[index].nombre}(${productos[index].precioUnitario})", style: TextStyle(fontWeight: FontWeight.bold),),
                      leading:  Image.asset(
                        height: 45,
                          "lib/images/prod_icon.png"
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productos[index].descripcion),
                          Row(
                            children: [
                              Text("Cant: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(productos[index].cantidad.toString())
                            ],
                          )
                        ],
                      ),
                      trailing: MaterialButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context)=> AlertDialog(
                            title: const Text("Agregar al carrito"),
                            content: TextFormField(
                              keyboardType: const TextInputType.numberWithOptions(
                                  signed: false,
                                  decimal: false
                              ),
                              decoration: const InputDecoration(
                                label: Text("Ingrese la cantidad"),
                              ),
                              controller: cantidadEditingAddToCart,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    var cantidadIngresada = int.parse(cantidadEditingAddToCart.value.text.toString());

                                    //si todavia hay de ese producto en existencia
                                    if(productos[index].cantidad >= cantidadIngresada){
                                      var currentProduct = productos[index];

                                      var prodToCar = Producto(
                                        currentProduct.id,
                                          currentProduct.nombre,
                                          currentProduct.descripcion,
                                          cantidadIngresada,
                                          currentProduct.precioUnitario,
                                          currentProduct.vence,
                                          currentProduct.fechaDeVencimiento
                                      );
                                      productosInCar.add(prodToCar);

                                      //restar la cantidad disponible
                                      currentProduct.cantidad = currentProduct.cantidad - cantidadIngresada;
                                    }
                                    Navigator.pop(context, 'OK');
                                  });
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text("Add to Cart", style: TextStyle(color: Colors.amber)),
                      ),
                    )
                );
              }
          )
        )
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: MaterialButton(
                  onPressed: () {},
                child: const Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info),
                    Text(" Información del producto")
                  ],
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      label: Text("Nombre del producto")
                    ),
                    controller: productNameController,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        label: Text("Descripción del producto")
                    ),
                    controller: productDescripcionController,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text("Cantidad")
                    ),
                    controller: productCantidadController,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text("Precio")
                    ),
                    controller: productPrecioController,
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    agregarProducto();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
        ),
        child: const Icon(Icons.add))
    );
  }
}

Widget sinMatriculas(){
  return const Center(
    child: Text("¡Sin registros de Productos!"),
  );
}

