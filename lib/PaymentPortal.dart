import 'package:flutter/material.dart';

class PaymentPortal extends StatefulWidget {
  @override
  _PaymentPortalState createState() => _PaymentPortalState();
}

class _PaymentPortalState extends State<PaymentPortal> {
  final _formKey = GlobalKey<FormState>();
  String? cardType;
  String cardNumber = '';
  String expiryDate = '';
  String cvc = '';

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Show payment successful message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful!')),
      );
      // Navigate back to the previous page after a short delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Portal'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Card Type', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                value: cardType,
                onChanged: (value) {
                  setState(() {
                    cardType = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Visa'),
                    value: 'Visa',
                  ),
                  DropdownMenuItem(
                    child: Text('MasterCard'),
                    value: 'MasterCard',
                  ),
                  DropdownMenuItem(
                    child: Text('American Express'),
                    value: 'American Express',
                  ),
                ],
                validator: (value) => value == null ? 'Please select a card type' : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  cardNumber = value!;
                },
                validator: (value) => value!.isEmpty ? 'Please enter card number' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                onSaved: (value) {
                  expiryDate = value!;
                },
                validator: (value) => value!.isEmpty ? 'Please enter expiry date' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'CVC',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                onSaved: (value) {
                  cvc = value!;
                },
                validator: (value) => value!.isEmpty ? 'Please enter CVC' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPayment,
                child: Text('Pay'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
