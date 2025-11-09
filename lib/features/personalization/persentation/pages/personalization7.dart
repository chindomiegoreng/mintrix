import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'package:mintrix/widgets/buttons.dart';
import '../bloc/personalization_bloc.dart';
import '../bloc/personalization_event.dart';
import '../bloc/personalization_state.dart';

class Personalization7 extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Personalization7({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Personalization7> createState() => _Personalization7State();
}

class _Personalization7State extends State<Personalization7> {
  final TextEditingController _storyController = TextEditingController();
  int _characterCount = 0;
  final int _minCharacters = 10;
  final int _maxCharacters = 500;

  // ✅ Suggested story prompts (bisa dari API nanti)
  final List<String> _storyPrompts = [
    'Aku suka belajar hal baru...',
    'Hobiku adalah...',
    'Yang bikin aku semangat adalah...',
    'Aku ingin mengembangkan skill di bidang...',
    'Cita-citaku adalah...',
  ];

  @override
  void initState() {
    super.initState();
    _storyController.addListener(_updateCharacterCount);
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _storyController.text.length;
    });
    context.read<PersonalizationBloc>().add(UpdateStory(_storyController.text));
  }

  void _usePrompt(String prompt) {
    setState(() {
      _storyController.text = prompt;
      _characterCount = prompt.length;
    });
  }

  void _clearText() {
    setState(() {
      _storyController.clear();
      _characterCount = 0;
    });
  }

  bool get _isValid =>
      _characterCount >= _minCharacters && _characterCount <= _maxCharacters;

  Color get _counterColor {
    if (_characterCount < _minCharacters) {
      return Colors.red;
    } else if (_characterCount > _maxCharacters) {
      return Colors.red;
    } else {
      return bluePrimaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ceritakan Tentang Dirimu',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ceritakan tentang kepribadianmu, minat, hobi, atau hal yang membuatmu unik. '
                'Ini akan membantu kami membuat pengalaman yang lebih personal untukmu!',
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // ✅ Step Indicator dengan Back Button
              Row(
                children: [
                  Transform.translate(
                    offset: const Offset(-12, 0),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: widget.onBack,
                    ),
                  ),
                  const SizedBox(width: 2),
                  _buildStepIndicator(true, '1'),
                  _buildStepLine(true),
                  _buildStepIndicator(true, '2'),
                  _buildStepLine(true),
                  _buildStepIndicator(true, '3'),
                ],
              ),
              const SizedBox(height: 24),

              // ✅ Suggested Prompts (Scrollable)
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _storyPrompts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _usePrompt(_storyPrompts[index]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: bluePrimaryColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: bluePrimaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _storyPrompts[index],
                              style: primaryTextStyle.copyWith(
                                fontSize: 12,
                                color: bluePrimaryColor,
                                fontWeight: medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Character Counter dengan Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minimal $_minCharacters karakter',
                    style: secondaryTextStyle.copyWith(fontSize: 12),
                  ),
                  Row(
                    children: [
                      Text(
                        '$_characterCount/$_maxCharacters',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: semiBold,
                          color: _counterColor,
                        ),
                      ),
                      if (_characterCount > 0) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _clearText,
                          child: Icon(
                            Icons.clear,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ✅ Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _characterCount / _maxCharacters,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_counterColor),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Text Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _characterCount > 0
                          ? (_isValid
                                ? bluePrimaryColor.withOpacity(0.5)
                                : Colors.red.withOpacity(0.5))
                          : const Color(0xFFE5E5E5),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _storyController,
                    maxLines: null,
                    expands: true,
                    maxLength: _maxCharacters,
                    textAlignVertical: TextAlignVertical.top,
                    style: primaryTextStyle.copyWith(fontSize: 14, height: 1.5),
                    decoration: InputDecoration(
                      hintText:
                          'Contoh: Aku suka belajar programming dan tertarik dengan AI. '
                          'Hobiku menggambar dan mendengarkan musik. '
                          'Aku orangnya teliti tapi kadang suka overthinking. '
                          'Pengen banget jago bikin aplikasi mobile!',
                      hintStyle: secondaryTextStyle.copyWith(
                        fontSize: 14,
                        height: 1.5,
                      ),
                      border: InputBorder.none,
                      counterText: '', // Hide default counter
                    ),
                  ),
                ),
              ),

              // ✅ Validation Message
              if (_characterCount > 0 && !_isValid) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _characterCount < _minCharacters
                              ? 'Ceritamu terlalu pendek. Tambah ${_minCharacters - _characterCount} karakter lagi!'
                              : 'Ceritamu terlalu panjang. Kurangi ${_characterCount - _maxCharacters} karakter!',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // ✅ Privacy Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bluePrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 20, color: bluePrimaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ceritamu aman bersama kami. Lihat Kebijakan Privasi',
                        style: primaryTextStyle.copyWith(
                          fontSize: 12,
                          color: bluePrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Button dengan Validation
              CustomFilledButton(
                title: _isValid
                    ? 'Selanjutnya'
                    : 'Ceritamu belum cukup (${_characterCount}/$_minCharacters)',
                variant: ButtonColorVariant.blue,
                onPressed: _isValid ? widget.onNext : null,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isActive, String number) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? bluePrimaryColor : const Color(0xFFE5E5E5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? whiteColor : Colors.grey,
            fontWeight: semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 8,
        color: isActive ? bluePrimaryColor : const Color(0xFFE5E5E5),
      ),
    );
  }

  @override
  void dispose() {
    _storyController.removeListener(_updateCharacterCount);
    _storyController.dispose();
    super.dispose();
  }
}
