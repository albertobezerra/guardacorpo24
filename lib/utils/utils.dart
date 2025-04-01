String formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  return '${date.day}/${date.month}/${date.year}';
}
