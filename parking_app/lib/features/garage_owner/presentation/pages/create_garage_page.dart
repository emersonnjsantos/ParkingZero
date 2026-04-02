import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_app/features/garage_owner/presentation/cubit/create_garage_cubit.dart';
import 'package:parking_app/features/garage_owner/presentation/widgets/photo_picker.dart';
import 'package:sizer/sizer.dart';

class CreateGaragePage extends StatefulWidget {
  const CreateGaragePage({super.key});

  @override
  State<CreateGaragePage> createState() => _CreateGaragePageState();
}

class _CreateGaragePageState extends State<CreateGaragePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  final _spotsCtrl = TextEditingController();
  final List<String> _selectedImages = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _spotsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CreateGarageCubit>().createGarage(
            name: _nameCtrl.text,
            latitude: double.parse(_latCtrl.text),
            longitude: double.parse(_lngCtrl.text),
            totalSpots: int.parse(_spotsCtrl.text),
            imagePaths: _selectedImages,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Garagem'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CreateGarageCubit, CreateGarageState>(
        listener: (context, state) {
          if (state is CreateGarageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Garagem criada com sucesso!')),
            );
            Navigator.of(context).pop();
          } else if (state is CreateGarageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Nome da garagem'),
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Latitude'),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Obrigatório' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lngCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Longitude'),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Obrigatório' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _spotsCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Total de vagas'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v?.isEmpty ?? true ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 20),
                PhotoPicker(
                  onImagesSelected: (paths) =>
                      setState(() {
                        _selectedImages.clear();
                        _selectedImages.addAll(paths);
                      }),
                ),
                const SizedBox(height: 30),
                BlocBuilder<CreateGarageCubit, CreateGarageState>(
                  builder: (context, state) {
                    final loading = state is CreateGarageLoading;
                    return ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : Text(
                              'Cadastrar',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
