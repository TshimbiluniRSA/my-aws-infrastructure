data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_iam_role" "ec2" {
  name = "${var.name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = {
    Name        = "${var.name}-ec2-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "application"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ec2_application_access" {
  statement {
    sid = "ReadRDSManagedSecret"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]

    resources = [var.rds_secret_arn]
  }

  statement {
    sid       = "GetCVBucketLocation"
    actions   = ["s3:GetBucketLocation"]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid       = "ReadPermanentCV"
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket_arn}/${var.s3_public_cv_key}"]
  }

  statement {
    sid = "ManageTemporaryCVUploads"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = ["${var.s3_bucket_arn}/${var.s3_upload_prefix}/*"]
  }
}

resource "aws_iam_policy" "ec2_application_access" {
  name   = "${var.name}-ec2-application-access"
  policy = data.aws_iam_policy_document.ec2_application_access.json

  tags = {
    Name        = "${var.name}-ec2-application-access"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "application"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_application_access" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_application_access.arn
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.name}-ec2-instance-profile"
  role = aws_iam_role.ec2.name

  tags = {
    Name        = "${var.name}-ec2-instance-profile"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "application"
  }
}

resource "aws_instance" "this" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    application_directory = var.application_directory
  })
  user_data_replace_on_change = false

  associate_public_ip_address = true
  monitoring                  = var.enable_detailed_monitoring

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name        = "${var.name}-ec2-root"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Tier        = "application"
    }
  }

  lifecycle {
    ignore_changes = [user_data]
  }

  tags = {
    Name        = "${var.name}-ec2"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "application"
  }
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name        = "${var.name}-eip"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Tier        = "application"
  }
}

resource "aws_eip_association" "this" {
  allocation_id = aws_eip.this.id
  instance_id   = aws_instance.this.id
}
