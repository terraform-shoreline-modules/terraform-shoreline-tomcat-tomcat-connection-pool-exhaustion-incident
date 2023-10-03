resource "shoreline_notebook" "tomcat_connection_pool_exhaustion_incident" {
  name       = "tomcat_connection_pool_exhaustion_incident"
  data       = file("${path.module}/data/tomcat_connection_pool_exhaustion_incident.json")
  depends_on = [shoreline_action.invoke_tomcat_config_update]
}

resource "shoreline_file" "tomcat_config_update" {
  name             = "tomcat_config_update"
  input_file       = "${path.module}/data/tomcat_config_update.sh"
  md5              = filemd5("${path.module}/data/tomcat_config_update.sh")
  description      = "Increase the connection pool size to accommodate more incoming connections."
  destination_path = "/agent/scripts/tomcat_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tomcat_config_update" {
  name        = "invoke_tomcat_config_update"
  description = "Increase the connection pool size to accommodate more incoming connections."
  command     = "`chmod +x /agent/scripts/tomcat_config_update.sh && /agent/scripts/tomcat_config_update.sh`"
  params      = ["PATH_TO_TOMCAT_CONFIG_FILE","PATH_TO_TOMCAT","NEW_CONNECTION_POOL_SIZE"]
  file_deps   = ["tomcat_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_config_update]
}

