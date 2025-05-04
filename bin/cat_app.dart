import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CatFactApp {
  List<String> factCart = [];

  // Menu
  void menu() {
    print('\n 1. Add to cart and show next fact');
    print('2. Show next fact');
    print('3. Show facts cart');
    print('4. Clear facts cart');
    print('5. Exit');
  }

  // ! HTTP GET REQUEST
  Future<String> fetchCatFact(String language) async {
    final response = await http.get(
      Uri.parse('https://catfact.ninja/fact?lang=$language'),
    );

    // Error handler + data prasing
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['fact'];
    } else {
      throw Exception('Failed to load cat fact');
    }
  }

  Future<void> run() async {
    print(
      'Good afternoon! Welcome to the Brilliant Random Cat Fact Retriever known as BRCFR',
    );
    print('Please, choose your language! (en, es, fr): ');

    String? language = stdin.readLineSync();

    while (true) {
      try {
        String fact = await fetchCatFact(language ?? 'en');
        print('\n Cat Fact: \n $fact'); // Show fact
        menu();

        String? choice = stdin.readLineSync();

        if (choice == '1') {
          factCart.add(fact);
          print('Fact added to cart');
        } else if (choice == '2') {
          continue; // restart loop
        } else if (choice == '3') {
          print('Your facts cart:');
          if (factCart.isEmpty) {
            print('No facts here :P');
          } else {
            for (var i in factCart) {
              print('- $i'); // show all
            }
          }
        } else if (choice == '4') {
          factCart.clear(); // delete all
          print('Facts cart cleared!');
        } else if (choice == '5') {
          print("Bye-bye! You're always gonna be welcome in BRCFR!"); // leave
          break;
        } else {
          print('Invalid choice, please try again.'); // default
        }
      } catch (e) {
        print('Error: $e'); // Error handler
        break;
      }
    }
  }
}

void main() {
  CatFactApp app = CatFactApp();
  app.run();
}
