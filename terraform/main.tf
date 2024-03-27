locals {
  # function_id         = "${element(concat(aws_lambda_function.local_zipfile.*.id, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.id, list("")), 0)}"
  # function_arn        = "${element(concat(aws_lambda_function.local_zipfile.*.arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.arn, list("")), 0)}"
  # function_invoke_arn = "${element(concat(aws_lambda_function.local_zipfile.*.invoke_arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.invoke_arn, list("")), 0)}"
  prefix_with_domain = "${var.name_prefix}-${var.api_domain}"
}

resource "aws_lambda_function" "main_lamda" {
  count = "${var.function_s3_bucket == "" ? 1 : 0}"

  filename         = "${var.function_zipfile}"
  source_code_hash = "${var.function_s3_bucket == "" ? "${base64sha256(file("${var.function_zipfile}"))}" : ""}"

  description   = "${var.comment_prefix}${var.api_domain}"
  function_name = "${local.prefix_with_domain}"
  handler       = "${var.function_handler}"
  runtime       = "${var.function_runtime}"
  timeout       = "${var.function_timeout}"
  memory_size   = "${var.memory_size}"
  role          = "${aws_iam_role.iam_for_main_lambda.arn}"
  tags          = "${var.tags}"

  # environment {
  #   variables = "${var.function_env_vars}"
  # }
}

resource "aws_iam_role" "iam_for_main_lambda" {
  name = "lamda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "policy_for_main_lambda" {
  name        = "lamda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["arn:aws:logs:*:*:*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lamda_role_policy_attachment" {
  policy_arn = aws_iam_policy.policy_for_main_lambda.arn
  role = aws_iam_role.iam_for_main_lambda.name
}

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.main_lamda.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}


# locals {

#   postgres_identifier    = POSTGRES_IDENTIFIER
#   postgres_name          = POSTGRES_DB_NAME
#   postgres_user_name     = YOUR_USERNAME
#   postgres_user_password = YOUR_PASSWORD
#   postgres_instance_name = POSTGRES_DB_INSTANCE_NAME
#   postgres_db_password   = POSTGRES_DB_PASSWORD
#   postgres_port          = POSTGRES_PORT

# }

# provider "postgresql" {
#   host            = aws_db_instance.postgres.address
#   port            = local.postgres_port
#   database        = local.postgres_database_name
#   username        = local.postgres_username
#   password        = local.postgres_password
#   sslmode         = "require"
#   connect_timeout = 15
#   superuser       = false
# }

# // POSTGRES
# resource "aws_security_group" "security_group_name" {
#   name = "security_group_name"

#   ingress {
#     from_port   = local.postgres_port
#     to_port     = local.postgres_port
#     protocol    = "tcp"
#     description = "PostgreSQL"
#     cidr_blocks = ["0.0.0.0/0"] // >
#   }

#   ingress {
#     from_port        = local.postgres_port
#     to_port          = local.postgres_port
#     protocol         = "tcp"
#     description      = "PostgreSQL"
#     ipv6_cidr_blocks = ["::/0"] // >
#   }
# }

# resource "aws_db_instance" "instance_name" {
#   allocated_storage      = 20
#   storage_type           = "gp2"
#   engine                 = "postgres"
#   engine_version         = "12.2"
#   instance_class         = "db.t2.micro"
#   identifier             = local.postgres_identifier
#   name                   = local.postgres_instance_name
#   username               = local.postgres_user_name
#   password               = local.postgres_db_password
#   publicly_accessible    = true
#   parameter_group_name   = "default.postgres12"
#   vpc_security_group_ids = [aws_security_group.security_group_name.id]
#   skip_final_snapshot    = true
  
# }

# resource "postgresql_role" "user_name" {
#   name                = local.postgres_user_name
#   login               = true
#   password            = local.postgres_user_password
#   encrypted_password  = true
#   create_database     = true
#   create_role         = true
#   skip_reassign_owned = true
# }