resource "kubernetes_config_map" "mariadb_config" {
  metadata {
    name      = "mariadb-config"
    namespace = "analytics"
  }

  data = {
    "custom.cnf" = <<-EOF
      [mysqld]
      max_allowed_packet=64M
      local_infile=1
      secure_file_priv=""
    EOF
  }
}