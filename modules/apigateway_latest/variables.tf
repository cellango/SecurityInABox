
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "policy" {
  default     = ""
  description = "Policy (e.g. only nc4 IP can access the API)."
}


variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}


# Api Gateway
# Description : Terraform Api Gateway module variables.
variable "enabled" {
  type        = bool
  default     = false
  description = "Whether to create rest api."
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the REST API "
}

variable "binary_media_types" {
  type        = list
  default     = ["UTF-8-encoded"]
  description = "The list of binary media types supported by the RestApi. By default, the RestApi supports only UTF-8-encoded text payloads."
}

variable "minimum_compression_size" {
  type        = number
  default     = -1
  description = "Minimum response size to compress for the REST API. Integer between -1 and 10485760 (10MB). Setting a value greater than -1 will enable compression, -1 disables compression (default)."
}

variable "api_key_source" {
  type        = string
  default     = "HEADER"
  description = "The source of the API key for requests. Valid values are HEADER (default) and AUTHORIZER."
}

variable "types" {
  type        = list
  default     = ["REGIONAL"]
  description = "Whether to create rest api."
}

variable "path_parts" {
  type        = list
  default     = []
  description = "The last path segment of this API resource."
}

variable "stage_enabled" {
  type        = bool
  # default     = false
  description = "Whether to create stage for rest api."
}

variable "deployment_enabled" {
  type        = bool
  default     = false
  description = "Whether to deploy rest api."
}

variable "api_log_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable log for rest api."
}

variable "stage_name" {
  type        = string
  default     = ""
  description = "The name of the stage. If the specified stage already exists, it will be updated to point to the new deployment. If the stage does not exist, a new one will be created and point to this deployment."
}

variable "deploy_description" {
  type        = string
  default     = ""
  description = "The description of the deployment."
}

variable "stage_description" {
  type        = string
  default     = ""
  description = "The description of the stage."
}


variable "http_methods" {
  type        = list
  default     = []
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)."
}

variable "authorizations" {
  type        = list
  default     = []
  description = "The type of authorization used for the method (NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS)."
}

variable "authorizer_ids" {
  type        = list
  default     = []
  description = "The authorizer id to be used when the authorization is CUSTOM or COGNITO_USER_POOLS."
}

variable "authorization_scopes" {
  type        = list
  default     = []
  description = "The authorization scopes used when the authorization is COGNITO_USER_POOLS."
}

variable "api_key_requireds" {
  type        = list
  default     = []
  description = "Specify if the method requires an API key."
}

variable "request_models" {
  type        = list
  default     = []
  description = "A map of the API models used for the request's content type where key is the content type (e.g. application/json) and value is either Error, Empty (built-in models) or aws_api_gateway_model's name."
}

variable "request_validator_ids" {
  type        = list
  default     = []
  description = "The ID of a aws_api_gateway_request_validator."
}

# variable "request_parameters" {
#   type        = list
#   default     = []
#   description = "A map of request query string parameters and headers that should be passed to the integration. For example: request_parameters = {\"method.request.header.X-Some-Header\" = true \"method.request.querystring.some-query-param\" = true} would define that the header X-Some-Header and the query string some-query-param must be provided in the request."
# }
variable "request_parameters" {
  type    = map(string)
  default = {}
}

variable "integration_http_methods" {
  type        = list
  default     = []
  description = "The integration HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONs, ANY, PATCH) specifying how API Gateway will interact with the back end. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY. Not all methods are compatible with all AWS integrations. e.g. Lambda function can only be invoked via POST."
}

variable "integration_types" {
  type        = list
  default     = []
  description = "The integration input's type. Valid values are HTTP (for HTTP backends), MOCK (not calling any real backend), AWS (for AWS services), AWS_PROXY (for Lambda proxy integration) and HTTP_PROXY (for HTTP proxy integration). An HTTP or HTTP_PROXY integration with a connection_type of VPC_LINK is referred to as a private integration and uses a VpcLink to connect API Gateway to a network load balancer of a VPC."
}

variable "connection_types" {
  type        = list
  default     = []
  description = "The integration input's connectionType. Valid values are INTERNET (default for connections through the public routable internet), and VPC_LINK (for private connections between API Gateway and a network load balancer in a VPC)."
}

variable "connection_ids" {
  type        = list
  default     = []
  description = "The id of the VpcLink used for the integration. Required if connection_type is VPC_LINK."
}

variable "uri" {
  type        = list
  default     = []
  description = "The input's URI. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY. For HTTP integrations, the URI must be a fully formed, encoded HTTP(S) URL according to the RFC-3986 specification . For AWS integrations, the URI should be of the form arn:aws:apigateway:{region}:{subdomain.service|service}:{path|action}/{service_api}. region, subdomain and service are used to determine the right endpoint. e.g. arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:012345678901:function:my-func/invocations."
}
variable "func_name" {
  type        = list
  default     = []
  description = "Lambda function name."
}
variable "credentials" {
  type        = list
  default     = []
  description = "The credentials required for the integration. For AWS integrations, 2 options are available. To specify an IAM Role for Amazon API Gateway to assume, use the role's ARN. To require that the caller's identity be passed through from the request, specify the string arn:aws:iam::*:user/*."
}

variable "integration_request_parameters" {
  type        = list
  default     = []
  description = "A map of request query string parameters and headers that should be passed to the backend responder. For example: request_parameters = { \"integration.request.header.X-Some-Other-Header\" = \"method.request.header.X-Some-Header\" }."
}

# variable "request_templates" {
#   type        = list
#   default     = []
#   description = "A map of the integration's request templates."
# }
variable "request_templates" {
  type    = map(string)
  default = {}
}
variable "passthrough_behaviors" {
  type        = list
  default     = ["WHEN_NO_TEMPLATES"]
  description = "The integration passthrough behavior (WHEN_NO_MATCH, WHEN_NO_TEMPLATES, NEVER). Required if request_templates is used."
}

variable "cache_key_parameters" {
  type        = list
  default     = []
  description = "A list of cache key parameters for the integration."
}

variable "cache_namespaces" {
  type        = list
  default     = []
  description = "The integration's cache namespace."
}

variable "content_handlings" {
  type        = list
  default     = []
  description = "Specifies how to handle request payload content type conversions. Supported values are CONVERT_TO_BINARY and CONVERT_TO_TEXT. If this property is not defined, the request payload will be passed through from the method request to integration request without modification, provided that the passthroughBehaviors is configured to support payload pass-through."
}

variable "timeout_milliseconds" {
  type        = list
  default     = []
  description = "Custom timeout between 50 and 29,000 milliseconds. The default value is 29,000 milliseconds."
}

variable "status_codes" {
  type        = list
  default     = []
  description = "The HTTP status code."
}

variable "response_models" {
  type        = list
  default     = []
  description = "A map of the API models used for the response's content type."
}

variable "response_parameters" {
  type        = list
  default     = []
  description = "A map of response parameters that can be sent to the caller. For example: response_parameters = { \"method.response.header.X-Some-Header\" = true } would define that the header X-Some-Header can be provided on the response."
}

variable "integration_response_parameters" {
  type        = list
  default     = []
  description = "A map of response parameters that can be read from the backend response. For example: response_parameters = { \"method.response.header.X-Some-Header\" = \"integration.response.header.X-Some-Other-Header\" }."
}

variable "response_templates" {
  type        = list
  default     = []
  description = "A map specifying the templates used to transform the integration response body."
}

variable "response_content_handlings" {
  type        = list
  default     = []
  description = "Specifies how to handle request payload content type conversions. Supported values are CONVERT_TO_BINARY and CONVERT_TO_TEXT. If this property is not defined, the response payload will be passed through from the integration response to the method response without modification."
}

variable "stage_names" {
  type        = list
  default     = []
  description = "The name of the stage."
}

variable "cache_cluster_enableds" {
  type        = list
  default     = []
  description = "Specifies whether a cache cluster is enabled for the stage."
}

variable "cache_cluster_sizes" {
  type        = list
  default     = []
  description = "The size of the cache cluster for the stage, if enabled. Allowed values include 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118 and 237."
}

variable "client_certificate_ids" {
  type        = list
  default     = []
  description = "The identifier of a client certificate for the stage"
}

variable "descriptions" {
  type        = list
  default     = []
  description = "The description of the stage."
}

variable "documentation_versions" {
  type        = list
  default     = []
  description = "The version of the associated API documentation."
}

variable "stage_variables" {
  type        = list
  default     = []
  description = "A map that defines the stage variables."
}

variable "xray_tracing_enabled" {
  type        = list
  default     = []
  description = "A mapping of tags to assign to the resource."
}

variable "destination_arns" {
  type        = list
  default     = []
  description = "ARN of the log group to send the logs to. Automatically removes trailing :* if present."
}

variable "formats" {
  type        = list
  default     = []
  description = "The formatting and values recorded in the logs."
}

variable "cert_enabled" {
  type        = bool
  default     = false
  description = "Whether to create client certificate."
}

variable "cert_description" {
  type        = string
  default     = ""
  description = "The description of the client certificate."
}

variable "authorizer_count" {
  type        = number
  default     = 0
  description = "Number of count to create Authorizers for api."
}


variable "response_types" {
  type        = list
  default     = []
  description = "The response type of the associated GatewayResponse."
}

variable "gateway_status_codes" {
  type        = list
  default     = []
  description = "The HTTP status code of the Gateway Response."
}

variable "gateway_response_templates" {
  type        = list
  default     = []
  description = "A map specifying the parameters (paths, query strings and headers) of the Gateway Response."
}

variable "gateway_response_parameters" {
  type        = list
  default     = []
  description = "A map specifying the templates used to transform the response body."
}

variable "model_count" {
  type        = number
  default     = 0
  description = "Number of count to create Model for api."
}

variable "model_names" {
  type        = list
  default     = []
  description = "The name of the model."
}

variable "model_descriptions" {
  type        = list
  default     = []
  description = "The description of the model."
}

variable "content_types" {
  type        = list
  default     = []
  description = "The content type of the model."
}

variable "schemas" {
  type        = list
  default     = []
  description = "The schema of the model in a JSON form."
}

variable "vpc_link_count" {
  type        = number
  default     = 0
  description = "Number of count to create VPC Link for api."
}

variable "vpc_link_names" {
  type        = list
  default     = []
  description = "The name used to label and identify the VPC link."
}

variable "vpc_link_descriptions" {
  type        = list
  default     = []
  description = "The description of the VPC link."
}

variable "target_arns" {
  type        = list
  default     = []
  description = "The list of network load balancer arns in the VPC targeted by the VPC link. Currently AWS only supports 1 target."
}

variable "key_count" {
  type        = number
  default     = 0
  description = "Number of count to create key for api gateway."
}

variable "key_names" {
  type        = list
  default     = []
  description = "The name of the API key."
}

variable "key_descriptions" {
  type        = list
  default     = []
  description = "The API key description. Defaults to \"Managed by Terraform\"."
}

variable "enableds" {
  type        = list
  default     = []
  description = "Specifies whether the API key can be used by callers. Defaults to true."
}

variable "values" {
  type        = list
  default     = []
  description = "The value of the API key. If not specified, it will be automatically generated by AWS on creation."
}

variable "apigw_lambda_permission" {
  type        = bool
  default     = false
  description = "Whether to API invoke Lambda permission."
}

variable "enabled_policy" {
  type        = bool
  default     = false
  description = "API access restiction"
}
