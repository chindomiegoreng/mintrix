import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/features/game/bloc/build_cv_bloc.dart';
import 'package:mintrix/shared/theme.dart';
import 'congrats_finishing_course.dart';
import 'cv_greeting.dart';
import 'cv_contact.dart';
import 'cv_experience.dart';
import 'cv_education.dart';
import 'cv_skills.dart';
import 'cv_summary.dart';
import 'cv_additional.dart';
import 'cv_result.dart';

class BuildCVPage extends StatefulWidget {
  const BuildCVPage({super.key});

  @override
  State<BuildCVPage> createState() => _BuildCVPageState();
}

class _BuildCVPageState extends State<BuildCVPage> {
  final PageController _pageController = PageController();
  final int _totalPages = 9;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuildCVBloc()..add(UpdateCVStep(0)),
      child: BlocConsumer<BuildCVBloc, BuildCVState>(
        listener: (context, state) {
          if (state is CVCompleted) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: whiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  _buildProgressBar(context, state),
                  Expanded(
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        int currentStep = (state is CVInProgress)
                            ? state.currentStep
                            : 0;

                        if (details.primaryVelocity! > 0 && currentStep > 0) {
                          _previousPage(context);
                        } else if (details.primaryVelocity! < 0 &&
                            currentStep < _totalPages - 1) {
                          _nextPage(context);
                        }
                      },
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CVCongratulations(onNext: () => _nextPage(context)),
                          CVGreeting(onNext: () => _nextPage(context)),
                          CVContact(
                            onNext: () => _nextPage(context),
                            onBack: () => _previousPage(context),
                          ),
                          CVExperience(
                            onNext: () => _nextPage(context),
                            onBack: () => _previousPage(context),
                          ),
                          CVEducation(
                            onNext: () => _nextPage(context),
                            onBack: () => _previousPage(context),
                          ),
                          CVSkills(
                            onNext: () => _nextPage(context),
                            onBack: () => _previousPage(context),
                          ),
                          CVSummary(
                            onNext: () => _nextPage(context),
                            onBack: () => _previousPage(context),
                          ),
                          CVAdditional(
                            onNext: () => _nextPage(context),
                            onBack: () => _previousPage(context),
                          ),
                          CVResult(
                            onComplete: () =>
                                context.read<BuildCVBloc>().add(CompleteCV()),
                            onBack: () => _previousPage(context),
                            onDownload: () {},
                          ),
                        ],
                      ),
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

  Widget _buildProgressBar(BuildContext context, BuildCVState state) {
    int step = (state is CVInProgress) ? state.currentStep : 0;

    bool isLastPage = step == _totalPages - 1;
    double progress = (step + 1) / _totalPages;

    bool showCloseIcon = step <= 1;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              showCloseIcon ? Icons.close : Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              if (showCloseIcon) {
                Navigator.pop(context);
              } else {
                _previousPage(context);
              }
            },
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
          IconButton(
            icon: Icon(
              Icons.local_fire_department,
              color: isLastPage ? Colors.orange : Colors.grey,
            ),
            onPressed: null,
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

    final bloc = context.read<BuildCVBloc>();
    final state = bloc.state;
    if (state is CVInProgress) {
      bloc.add(UpdateCVStep(state.currentStep + 1));
    }
  }

  void _previousPage(BuildContext context) {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    final bloc = context.read<BuildCVBloc>();
    final state = bloc.state;
    if (state is CVInProgress && state.currentStep > 0) {
      bloc.add(UpdateCVStep(state.currentStep - 1));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
