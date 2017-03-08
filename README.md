# API Gateway module implementing a Lambda function as a method

This is a Terraform module which creates API Gateway method linked to a Lambda function

Example: 
```
module "ApiGatewayLambda" {
  source = "github.com/jonnyshaw89/api-gateway-lambda-method"
  aws_api_gateway_method_http_method = ""
  aws_api_gateway_rest_api = ""
  aws_api_gateway_resource_id = ""
  aws_api_gateway_resource_path = ""
  aws_lambda_function_arn = ""
  aws_lambda_function_name = ""
  aws_region = ""
  aws_account_id = ""
  environment_name = ""
}
```
