import 'package:e1/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Producto.dart';

class ShoppingCarScreen extends StatefulWidget {
  ShoppingCarScreen({super.key, required this.productosAComprar});

  List<Producto> productosAComprar;
  @override
  State<ShoppingCarScreen> createState() => _ShoppingCarScreenState(productosAComprar);
}

class _ShoppingCarScreenState extends State<ShoppingCarScreen> {

  _ShoppingCarScreenState(this.productosEnCarrito);

  List<Producto> productosEnCarrito;

  quitarProducto(int index){
    setState(() {
      var productoSelected = productosEnCarrito[index];

      //una vez removido el producto de la lista de agregados al carrito
      //se debe sumar esa cantidad a la lista de entradas
      var currentProduct = productos.firstWhere((element) => element.id == productoSelected.id);
      currentProduct.cantidad = currentProduct.cantidad + productoSelected.cantidad;

      productosEnCarrito.removeAt(index);
    });
  }

  num totalAPagar(){
    num total = 0;

    for(int i = 0; i < productosEnCarrito.length; i++){
      total = total + productosEnCarrito[i].cantidad * productosEnCarrito[i].precioUnitario;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi carrito"),
      ),
      body: productosEnCarrito.isEmpty ? const Text("Sin productos agregados") : ListView.builder(
        itemCount: productosEnCarrito.length,
          itemBuilder: (BuildContext context, int index){
           return Card(
             child: Column(
               children: [
                 ListTile(
                   leading:  Image.asset(
                       height: 45,
                       "lib/images/prod_icon.png"
                   ),
                   title: Text(productosEnCarrito[index].nombre),
                   subtitle: Column(
                     children: [
                       Row(
                         children: [
                           Text("Cant:", style: TextStyle(fontWeight: FontWeight.bold)),
                           Text(productosEnCarrito[index].cantidad.toString()),
                         ],
                       ),
                       Row(
                         children: [
                           Text("Precio: ", style: TextStyle(fontWeight: FontWeight.bold)),
                           Text(productosEnCarrito[index].precioUnitario.toString())
                         ],
                       ),
                       Row(
                         children: [
                           Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold)),
                           Text((productosEnCarrito[index].precioUnitario * productosEnCarrito[index].cantidad).toString())
                         ],
                       )
                     ],
                   ),
                   trailing: IconButton(
                     onPressed: () {
                       quitarProducto(index);
                     },
                     icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                   ),
                 ),
                 Text(totalAPagar().toString())
               ],
             )
           );
          }
      ),
    );
  }
}
