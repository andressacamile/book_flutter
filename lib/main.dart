import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const Bookflutter());
}

class Bookflutter extends StatelessWidget {
  const Bookflutter({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  String searchQuery = '';
  int itemCount = 0;

  void _buscarLivros() async {
    setState(() {
      searchQuery = _controller.text;
    });

    final url = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      {'q': searchQuery},
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        itemCount = jsonResponse['totalItems'];
      });

      print('Número de livros sobre $searchQuery: $itemCount.');
    } else {
      print('A requisição falhou com o status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Livros'),
      ),
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(

                  border: OutlineInputBorder(),

                  hintText: 'pesquisa',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 150, 
                child: ElevatedButton.icon(
                  onPressed: _buscarLivros,
                  icon: const Icon(Icons.search),
                  label: const Text('Pesquisar'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Foram encontrados $itemCount livros sobre ${_controller.text}:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> operacaoAssincrona() async {
  print('Início do evento assíncrono');
  await Future.delayed(Duration(seconds: 2));
  print('Fim do evento assíncrono');
}
