output "vm_id" {
  value       = google_compute_instance.container_vm.id
  description = "Compute Engine instance ID"
}

output "vm_internal_ip" {
  value       = google_compute_instance.container_vm.network_interface.0.network_ip
  description = "Internal IP of the Compute Engine instance"
}

output "vm_external_ip" {
  value       = google_compute_instance.container_vm.network_interface.0.access_config.0.nat_ip
  description = "External IP of the Compute Engine instance"
}

output "ar_id" {
  value       = google_artifact_registry_repository.ar_repo.id
  description = "Artifact Registry ID"
}

output "cloudbuild_sa_name" {
  value       = google_service_account.cloudbuild_sa.name
  description = "Name of the Service Account for Cloud Build"
}

output "cloudbuild_trigger_id" {
  value       = google_cloudbuild_trigger.build_trigger.id
  description = "Cloud Build trigger ID"
}
