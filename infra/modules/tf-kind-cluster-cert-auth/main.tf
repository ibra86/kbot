resource "kind_cluster" "this" {
  name           = "kind-cluster"
  wait_for_ready = true
}
