resource "aws_iam_instance_profile" "example-profile" {
  name = "example-profile"
  role = aws_iam_role.example-role.name
}
resource "aws_iam_role" "example-role" {
  name = "example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy" "example-AWSElasticBeanstalkWebTier" {
  name        = "example-AWSElasticBeanstalkWebTier"
  path        = "/"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "BucketAccess",
        "Action": [
          "s3:Get*",
          "s3:List*",
          "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::elasticbeanstalk-*",
          "arn:aws:s3:::elasticbeanstalk-*/*"
        ]
      },
      {
        "Sid": "XRayAccess",
        "Action":[
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Sid": "CloudWatchLogsAccess",
        "Action": [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
        ]
      },
      {
        "Sid": "ElasticBeanstalkHealthAccess",
        "Action": [
          "elasticbeanstalk:PutInstanceStatistics"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:elasticbeanstalk:*:*:application/*",
          "arn:aws:elasticbeanstalk:*:*:environment/*"
        ]
      }
    ]
  })
}
resource "aws_iam_policy" "example-AWSElasticBeanstalkWorkerTier" {
  name        = "example-AWSElasticBeanstalkWorkerTier"
  path        = "/"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "MetricsAccess",
        "Action": [
          "cloudwatch:PutMetricData"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Sid": "XRayAccess",
        "Action":[
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Sid": "QueueAccess",
        "Action": [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Sid": "BucketAccess",
        "Action": [
          "s3:Get*",
          "s3:List*",
          "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::elasticbeanstalk-*",
          "arn:aws:s3:::elasticbeanstalk-*/*"
        ]
      },
      {
        "Sid": "DynamoPeriodicTasks",
        "Action": [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:dynamodb:*:*:table/*-stack-AWSEBWorkerCronLeaderRegistry*"
        ]
      },
      {
        "Sid": "CloudWatchLogsAccess",
        "Action": [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
        ]
      },
      {
        "Sid": "ElasticBeanstalkHealthAccess",
        "Action": [
          "elasticbeanstalk:PutInstanceStatistics"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:elasticbeanstalk:*:*:application/*",
          "arn:aws:elasticbeanstalk:*:*:environment/*"
        ]
      }
    ]
  })
}
resource "aws_iam_policy" "example-AWSElasticBeanstalkMulticontainerDocker" {
  name        = "example-AWSElasticBeanstalkMulticontainerDocker"
  path        = "/"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "ECSAccess",
        "Effect": "Allow",
        "Action": [
          "ecs:Poll",
          "ecs:StartTask",
          "ecs:StopTask",
          "ecs:DiscoverPollEndpoint",
          "ecs:StartTelemetrySession",
          "ecs:RegisterContainerInstance",
          "ecs:DeregisterContainerInstance",
          "ecs:DescribeContainerInstances",
          "ecs:Submit*"
        ],
        "Resource": "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "example-iam-attach-webtier" {
  policy_arn = aws_iam_policy.example-AWSElasticBeanstalkWebTier.arn
  role       = aws_iam_role.example-role.name
}
resource "aws_iam_role_policy_attachment" "example-iam-attach-workertier" {
  policy_arn = aws_iam_policy.example-AWSElasticBeanstalkWorkerTier.arn
  role       = aws_iam_role.example-role.name
}
resource "aws_iam_role_policy_attachment" "example-iam-attach-multicontainerdocker" {
  policy_arn = aws_iam_policy.example-AWSElasticBeanstalkMulticontainerDocker.arn
  role       = aws_iam_role.example-role.name
}