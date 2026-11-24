import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/report_draft.dart';
import '../../domain/entities/water_report.dart';
import '../controllers/report_controller.dart';
import 'report_success_page.dart';

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
  Uint8List? _photo;
  String? _photoPath;
  bool _saving = false;
  Position? _position;
  String? _locationLabel;
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
      if (photo == null) return;
      final bytes = await photo.readAsBytes();
      if (!mounted) return;
      setState(() {
        _photo = bytes;
        _photoPath = photo.path;
      });
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
      if (mounted) {
        setState(() {
          _position = position;
          _locationLabel =
              'Lat ${position.latitude.toStringAsFixed(5)}, '
              'Long ${position.longitude.toStringAsFixed(5)}';
        });
      }
    } on _LocationFailure catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Não encontramos sua localização. Tente novamente.');
    } finally {
      if (mounted) setState(() => _gettingLocation = false);
    }
  }

  Future<void> _submit() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;
    if (_photo == null) {
      _showError('Tire uma foto da água antes de continuar.');
      return;
    }
    if (_position == null) {
      _showError('Confirme o local encontrado pelo GPS.');
      return;
    }

    final description = _descriptionController.text.trim();
    setState(() {
      _error = null;
      _saving = true;
    });
    try {
      final report = await widget.controller.submit(
        ReportDraft(
          sourceType: _sourceType,
          sourceName: _nameController.text.trim(),
          waterColor: _waterColor,
          hasStrongOdor: _hasStrongOdor,
          description: description.isEmpty ? null : description,
          location: ReportLocation(
            latitude: _position!.latitude,
            longitude: _position!.longitude,
            accuracy: _position!.accuracy,
            confirmed: true,
          ),
          originalPhotoPath: _photoPath!,
          photoBytes: _photo,
        ),
      );
      if (!mounted) return;
      final waitingInternet =
          report.hasPendingWrites ||
          report.photoStatus != PhotoUploadStatus.uploaded;
      final seeNotifications = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => ReportSuccessPage(
            reportId: report.id,
            waitingInternet: waitingInternet,
          ),
        ),
      );
      if (mounted) Navigator.of(context).pop(seeNotifications ?? false);
    } on FirebaseException catch (error) {
      _showError('O Firebase não confirmou o alerta (${error.code}).');
    } on FormatException catch (error) {
      _showError(error.message);
    } catch (error, stack) {
      debugPrint('Falha ao salvar o alerta: $error\n$stack');
      _showError('Não foi possível guardar o alerta. Tente novamente.');
    } finally {
      if (mounted) setState(() => _saving = false);
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
              _PhotoField(photo: _photo, onTap: _takePhoto),
              const SizedBox(height: 24),
              Text(
                'De onde vem essa água?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
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
                onChanged: (value) {
                  if (value != null) setState(() => _sourceType = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nome ou referência do local',
                  hintText: 'Ex.: Poço do Sítio Boa Vista',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe uma referência do local.'
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Como está a cor da água?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
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
              Text(
                'A água tem cheiro forte?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
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
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Quer contar mais alguma coisa? (opcional)',
                  hintText: 'Ex.: água esbranquiçada depois da chuva',
                ),
              ),
              const SizedBox(height: 24),
              _LocationField(
                position: _position,
                label: _locationLabel,
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
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(_saving ? 'Enviando alerta...' : 'Enviar alerta'),
              ),
              const SizedBox(height: 14),
              const Text(
                'Seu alerta é enviado sem o seu nome. Sem internet, '
                'ele fica guardado no aparelho e sai sozinho depois.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoField extends StatelessWidget {
  const _PhotoField({required this.photo, required this.onTap});
  final Uint8List? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 200,
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
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    kIsWeb
                        ? 'Selecione a foto da água'
                        : 'Toque para tirar a foto da água',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        size: 14,
                        color: AppColors.muted,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Funciona sem internet',
                        style: TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(photo!, fit: BoxFit.cover),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: FilledButton.tonalIcon(
                      onPressed: onTap,
                      icon: const Icon(Icons.refresh),
                      label: const Text(kIsWeb ? 'Trocar foto' : 'Tirar outra'),
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
    required this.label,
    required this.loading,
    this.onTap,
  });
  final Position? position;
  final String? label;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0DEE9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                position == null ? Icons.my_location : Icons.location_on,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Local encontrado pelo GPS',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label ?? 'Toque para localizar a fonte de água',
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: loading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(position == null ? Icons.my_location : Icons.refresh),
            label: Text(
              loading
                  ? 'Localizando...'
                  : position == null
                  ? 'Usar minha localização atual'
                  : 'Atualizar localização',
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationFailure implements Exception {
  const _LocationFailure(this.message);
  final String message;
}
