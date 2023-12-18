
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-id-3564356"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "example_versioning" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "example_layer" {
  bucket = "my-bucket-id-3564356-layer"

  tags = {
    Name        = "My layer bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "example_layer_versioning" {
  bucket = aws_s3_bucket.example_layer.id
  versioning_configuration {
    status = "Enabled"
  }
}


# locals {
#   pipfile_lock = "${path.module}/../Pipfile.lock"
#   src_sha1sum = "${path.module}/../.build/src-app.sha1sum"
# }

# data "external" "build_setup" {
#   program = ["/bin/bash -c ls"]
#   # program = ["bash", "-c build-setup.sh"]

# }

# output "build_script_output" {
#   value = data.external.build_setup.result
# }

# data "external" "build_src" {
#   depends_on = [ data.external.build_setup ]
#   program = ["bash -c ./build-src.sh"]

# }

# output "build_src_output" {
#   value = data.external.build_src.result

# }

# data "external" "build_layer" {
#   depends_on = [ data.external.build_setup ]
#   program = ["bash -c ./build-layer.sh"]

# }

# output "build_layer_output" {
#   value = data.external.build_layer.result

# }

# resource "null_resource" "build_setup" {

#   provisioner "local-exec" {
#     command = "bash -c ./build-setup.sh"
#   }

# }

# resource "null_resource" "lambda_src" {

#   depends_on = [ null_resource.build_setup ]

#   provisioner "local-exec" {
#     command = "bash -c ./build-src.sh"
#   }

# }

# resource "null_resource" "lambda_layer" {

#   depends_on = [ null_resource.build_setup ]

#   triggers = {
#     pipfile_lock = filesha1(local.pipfile_lock)
#   }

#   provisioner "local-exec" {
#     command = "bash -c ./build-layer.sh"
#   }
# }

# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "../app"
#   output_path = "../.build/lambda_function.zip"
# }

# data "archive_file" "lambda_layer_zip" {

#   # depends_on = [ data.external.build_layer ]

#   type        = "zip"
#   source_dir  = "../.build/lambda_layer"
#   output_path = "../.build/lambda_layer.zip"
# }

# resource "aws_lambda_layer_version" "lambda_layer" {
#   # depends_on = [ data.external.build_layer ]

#   layer_name = "nathan-test-layer"
#   filename   = data.archive_file.lambda_layer_zip.output_path
#   source_code_hash = sha256(filebase64(local.pipfile_lock))
#   compatible_runtimes = ["python3.11"]

# }

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_s3_bucket" "pushed" {
  bucket = "my-bucket-id-35643566"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_lambda_function" "nathan_test_function" {
  depends_on = [ aws_s3_bucket.pushed ]

  function_name = "nathan-test-service"
  description   = "Test Lambda Service"
  handler       = "main.handler"
  runtime       = "python3.11"
  publish       = true

  # s3_bucket = aws_s3_bucket.example.id
  # s3_key    = "lambda_function.zip"

  # layers = [
  #   aws_lambda_layer_version.lambda_layer.arn
  # ]

  role = aws_iam_role.iam_for_lambda.arn

  filename = "../dist/nathan-test-service.zip"
  source_code_hash = filebase64sha256("../dist/nathan-test-service.zip")

  environment {
    
    variables = {
      ZETIFI_LOCATION = aws_s3_bucket.pushed.bucket_domain_name
    }
  }

}

output "source_hash" {
  value = filebase64sha256("../dist/nathan-test-service.zip")
  
}





# module "lambda_function" {
#   source = "terraform-aws-modules/lambda/aws"

#   depends_on = [ aws_s3_bucket.example ]

#   function_name = "nathan-test-service"
#   description   = "Test Lambda Service"
#   handler       = "main.handler"
#   runtime       = "python3.11"
#   publish       = true

#   source_path = "../app/main.py"
#   source_code_hash="filebase64sha256(${path.module}/../app/main.py)"

#   # layers = [
#   #   module.lambda_layer_s3.lambda_layer_arn
#   # ]

#   store_on_s3 = true
#   s3_bucket   = "my-bucket-id-3564356"

#   environment_variables = {
#     Serverless = "Terraform"
#   }

# }

# module "lambda_layer_s3" {
#   source = "terraform-aws-modules/lambda/aws"

#   depends_on = [ aws_s3_bucket.example-layer ]

#   create_layer = true

#   # artifacts_dir = "${path.module}/../build"

#   layer_name          = "nathan-test-layer"
#   description         = "Test Lambda Layer"
#   compatible_runtimes = ["python3.11"]
#   source_path = {
#     path = "${path.module}/.."
#     commands = [
#       "export $(cat .env | xargs)",
#       "pipenv requirements > requirements.txt",
#       "cd `mktemp -d`",
#       "mkdir python",
#       # https://github.com/pyca/cryptography/issues/6390
#       # https://github.com/pyca/cryptography/issues/6391
#       "pip install --target=python/. --platform manylinux2014_x86_64 --python 3.11 --only-binary=:all: --upgrade -r ${abspath(path.module)}/../requirements.txt",
#       ":zip ./*",
#     ]

#   }

#   store_on_s3 = true
#   s3_bucket   = "my-bucket-id-3564356-layer"
# }

# resource "aws_lambda_layer_version" "lambda_layer_version" {
#   layer_name = module.lambda_layer.layer_name
#   source_code_hash = filebase64("${module.lambda_layer.source_path}/Pipfile.lock")
#   compatible_runtimes = module.lambda_layer.compatible_runtimes
# }

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my_api_example"
  description = "This is an example"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"

}
resource "aws_api_gateway_integration" "api_integration" {
  depends_on              = [aws_lambda_function.nathan_test_function]
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_rest_api.my_api.root_resource_id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.nathan_test_function.invoke_arn
}



resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.api_integration]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_stage" "dev" {
  depends_on    = [aws_api_gateway_deployment.api_deployment]
  stage_name    = "dev"
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
}

resource "aws_lambda_permission" "api_gateway_invoke_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nathan_test_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_stage.dev.execution_arn}/*"
}


output "api_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}