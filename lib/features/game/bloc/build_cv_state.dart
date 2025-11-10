part of 'build_cv_bloc.dart';

abstract class BuildCVState {}

class CVInitial extends BuildCVState {}

class CVInProgress extends BuildCVState {
  final int currentStep;
  final CVKontak? contactData;
  final List<CVPengalaman>? experienceData;
  final List<CVPendidikan>? educationData;
  final List<CVKeterampilan>? skillsData;
  final String? summary;
  final List<CVBahasa>? languages;
  final List<CVSertifikasi>? certifications;
  final List<CVPenghargaan>? awards;
  final List<CVMediaSosial>? socialMedia;

  CVInProgress(
    this.currentStep, {
    this.contactData,
    this.experienceData,
    this.educationData,
    this.skillsData,
    this.summary,
    this.languages,
    this.certifications,
    this.awards,
    this.socialMedia,
  });

  CVInProgress copyWith({
    int? currentStep,
    CVKontak? contactData,
    List<CVPengalaman>? experienceData,
    List<CVPendidikan>? educationData,
    List<CVKeterampilan>? skillsData,
    String? summary,
    List<CVBahasa>? languages,
    List<CVSertifikasi>? certifications,
    List<CVPenghargaan>? awards,
    List<CVMediaSosial>? socialMedia,
  }) {
    return CVInProgress(
      currentStep ?? this.currentStep,
      contactData: contactData ?? this.contactData,
      experienceData: experienceData ?? this.experienceData,
      educationData: educationData ?? this.educationData,
      skillsData: skillsData ?? this.skillsData,
      summary: summary ?? this.summary,
      languages: languages ?? this.languages,
      certifications: certifications ?? this.certifications,
      awards: awards ?? this.awards,
      socialMedia: socialMedia ?? this.socialMedia,
    );
  }
}

class CVSubmitting extends BuildCVState {}

class CVSubmitSuccess extends BuildCVState {
  final CVModel cvModel;

  CVSubmitSuccess(this.cvModel);
}

class CVSubmitError extends BuildCVState {
  final String error;

  CVSubmitError(this.error);
}

class CVDownloading extends BuildCVState {}

class CVDownloadSuccess extends BuildCVState {
  final String downloadUrl;

  CVDownloadSuccess(this.downloadUrl);
}

class CVDownloadError extends BuildCVState {
  final String error;

  CVDownloadError(this.error);
}

class CVCompleted extends BuildCVState {}
