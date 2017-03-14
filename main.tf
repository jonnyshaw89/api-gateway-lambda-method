// Api Gateway
resource "aws_api_gateway_method" "method" {
  rest_api_id = "${var.aws_api_gateway_rest_api}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "${var.aws_api_gateway_method_http_method}"
  authorization = "${var.aws_api_gateway_method_authorization}"
}

resource "aws_api_gateway_integration" "integration" {
  depends_on = ["aws_api_gateway_method.method"]
  rest_api_id = "${var.aws_api_gateway_rest_api}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "method-response" {
  depends_on = ["aws_api_gateway_method.method"]
  rest_api_id = "${var.aws_api_gateway_rest_api}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  status_code = "200"
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = "*" }
}

resource "aws_api_gateway_integration_response" "method-Integration-Response" {
  depends_on = ["aws_api_gateway_method.method", "aws_api_gateway_method_response.method-response", "aws_api_gateway_integration.integration"]
  rest_api_id = "${var.aws_api_gateway_rest_api}"
  resource_id = "${var.aws_api_gateway_resource_id}"
  http_method = "POST"
  status_code = "${aws_api_gateway_method_response.method-response.status_code}"
  content_handling = "CONVERT_TO_TEXT"
}

// Lambda
resource "aws_lambda_permission" "lambda-permission" {
  function_name = "${var.aws_lambda_function_name}"
  statement_id = "Allow${var.aws_lambda_function_name}ExecutionFromApiGateway"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${var.aws_api_gateway_rest_api}/*/${aws_api_gateway_integration.integration.integration_http_method}${var.aws_api_gateway_resource_path}"
}