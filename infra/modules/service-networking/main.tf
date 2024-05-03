
resource "google_service_networking_connection" "main" {
  network                 = var.network_name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges =  var.global_address_names
}