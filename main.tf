resource "google_project_service" "cloud_run_enabler" {
  service = "run.googleapis.com"
}

resource "google_project_service" "sql_admin_enabler" {
  service = "sqladmin.googleapis.com"
}

resource "random_id" "random_sa_id" {
  byte_length = 8
}

resource "google_service_account" "app_service_account" {
  account_id = "${var.app_name}-${lower(random_id.random_sa_id.id)}-sa"
}

resource "google_cloud_run_v2_service" "app_run_service" {
  name     = var.app_name
  location = var.region

  template {
    service_account = google_service_account.app_service_account.email
    containers {
      image = var.image

      resources {
        limits = {
          memory = "1Gi"
        }
      }

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = sensitive(env.value)
        }
      }
    }
  }

  depends_on = [
    google_project_service.cloud_run_enabler,
    google_project_service.sql_admin_enabler
  ]
}

resource "google_cloud_run_v2_service_iam_member" "app_run_service_access" {
  project  = google_cloud_run_v2_service.app_run_service.project
  location = google_cloud_run_v2_service.app_run_service.location
  name     = google_cloud_run_v2_service.app_run_service.name
  role     = "roles/run.invoker"
  member   = var.app_invoker_member
}

