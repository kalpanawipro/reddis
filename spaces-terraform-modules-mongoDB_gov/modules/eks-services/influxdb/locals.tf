locals {
        ads = data.aws_availability_zones.ads.names
        # region = "us-gov-west-1"
        # environment = "dev"
        # instance_type = "m6g.large"
        # key_name = "sandbox-govcloud"
        # iam_instance_profile = "ec2-ssm-role"
        # countVal = "1"   
        # security_groups = ["sg-0f965b48a2b92b92b", "sg-0a0704efb66b73d7a"]
        # listener_arn = "arn:aws-us-gov:elasticloadbalancing:us-gov-west-1:031661760457:listener/app/infra-int-InfluxProd-lb-govcloud/aece008ac989b7a7/d39ad85860299479"
        # bucket_name = "eks_metrics"
}