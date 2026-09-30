import 'package:flutter/material.dart';

class NovoCartaoScreen extends StatefulWidget {
  const NovoCartaoScreen({Key? key}) : super(key: key);

  @override
  State<NovoCartaoScreen> createState() => _NovoCartaoScreenState();
}

class _NovoCartaoScreenState extends State<NovoCartaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nameController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveCard = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _nameController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CHECKOUT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // --- Título ---
                    const Text(
                      'Novo Cartão',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --- Scaneie seu cartão ---
                    Row(
                      children: [
                        Icon(
                          Icons.crop_free,
                          size: 24,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Scaneie seu cartão',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // --- Número do Cartão ---
                    _buildTextField(
                      controller: _cardNumberController,
                      hint: 'Número do Cartão',
                      keyboardType: TextInputType.number,
                      suffixIcon: Icon(
                        Icons.credit_card,
                        color: Colors.grey.shade500,
                        size: 22,
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Informe o número do cartão'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // --- Expira em ---
                    _buildTextField(
                      controller: _expiryController,
                      hint: 'Expira em',
                      keyboardType: TextInputType.datetime,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Informe a validade'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // --- Cardholder's Name ---
                    _buildTextField(
                      controller: _nameController,
                      hint: "Cardholder's Name",
                      keyboardType: TextInputType.name,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Informe o nome do titular'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // --- CVC/CVV 2 ---
                    _buildTextField(
                      controller: _cvvController,
                      hint: 'CVC/CVV 2',
                      keyboardType: TextInputType.number,
                      obscure: true,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Informe o CVV'
                          : null,
                    ),

                    const SizedBox(height: 28),

                    // --- Checkbox salvar informações ---
                    GestureDetector(
                      onTap: () => setState(() => _saveCard = !_saveCard),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _saveCard
                                    ? Colors.black
                                    : Colors.grey.shade400,
                                width: 1.5,
                              ),
                              color: _saveCard ? Colors.black : Colors.white,
                            ),
                            child: _saveCard
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Save Your Card Information. It's Safe.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // --- Botão Pay Now ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cartão salvo com sucesso!'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Pagar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable text field matching the design ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black54, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: validator,
    );
  }
}
