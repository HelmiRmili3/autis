class UpdateReportParams {
  final String reportId;
  final String patientId;
  final String reportDetails;
  final String? attachmentUrl;
  UpdateReportParams(
    this.reportId,
    this.patientId,
    this.reportDetails,
    this.attachmentUrl,
  );
}
