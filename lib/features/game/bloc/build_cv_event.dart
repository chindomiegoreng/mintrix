part of 'build_cv_bloc.dart';

abstract class BuildCVEvent {}

class UpdateCVStep extends BuildCVEvent {
  final int step;

  UpdateCVStep(this.step);
}

class UpdateContactData extends BuildCVEvent {
  final CVKontak contactData;

  UpdateContactData(this.contactData);
}

class UpdateExperienceData extends BuildCVEvent {
  final List<CVPengalaman> experienceData;

  UpdateExperienceData(this.experienceData);
}

class UpdateEducationData extends BuildCVEvent {
  final List<CVPendidikan> educationData;

  UpdateEducationData(this.educationData);
}

class UpdateSkillsData extends BuildCVEvent {
  final List<CVKeterampilan> skillsData;

  UpdateSkillsData(this.skillsData);
}

class UpdateSummaryData extends BuildCVEvent {
  final String summary;

  UpdateSummaryData(this.summary);
}

class UpdateAdditionalData extends BuildCVEvent {
  final List<CVBahasa> languages;
  final List<CVSertifikasi> certifications;
  final List<CVPenghargaan> awards;
  final List<CVMediaSosial> socialMedia;

  UpdateAdditionalData({
    required this.languages,
    required this.certifications,
    required this.awards,
    required this.socialMedia,
  });
}

class SubmitCV extends BuildCVEvent {}

class DownloadCV extends BuildCVEvent {
  final String resumeId;

  DownloadCV(this.resumeId);
}

class CompleteCV extends BuildCVEvent {}
