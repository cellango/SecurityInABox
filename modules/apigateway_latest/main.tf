locals {
  stage_name = "v1"
}

resource "aws_api_gateway_rest_api" "default" {
  count = var.enabled ? 1 : 0

  name                     = var.name
  description              = var.description
  binary_media_types       = var.binary_media_types
  minimum_compression_size = var.minimum_compression_size
  api_key_source           = var.api_key_source
  #policy                   = var.policy
  policy                   = var.enabled_policy ? var.policy : ""
  # policy = "${data.template_file.init.rendered}"
  endpoint_configuration {
    types = var.types
  }

}


# data "template_file" "init" {
#   count = var.enabled_policy ? 1 : 0
#   template = "${file("${path.root}/policy/policy.tf")}"
#   vars = {
#     current_region      = "${data.aws_region.current.name}"
#     current_aws_account = "${data.aws_caller_identity.current.account_id}"
#     current_api_id              = aws_api_gateway_rest_api.default.*.id[0]
#   }
# }
# Api Gateway Resource

resource "aws_api_gateway_resource" "default" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0

  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  parent_id   = aws_api_gateway_rest_api.default.*.root_resource_id[0]
  path_part   = element(var.path_parts, count.index)
}

#  Api Gateway Model
resource "aws_api_gateway_model" "default" {
  count        = var.model_count > 0 ? var.model_count : 0
  rest_api_id  = aws_api_gateway_rest_api.default.*.id[0]
  name         = element(var.model_names, count.index)
  description  = length(var.model_descriptions) > 0 ? element(var.model_descriptions, count.index) : ""
  content_type = element(var.content_types, count.index)

  schema = <<EOF
{"type":"object"}
EOF
}

# Api Gateway Method
resource "aws_api_gateway_method" "default" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0
  #count = length(var.path_parts) > 0 ? 1 : 0

  rest_api_id          = aws_api_gateway_rest_api.default.*.id[0]
  resource_id          = aws_api_gateway_resource.default.*.id[count.index]
  http_method          = element(var.http_methods, count.index)
  authorization        = length(var.authorizations) > 0 ? element(var.authorizations, count.index) : "NONE"
  authorizer_id        = length(var.authorizer_ids) > 0 ? element(var.authorizer_ids, count.index) : null
  authorization_scopes = length(var.authorization_scopes) > 0 ? element(var.authorization_scopes, count.index) : null
  api_key_required     = length(var.api_key_requireds) > 0 ? element(var.api_key_requireds, count.index) : null
  request_models       = length(var.request_models) > 0 ? element(var.request_models, count.index) : { "application/xml" = "Empty" }
  request_validator_id = length(var.request_validator_ids) > 0 ? element(var.request_validator_ids, count.index) : null
  request_parameters   = var.request_parameters
  #request_parameters   = length(var.request_parameters) > 0 ? element(var.request_parameters, count.index) : {}
}

# Api Gateway Integration
resource "aws_api_gateway_integration" "default" {
  count                   = length(aws_api_gateway_method.default.*.id)
  # count                   = length(var.request_templates)
  rest_api_id             = aws_api_gateway_rest_api.default.*.id[0]
  resource_id             = aws_api_gateway_resource.default.*.id[count.index]
  http_method             = aws_api_gateway_method.default.*.http_method[count.index]
  integration_http_method = length(var.integration_http_methods) > 0 ? element(var.integration_http_methods, count.index) : "POST"
  type                    = length(var.integration_types) > 0 ? element(var.integration_types, count.index) : "AWS_PROXY"
  connection_type         = length(var.connection_types) > 0 ? element(var.connection_types, count.index) : "INTERNET"
  connection_id           = length(var.connection_ids) > 0 ? element(var.connection_ids, count.index) : ""
  uri                     = length(var.uri) > 0 ? element(var.uri, count.index) : ""
  credentials             = length(var.credentials) > 0 ? element(var.credentials, count.index) : ""
  request_parameters      = length(var.integration_request_parameters) > 0 ? element(var.integration_request_parameters, count.index) : {}
  request_templates       = var.request_templates
  passthrough_behavior    = length(var.passthrough_behaviors) > 0 ? element(var.passthrough_behaviors, count.index) : null
  cache_key_parameters    = length(var.cache_key_parameters) > 0 ? element(var.cache_key_parameters, count.index) : []
  cache_namespace         = length(var.cache_namespaces) > 0 ? element(var.cache_namespaces, count.index) : ""
  content_handling        = length(var.content_handlings) > 0 ? element(var.content_handlings, count.index) : null
  timeout_milliseconds    = length(var.timeout_milliseconds) > 0 ? element(var.timeout_milliseconds, count.index) : 29000
  depends_on              = [aws_api_gateway_method.default]
}

# Api Gateway Method Response
resource "aws_api_gateway_method_response" "default" {
  count               = length(aws_api_gateway_method.default.*.id)
  rest_api_id         = aws_api_gateway_rest_api.default.*.id[0]
  resource_id         = aws_api_gateway_resource.default.*.id[count.index]
  http_method         = aws_api_gateway_method.default.*.http_method[count.index]
  status_code         = element(var.status_codes, count.index)
  response_models     = length(var.response_models) > 0 ? element(var.response_models, count.index) : {}
  response_parameters = length(var.response_parameters) > 0 ? element(var.response_parameters, count.index) : {}
}

# Api Gateway Integration Response
resource "aws_api_gateway_integration_response" "default" {
  count       = length(aws_api_gateway_integration.default.*.id)
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  resource_id = aws_api_gateway_resource.default.*.id[count.index]
  http_method = aws_api_gateway_method.default.*.http_method[count.index]
  status_code = aws_api_gateway_method_response.default.*.status_code[count.index]

  response_parameters = length(var.integration_response_parameters) > 0 ? element(var.integration_response_parameters, count.index) : {}
  response_templates  = length(var.response_templates) > 0 ? element(var.response_templates, count.index) : {}
  content_handling    = length(var.response_content_handlings) > 0 ? element(var.response_content_handlings, count.index) : null
}



#Api Gateway Deployment

resource "aws_api_gateway_deployment" "default" {
  count = var.deployment_enabled ? 1 : 0

  rest_api_id       = aws_api_gateway_rest_api.default.*.id[0]
  stage_name        = var.stage_name
  #stage_name        = element(var.stage_names, count.index)
  description       = var.description
  stage_description = var.stage_description
  # stage_description = "Deployed at ${timestamp()}" 

  # variables         = var.variables
  variables = {
    deployed_at = "${timestamp()}"
  }
  depends_on        = [aws_api_gateway_method.default, aws_api_gateway_integration.default
                        ] #, aws_api_gateway_account.settings
  lifecycle {
    create_before_destroy = true
  }
}

# Api Gateway Client Certificate

resource "aws_api_gateway_client_certificate" "default" {
  count       = var.cert_enabled ? 1 : 0
  description = var.cert_description
}

# Api Gateway Stage

resource "aws_api_gateway_stage" "default" {
  count = var.deployment_enabled && var.stage_enabled && length(var.stage_names) > 0 ? length(var.stage_names) : 0

  rest_api_id           = aws_api_gateway_rest_api.default.*.id[0]
  deployment_id         = aws_api_gateway_deployment.default.*.id[0]
  stage_name            = element(var.stage_names, count.index)
  cache_cluster_enabled = length(var.cache_cluster_enableds) > 0 ? element(var.cache_cluster_enableds, count.index) : false
  cache_cluster_size    = length(var.cache_cluster_sizes) > 0 ? element(var.cache_cluster_sizes, count.index) : null
  client_certificate_id = length(var.client_certificate_ids) > 0 ? element(var.client_certificate_ids, count.index) : (var.cert_enabled ? aws_api_gateway_client_certificate.default.*.id[0] : "")
  description           = length(var.descriptions) > 0 ? element(var.descriptions, count.index) : ""
  documentation_version = length(var.documentation_versions) > 0 ? element(var.documentation_versions, count.index) : null
  variables             = length(var.stage_variables) > 0 ? element(var.stage_variables, count.index) : {}
  xray_tracing_enabled  = length(var.xray_tracing_enabled) > 0 ? element(var.xray_tracing_enabled, count.index) : false
  tags                  = var.tags
  # provisioner "local-exec" {
  #   command = "aws --region us-east-1 --profile dev apigateway update-stage --rest-api-id ${aws_api_gateway_rest_api.default.*.id[0]} --stage-name 'dev' --patch-operations op=replace,path=/*/*/logging/dataTrace,value=true op=replace,path=/*/*/logging/loglevel,value=INFO op=replace,path=/*/*/metrics/enabled,value=true"
  # }

}

# Module      : Api Gateway Stage
# Description : Terraform module to create Api Gateway Stage resource on AWS with logs
#               enabled.
resource "aws_api_gateway_stage" "with_log" {
  count = var.deployment_enabled && var.stage_enabled && var.api_log_enabled && length(var.stage_names) > 0 ? length(var.stage_names) : 0

  rest_api_id           = aws_api_gateway_rest_api.default.*.id[0]
  deployment_id         = aws_api_gateway_deployment.default.*.id[0]
  stage_name            = element(var.stage_names, count.index)
  cache_cluster_enabled = length(var.cache_cluster_enableds) > 0 ? element(var.cache_cluster_enableds, count.index) : false
  cache_cluster_size    = length(var.cache_cluster_sizes) > 0 ? element(var.cache_cluster_sizes, count.index) : null
  client_certificate_id = length(var.client_certificate_ids) > 0 ? element(var.client_certificate_ids, count.index) : (var.cert_enabled ? aws_api_gateway_client_certificate.default.*.id[0] : "")
  description           = length(var.descriptions) > 0 ? element(var.descriptions, count.index) : ""
  documentation_version = length(var.documentation_versions) > 0 ? element(var.documentation_versions, count.index) : null
  variables             = length(var.stage_variables) > 0 ? element(var.stage_variables, count.index) : {}
  xray_tracing_enabled  = length(var.xray_tracing_enabled) > 0 ? element(var.xray_tracing_enabled, count.index) : false
  access_log_settings {
    destination_arn = element(var.destination_arns, count.index)
    format          = element(var.formats, count.index)
  }
}




# Lambda

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


# resource "aws_lambda_permission" "apigw_lambda" {
#   count = var.apigw_lambda_permission ? 1 : 0
#   statement_id  = "AllowExecutionFromAPIGateway-${var.name}"
#   action        = "lambda:InvokeFunction"
#   function_name = element(var.func_name, count.index)
#   principal     = "apigateway.amazonaws.com"
#   source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.default.*.id[0]}/*/*/*"
# }

resource "aws_lambda_permission" "apigw_lambda" {
  count = length(var.func_name) > 0 ? length(var.func_name) : 0
  statement_id  = "AllowExecutionFromAPIGateway-${var.name}"
  action        = "lambda:InvokeFunction"
  function_name   = element(var.func_name, count.index)
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.default.*.id[0]}/*/*/*"
}



resource "aws_api_gateway_method_settings" "s" {
  depends_on = [aws_api_gateway_integration.default]
  count       =  true ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  stage_name  = aws_api_gateway_stage.default.*.stage_name[0]
  #stage_name  = element(var.stage_names, count.index)
  method_path = "*/*"
  #method_path = "*/*"
#${aws_api_gateway_method.default.*.http_method[count.index]}
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    data_trace_enabled = true
  }
}


resource "aws_api_gateway_account" "settings" {
  depends_on = [aws_iam_role.cloudwatch]
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}


resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_role_${var.name}"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

