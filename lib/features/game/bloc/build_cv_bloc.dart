import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mintrix/core/models/cv_model.dart';
import 'package:mintrix/features/game/data/services/cv_service.dart';
part 'build_cv_event.dart';
part 'build_cv_state.dart';

class BuildCVBloc extends Bloc<BuildCVEvent, BuildCVState> {
  final CVService _cvService;

  BuildCVBloc({CVService? cvService})
    : _cvService = cvService ?? CVService(),
      super(CVInitial()) {
    on<UpdateCVStep>(_onUpdateCVStep);
    on<UpdateContactData>(_onUpdateContactData);
    on<UpdateExperienceData>(_onUpdateExperienceData);
    on<UpdateEducationData>(_onUpdateEducationData);
    on<UpdateSkillsData>(_onUpdateSkillsData);
    on<UpdateSummaryData>(_onUpdateSummaryData);
    on<UpdateAdditionalData>(_onUpdateAdditionalData);
    on<SubmitCV>(_onSubmitCV);
    on<DownloadCV>(_onDownloadCV);
    on<CompleteCV>(_onCompleteCV);
  }

  void _onUpdateCVStep(UpdateCVStep event, Emitter<BuildCVState> emit) {
    final currentState = state;
    if (currentState is CVInProgress) {
      emit(currentState.copyWith(currentStep: event.step));
    } else {
      emit(CVInProgress(event.step));
    }
  }

  void _onUpdateContactData(
    UpdateContactData event,
    Emitter<BuildCVState> emit,
  ) {
    final currentState = state;
    if (currentState is CVInProgress) {
      emit(currentState.copyWith(contactData: event.contactData));
    } else {
      emit(CVInProgress(0, contactData: event.contactData));
    }
  }

  void _onUpdateExperienceData(
    UpdateExperienceData event,
    Emitter<BuildCVState> emit,
  ) {
    final currentState = state;
    if (currentState is CVInProgress) {
      emit(currentState.copyWith(experienceData: event.experienceData));
    } else {
      emit(CVInProgress(0, experienceData: event.experienceData));
    }
  }

  void _onUpdateEducationData(
    UpdateEducationData event,
    Emitter<BuildCVState> emit,
  ) {
    final currentState = state;
    if (currentState is CVInProgress) {
      emit(currentState.copyWith(educationData: event.educationData));
    } else {
      emit(CVInProgress(0, educationData: event.educationData));
    }
  }

  void _onUpdateSkillsData(UpdateSkillsData event, Emitter<BuildCVState> emit) {
    final currentState = state;
    if (currentState is CVInProgress) {
      emit(currentState.copyWith(skillsData: event.skillsData));
    } else {
      emit(CVInProgress(0, skillsData: event.skillsData));
    }
  }

  void _onUpdateSummaryData(
    UpdateSummaryData event,
    Emitter<BuildCVState> emit,
  ) {
    final currentState = state;
    if (currentState is CVInProgress) {
      emit(currentState.copyWith(summary: event.summary));
    } else {
      emit(CVInProgress(0, summary: event.summary));
    }
  }

  void _onUpdateAdditionalData(
    UpdateAdditionalData event,
    Emitter<BuildCVState> emit,
  ) {
    final currentState = state;
    if (currentState is CVInProgress) {
      emit(
        currentState.copyWith(
          languages: event.languages,
          certifications: event.certifications,
          awards: event.awards,
          socialMedia: event.socialMedia,
        ),
      );
    } else {
      emit(
        CVInProgress(
          0,
          languages: event.languages,
          certifications: event.certifications,
          awards: event.awards,
          socialMedia: event.socialMedia,
        ),
      );
    }
  }

  Future<void> _onSubmitCV(SubmitCV event, Emitter<BuildCVState> emit) async {
    final currentState = state;
    if (currentState is! CVInProgress) return;

    try {
      emit(CVSubmitting());

      // Comprehensive validation
      final validationError = _validateCVData(currentState);
      if (validationError != null) {
        emit(CVSubmitError(validationError));
        return;
      }

      // Create CV model with collected data
      final cvModel = CVModel(
        userId:
            'temp_user', // This will be set when AuthBloc is properly integrated
        kontak: currentState.contactData!,
        pengalaman: currentState.experienceData ?? [],
        pendidikan: currentState.educationData ?? [],
        keterampilan: currentState.skillsData ?? [],
        bahasa: currentState.languages ?? [],
        sertifikasiDanLisensi: currentState.certifications ?? [],
        penghargaanDanApresiasi: currentState.awards ?? [],
        situsWebDanMediaSosial: currentState.socialMedia ?? [],
        ringkasan: currentState.summary ?? '',
      );

      final result = await _cvService.createCV(cvModel);
      emit(CVSubmitSuccess(result));
    } catch (e) {
      emit(CVSubmitError(e.toString()));
    }
  }

  /// Validate CV data before submission
  String? _validateCVData(CVInProgress state) {
    // Check contact data
    if (state.contactData == null) {
      return 'Informasi kontak diperlukan. Silakan lengkapi halaman kontak.';
    }

    final contact = state.contactData!;
    if (contact.namaAwal.trim().isEmpty) {
      return 'Nama awal diperlukan';
    }
    if (contact.email.trim().isEmpty || !contact.email.contains('@')) {
      return 'Email yang valid diperlukan';
    }

    // Check experience data for completeness
    final experiences = state.experienceData ?? [];
    for (int i = 0; i < experiences.length; i++) {
      final exp = experiences[i];
      if (exp.jabatan.trim().isEmpty) {
        return 'Jabatan diperlukan untuk pengalaman ke-${i + 1}';
      }
      if (exp.perusahaan.trim().isEmpty) {
        return 'Nama perusahaan diperlukan untuk pengalaman ke-${i + 1}';
      }
      if (exp.lokasi.trim().isEmpty) {
        return 'Lokasi diperlukan untuk pengalaman ke-${i + 1}';
      }
      if (exp.tanggalMulai.trim().isEmpty) {
        return 'Tanggal mulai diperlukan untuk pengalaman ke-${i + 1}';
      }
    }

    // Check education data for completeness
    final educations = state.educationData ?? [];
    for (int i = 0; i < educations.length; i++) {
      final edu = educations[i];
      if (edu.namaSekolah.trim().isEmpty) {
        return 'Nama sekolah diperlukan untuk pendidikan ke-${i + 1}';
      }
      if (edu.lokasi.trim().isEmpty) {
        return 'Lokasi sekolah diperlukan untuk pendidikan ke-${i + 1}';
      }
      if (edu.penjurusan.trim().isEmpty) {
        return 'Penjurusan diperlukan untuk pendidikan ke-${i + 1}';
      }
      if (edu.tanggalMulai.trim().isEmpty) {
        return 'Tanggal mulai diperlukan untuk pendidikan ke-${i + 1}';
      }
    }

    // Check skills data
    final skills = state.skillsData ?? [];
    for (int i = 0; i < skills.length; i++) {
      final skill = skills[i];
      if (skill.namaKeterampilan.trim().isEmpty) {
        return 'Nama keterampilan diperlukan untuk skill ke-${i + 1}';
      }
    }

    return null; // No validation errors
  }

  Future<void> _onDownloadCV(
    DownloadCV event,
    Emitter<BuildCVState> emit,
  ) async {
    try {
      emit(CVDownloading());
      final downloadUrl = await _cvService.downloadCV(event.resumeId);
      emit(CVDownloadSuccess(downloadUrl));
    } catch (e) {
      emit(CVDownloadError(e.toString()));
    }
  }

  void _onCompleteCV(CompleteCV event, Emitter<BuildCVState> emit) {
    emit(CVCompleted());
  }

  @override
  Future<void> close() {
    _cvService.dispose();
    return super.close();
  }
}
