module "api-gateway" {
  source      = "../modules/apigateway_latest/"
  name        = var.app
  enabled     = true

  # Api Gateway Resource
  path_parts                  = ["app"]
  # path_parts   = var.path_parts

  # Api Gateway Method
  http_methods   = ["ANY"]
  #http_methods = var.http_methods
  # request_parameters = {"method.request.header.Content-Type" = false}
  # Api Gateway Integration
  integration_types        = ["HTTP"]
  integration_http_methods = ["ANY"]
  uri                     = ["http://${module.alb.alb_dns_name}"]
  //  uri                     = ["http://${stageVariables.helloworldElb}"]
  #   integration_request_parameters = [{
  #     "integration.request.header.Content-Type" = "'application/xml'"
  #   }, {}]
  #   request_templates = [{
  #     "application/xml" = <<EOF
  # {
  #    "body" : $input.json('$')
  # }
  # EOF
  #   }, {}]
  #  request_templates = [
  #  {"application/xml" = "${file("api_gateway_body_mapping.template")}"},
  #  {"application/json" = "${file("api_gateway_body_mapping.template")}"}
  #  ]

  #        request_templates        = {
  #             "application/xml"              = "${file("api_gateway_body_mapping.template")}",
  #             "application/json"              = "${file("api_gateway_body_mapping.template")}"
  #   }

  # Api Gateway Method Response
  status_codes        = [200]
  response_models     = [{ "application/json" = "Empty" }]
  # response_parameters = [{ "method.response.header.X-Some-Header" = true }, {}]

  # Api Gateway Integration Response
  integration_response_parameters = [{}]
  #response_parameters = { "method.response.header.X-Some-Header" = "integration.response.header.X-Some-Other-Header" }
  #   response_templates = [{
  #     "application/xml" = <<EOF
  # #set($inputRoot = $input.path('$'))
  # <?xml version="1.0" encoding="UTF-8"?>
  # <message>
  #     $inputRoot.body
  # </message>
  # EOF
  #   }, {}]
  # Lambda function name to provide permission to  invoke from API
  //      func_name = ["${data.aws_lambda_function.api_lambda.arn}" , "${data.aws_lambda_function.api_lambda2.arn}"]
  # API access restriction
  enabled_policy  = true
  # Api Gateway Deployment
  deployment_enabled = true
  stage_name         = "dummy"

  # Api Gateway Stage
  stage_enabled = true
  #     api_log_enabled = true
  stage_names   = ["prod"]
  #tags
  tags                  = local.tags
  #apigw_lambda_permission
  apigw_lambda_permission = true
}
