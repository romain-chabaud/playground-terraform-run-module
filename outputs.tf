output "app_url" {
  value = google_cloud_run_v2_service.app_run_service.uri
}