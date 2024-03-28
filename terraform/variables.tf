variable "api_domain" {
  description = "Domain on which the Lambda will be made available (e.g. `\"api.example.com\"`)"
  default="athmare"
}

variable "name_prefix" {
  description = "Name prefix to use for objects that need to be created (only lowercase alphanumeric characters and hyphens allowed, for S3 bucket name compatibility)"
  default     = "lambda-api"
}

variable "comment_prefix" {
  description = "This will be included in comments for resources that are created"
  default     = "lamda api"
}

variable "function_zipfile" {
  description = "Path to a ZIP file that will be installed as the Lambda function (e.g. `\"my-api.zip\"`)"
  default = "../lamdas/get-news-items.zip"
}

variable "function_zipfile2" {
  description = "Path to a ZIP file that will be installed as the Lambda function (e.g. `\"my-api.zip\"`)"
  default = "../lamdas/create-news-item.zip"
}

variable "function_handler" {
  description = "Instructs Lambda on which function to invoke within the ZIP file"
  default     = "index.handler"
}

variable "function_timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = 128
}

variable "function_runtime" {
  description = "Golang version for this runtime"
  default     = "go1.x"
}

# variable "function_env_vars" {
#   description = "Which env vars (if any) to invoke the Lambda with"
#   type        = map

#   default = {
#     # This effectively useless, but an empty map can't be used in the "aws_lambda_function" resource
#     # -> this is 100% safe to override with your own env, should you need one
#     aws_lambda_api1 = "get-news-items"
#     aws_lambda_api2 = "create-news-item"
#   }
# }

variable "stage_name" {
  description = "Name of the single stage created for the API on API Gateway" # we're not using the deployment features of API Gateway, so a single static stage is fine
  default     = "default"
}

variable "lambda_logging_enabled" {
  description = "When true, writes any console output to the Lambda function's CloudWatch group"
  default     = false
}

variable "api_gateway_logging_level" {
  description = "Either `\"OFF\"`, `\"INFO\"` or `\"ERROR\"`; note that this requires having a CloudWatch log role ARN globally in API Gateway Settings"
  default     = "OFF"
}

variable "api_gateway_cloudwatch_metrics" {
  description = "When true, sends metrics to CloudWatch"
  default     = false
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = map
  default     = {}
}

variable "throttling_rate_limit" {
  description = "How many sustained requests per second should the API process at most; see https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html"
  default     = 10000
}

variable "throttling_burst_limit" {
  description = "How many burst requests should the API process at most; see https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html"
  default     = 5000
}

#DB config
variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}

# variable "db_password" {
#   description = "RDS root user password"
#   sensitive   = true
# }

variable "db_username" {
    description = "RDS root user name"
    default     = "athmare-root-user"
}

variable "db_instance" {
  description = "RDS DB instance type"
  default     = "db.t4g.micro"
}