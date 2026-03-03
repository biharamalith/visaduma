// ============================================================
// FILE: lib/features/jobs/domain/entities/job_entity.dart
// ============================================================
class JobEntity {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String jobType; // full-time | part-time | contract | freelance
  final String category;
  final double? salaryMin;
  final double? salaryMax;
  final String description;
  final List<String> requirements;
  final bool isActive;
  final DateTime postedAt;

  const JobEntity({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.jobType,
    required this.category,
    this.salaryMin,
    this.salaryMax,
    required this.description,
    required this.requirements,
    required this.isActive,
    required this.postedAt,
  });
}
