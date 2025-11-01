import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/personalization/persentation/pages/personalization4.dart';
import 'package:mintrix/features/personalization/persentation/pages/personalization7.dart';
import 'package:mintrix/features/personalization/persentation/pages/personalization6.dart';
import 'package:mintrix/features/personalization/persentation/pages/personalization5.dart';
import 'package:mintrix/shared/theme.dart';
import '../bloc/personalization_bloc.dart';
import '../bloc/personalization_event.dart';
import '../bloc/personalization_state.dart';
import 'personalization1.dart';
import 'personalization2.dart';
import 'personalization3.dart';
import 'personalization8.dart';

class PersonalizationPage extends StatefulWidget {
  const PersonalizationPage({super.key});

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PersonalizationBloc()..add(UpdatePersonalizationStep(0)),
      child: BlocConsumer<PersonalizationBloc, PersonalizationState>(
        listener: (context, state) {
          if (state is PersonalizationStage1Complete) {
            _currentPage = 3;
            _pageController.jumpToPage(3);
          } else if (state is PersonalizationStage2) {
            _totalPages = 4;
          } else if (state is PersonalizationCompleted) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: whiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  if (![0, 3, 4, 5, 6, 7].contains(_currentPage))
                    _buildProgressBar(state),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        Personalization1(onNext: () => _nextPage(context)),
                        Personalization2(onNext: () => _nextPage(context)),
                        Personalization3(
                          onNext: () {
                            context
                                .read<PersonalizationBloc>()
                                .add(CompleteFirstStage());
                          },
                        ),
                        Personalization4(
                          onStart: () {
                            context
                                .read<PersonalizationBloc>()
                                .add(UpdatePersonalizationStep(0));
                            setState(() {
                              _totalPages = 4;
                            });
                            _nextPage(context);
                          },
                          onSkip: () {
                            context
                                .read<PersonalizationBloc>()
                                .add(SkipSecondStage());
                          },
                        ),
                        Personalization5(onNext: () => _nextPage(context), onBack: () => _previousPage(),),
                        Personalization6(onNext: () => _nextPage(context), onBack: () => _previousPage(),),
                        Personalization7(onNext: () => _nextPage(context), onBack: () => _previousPage(),),
                        Personalization8(
                          onComplete: () {
                            context
                                .read<PersonalizationBloc>()
                                .add(CompletePersonalization());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(PersonalizationState state) {
    int step = 0;
    if (state is PersonalizationStage1) {
      step = state.currentStep;
    } else if (state is PersonalizationStage2) {
      step = state.currentStep;
    }

    double progress = (step + 1) / _totalPages;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (step > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => _previousPage(),
            ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation<Color>(bluePrimaryColor),
                minHeight: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage(BuildContext context) {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    final bloc = context.read<PersonalizationBloc>();
    final state = bloc.state;

    if (state is PersonalizationStage1) {
      bloc.add(UpdatePersonalizationStep(state.currentStep + 1));
    } else if (state is PersonalizationStage2) {
      bloc.add(UpdatePersonalizationStep(state.currentStep + 1));
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
