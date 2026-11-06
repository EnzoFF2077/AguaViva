import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

const _cardColor = Color(0xFFEEF3FA);
const _borderColor = Color(0xFFD0DEE9);
const _titleStyle = TextStyle(
  color: AppColors.text,
  fontSize: 17,
  fontWeight: FontWeight.w700,
);
const _bodyStyle = TextStyle(color: AppColors.text, fontSize: 15, height: 1.35);
const _mutedStyle = TextStyle(
  color: AppColors.muted,
  fontSize: 14,
  height: 1.35,
);

class TreatmentGuidePage extends StatefulWidget {
  const TreatmentGuidePage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<TreatmentGuidePage> createState() => _TreatmentGuidePageState();
}

class _TreatmentGuidePageState extends State<TreatmentGuidePage> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          tooltip: 'Voltar',
          onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Como tratar a água',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        children: [
          const _OfflineBanner(),
          const SizedBox(height: 16),
          _MethodSelector(
            selected: _selected,
            onChanged: (value) => setState(() => _selected = value),
          ),
          if (_selected == 0)
            const _BoilingGuide()
          else
            const _ChlorinationGuide(),
          const SizedBox(height: 12),
          const Text(
            'Fonte: Ministério da Saúde · Ver orientações',
            style: _mutedStyle,
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.check, color: AppColors.primary, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text('Disponível mesmo sem internet', style: _mutedStyle),
          ),
        ],
      ),
    );
  }
}

class _MethodSelector extends StatelessWidget {
  const _MethodSelector({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Fervura', 'Cloração'];
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: _borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: Semantics(
                button: true,
                selected: selected == index,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(index),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected == index ? AppColors.primary : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        color: selected == index
                            ? Colors.white
                            : AppColors.muted,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
}

class _BoilingGuide extends StatelessWidget {
  const _BoilingGuide();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text('Na falta do hipoclorito, siga estes passos.', style: _mutedStyle),
        SizedBox(height: 10),
        _BoilingStep(
          number: 1,
          icon: Icon(
            Icons.filter_alt_outlined,
            color: AppColors.primary,
            size: 30,
          ),
          title: 'Prepare e filtre',
          text: 'Lave as mãos. Coe a água\ncom filtro ou pano limpo.',
        ),
        _BoilingStep(
          number: 2,
          icon: Icon(
            Icons.soup_kitchen_outlined,
            color: AppColors.primary,
            size: 30,
          ),
          title: 'Ferva por 5 minutos',
          text: 'Conte depois que a água\ncomeçar a ferver.',
        ),
        _BoilingStep(
          number: 3,
          icon: _JarIcon(size: 26),
          title: 'Espere esfriar',
          text: 'Depois, agite a água\nantes de beber.',
        ),
        _BoilingStep(
          number: 4,
          icon: _JarIcon(size: 26),
          title: 'Guarde com cuidado',
          text: 'Use recipiente limpo,\ncom tampa.',
        ),
      ],
    );
  }
}

class _BoilingStep extends StatelessWidget {
  const _BoilingStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.text,
  });

  final int number;
  final Widget icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return _GuideCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: icon,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _titleStyle),
                const SizedBox(height: 8),
                Text(text, style: _bodyStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChlorinationGuide extends StatelessWidget {
  const _ChlorinationGuide();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 14),
        _GuideCard(
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Use hipoclorito de sódio a 2,5%,\npróprio para tratar água de beber.',
                  style: _mutedStyle,
                ),
              ),
            ],
          ),
        ),
        _ChlorinationStep(
          icon: Icon(
            Icons.filter_alt_outlined,
            color: AppColors.primary,
            size: 32,
          ),
          title: '1. Prepare e filtre',
          text: Text(
            'Lave as mãos. Coe a água\ncom filtro ou pano limpo.',
            style: _bodyStyle,
          ),
        ),
        _ChlorinationStep(
          icon: Icon(
            Icons.medication_outlined,
            color: AppColors.primary,
            size: 32,
          ),
          title: '2. Adicione as gotas',
          text: Text('Para cada litro de água: 2 gotas.', style: _mutedStyle),
          footer: Row(
            children: [
              Expanded(
                child: _DoseBox(volume: '1 litro', dose: '2 gotas'),
              ),
              SizedBox(width: 11),
              Expanded(
                child: _DoseBox(volume: '2 litros', dose: '4 gotas'),
              ),
              SizedBox(width: 11),
              Expanded(
                child: _DoseBox(volume: '5 litros', dose: '10 gotas'),
              ),
            ],
          ),
        ),
        _ChlorinationStep(
          icon: Icon(Icons.schedule, color: AppColors.primary, size: 32),
          title: '3. Misture e espere',
          text: Text('Aguarde 30 minutos\nantes de beber.', style: _bodyStyle),
        ),
        _ChlorinationStep(
          icon: _JarIcon(size: 28),
          title: '4. Guarde com tampa',
          text: Text(
            'Use recipiente limpo.\nConsuma em até 24 horas.',
            style: _bodyStyle,
          ),
        ),
      ],
    );
  }
}

class _ChlorinationStep extends StatelessWidget {
  const _ChlorinationStep({
    required this.icon,
    required this.title,
    required this.text,
    this.footer,
  });

  final Widget icon;
  final String title;
  final Widget text;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return _GuideCard(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 38, child: Center(child: icon)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _titleStyle),
                    const SizedBox(height: 4),
                    text,
                  ],
                ),
              ),
            ],
          ),
          if (footer case final footer?) ...[
            const SizedBox(height: 14),
            footer,
          ],
        ],
      ),
    );
  }
}

class _DoseBox extends StatelessWidget {
  const _DoseBox({required this.volume, required this.dose});

  final String volume;
  final String dose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            volume,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            dose,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: _borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class _JarIcon extends StatelessWidget {
  const _JarIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size * 0.8, size), painter: _JarPainter());
  }
}

class _JarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;
    final w = size.width;
    final h = size.height;

    canvas.drawLine(
      Offset(w * 0.2, h * 0.05),
      Offset(w * 0.8, h * 0.05),
      paint,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        w * 0.06,
        h * 0.18,
        w * 0.94,
        h * 0.96,
        Radius.circular(w * 0.16),
      ),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.3, h * 0.55)
        ..quadraticBezierTo(w * 0.4, h * 0.45, w * 0.5, h * 0.55)
        ..quadraticBezierTo(w * 0.6, h * 0.65, w * 0.7, h * 0.55),
      paint,
    );
  }

  @override
  bool shouldRepaint(_JarPainter oldDelegate) => false;
}
