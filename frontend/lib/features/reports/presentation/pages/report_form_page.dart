import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/report_draft.dart';
import '../../domain/entities/water_report.dart';
import '../controllers/report_controller.dart';

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key, required this.controller});

  final ReportController controller;

  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  WaterSourceType _sourceType = WaterSourceType.well;
  WaterColor _waterColor = WaterColor.normal;
  bool _hasStrongOdor = false;
  XFile? _photo;
  Position? _position;
  bool _gettingLocation = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxWidth: 1920,
      );
      if (photo != null && mounted) setState(() => _photo = photo);
    } catch (_) {
      _showError('Não foi possível abrir a câmera. Verifique a permissão.');
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      _gettingLocation = true;
      _error = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const _LocationFailure('Ative a localização do aparelho.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const _LocationFailure(
          'Permita o acesso à localização para marcar a fonte de água.',
        );
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      if (mounted) setState(() => _position = position);
    } on _LocationFailure catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Não encontramos sua localização. Tente novamente.');
    } finally {
      if (mounted) setState(() => _gettingLocation = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_photo == null) {
      _showError('Tire uma foto da água antes de continuar.');
      return;
    }
    if (_position == null) {
      _showError('Confirme a localização da fonte de água.');
      return;
    }

    setState(() => _error = null);
    try {
      final report = await widget.controller.submit(
        ReportDraft(
          sourceType: _sourceType,
          sourceName: _nameController.text.trim(),
          waterColor: _waterColor,
          hasStrongOdor: _hasStrongOdor,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          location: ReportLocation(
            latitude: _position!.latitude,
            longitude: _position!.longitude,
            accuracy: _position!.accuracy,
            confirmed: true,
          ),
          originalPhotoPath: _photo!.path,
        ),
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SavedDialog(
          waitingInternet: report.status == ReportStatus.waitingInternet,
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      _showError('Não foi possível guardar o alerta. Tente novamente.');
    }
  }

  void _showError(String message) {
    if (mounted) setState(() => _error = message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A água está estranha')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Conte o que você percebeu',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text('Leva menos de um minuto e o aviso é anônimo.'),
              const SizedBox(height: 24),
              _SectionTitle(number: 1, title: 'Tire uma foto da água'),
              const SizedBox(height: 10),
              _PhotoField(photo: _photo, onTap: _takePhoto),
              const SizedBox(height: 24),
              _SectionTitle(number: 2, title: 'De onde vem essa água?'),
              const SizedBox(height: 10),
              DropdownButtonFormField<WaterSourceType>(
                initialValue: _sourceType,
                decoration: const InputDecoration(labelText: 'Tipo da fonte'),
                items: WaterSourceType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _sourceType = value!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome ou referência do local',
                  hintText: 'Ex.: Poço do Sítio Boa Vista',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe uma referência do local.'
                    : null,
              ),
              const SizedBox(height: 24),
              _SectionTitle(number: 3, title: 'Como está a cor da água?'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WaterColor.values
                    .map(
                      (color) => ChoiceChip(
                        label: Text(color.label),
                        selected: _waterColor == color,
                        onSelected: (_) => setState(() => _waterColor = color),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              _SectionTitle(number: 4, title: 'A água tem cheiro forte?'),
              const SizedBox(height: 10),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Sim')),
                  ButtonSegment(value: false, label: Text('Não')),
                ],
                selected: {_hasStrongOdor},
                onSelectionChanged: (values) =>
                    setState(() => _hasStrongOdor = values.first),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                maxLength: 240,
                decoration: const InputDecoration(
                  labelText: 'Quer contar mais alguma coisa? (opcional)',
                ),
              ),
              const SizedBox(height: 16),
              _SectionTitle(number: 5, title: 'Confirme o local da água'),
              const SizedBox(height: 10),
              _LocationField(
                position: _position,
                loading: _gettingLocation,
                onTap: _gettingLocation ? null : _getLocation,
              ),
              if (_error case final error?) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger),
                      const SizedBox(width: 10),
                      Expanded(child: Text(error)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: widget.controller.isSubmitting ? null : _submit,
                icon: widget.controller.isSubmitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shield_outlined),
                label: Text(
                  widget.controller.isSubmitting
                      ? 'Guardando alerta...'
                      : 'Salvar alerta anônimo',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'A localização confirmada identifica a fonte de água. Nenhum nome, e-mail ou telefone é solicitado.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.number, required this.title});
  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: Text('$number'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }
}

class _PhotoField extends StatelessWidget {
  const _PhotoField({required this.photo, required this.onTap});
  final XFile? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 190,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC9D9E6)),
        ),
        child: photo == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.primary,
                    size: 44,
                  ),
                  SizedBox(height: 8),
                  Text('Toque para tirar a foto'),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(photo!.path), fit: BoxFit.cover),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: FilledButton.tonalIcon(
                      onPressed: onTap,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tirar outra'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.position,
    required this.loading,
    this.onTap,
  });
  final Position? position;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: loading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(position == null ? Icons.my_location : Icons.location_on),
      label: Text(
        position == null
            ? 'Usar minha localização atual'
            : 'Local confirmado (${position!.accuracy.toStringAsFixed(0)} m de precisão)',
      ),
    );
  }
}

class _SavedDialog extends StatelessWidget {
  const _SavedDialog({required this.waitingInternet});
  final bool waitingInternet;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        waitingInternet
            ? Icons.cloud_done_outlined
            : Icons.check_circle_outline,
        color: AppColors.success,
        size: 54,
      ),
      title: Text(
        waitingInternet ? 'Alerta salvo no aparelho' : 'Alerta enviado',
      ),
      content: Text(
        waitingInternet
            ? 'Quando houver internet, a foto será enviada automaticamente.'
            : 'A Vigilância poderá analisar o alerta e atualizar o status.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ver minhas notificações'),
        ),
      ],
    );
  }
}

class _LocationFailure implements Exception {
  const _LocationFailure(this.message);
  final String message;
}
