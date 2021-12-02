resource "aws_elastic_beanstalk_application" "example-app" {
  name        = "example-app"
}
resource "aws_elastic_beanstalk_application_version" "example-version" {
  name        = local.timestamp
  application = aws_elastic_beanstalk_application.example-app.name
  bucket      = aws_s3_bucket.prod-example-bucket.id
  key         = aws_s3_bucket_object.prod-example-bucket-object.id
}
resource "aws_elastic_beanstalk_environment" "prod-example-env" {
  name                = "prod-example-env"
  application         = aws_elastic_beanstalk_application.example-app.name
  version_label       = aws_elastic_beanstalk_application_version.example-version.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.7 running Python 3.8"
  tier                = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = module.example-vpc.vpc_id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = module.example-vpc.public_subnets[0]
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.nano"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.example-profile.name
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "FLASK_APP"
    value     = var.FLASK_APP
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "APP_SETTINGS"
    value     = var.APP_SETTINGS
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SQLALCHEMY_DATABASE_URI"
    value     = "mysql://${var.dbUser}:${var.dbPass}@${aws_db_instance.prod-example-db.address}/${var.dbName}"
  }
  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "EC2KeyName"
  #   value     = "example"
  # }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "ListenerProtocol"
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "SSLCertificateId"
    value     = aws_acm_certificate.example-cert.arn
  }
  setting {
    namespace = "aws:elb:listener:443"
    name      = "InstancePort"
    value     = "80"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "7"
  }
}