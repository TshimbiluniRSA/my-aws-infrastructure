data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  count = var.ami_id == null ? 1 : 0
  name  = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != null ? var.ami_id : data.aws_ssm_parameter.amazon_linux_2023_ami[0].value
}

resource "aws_iam_role" "this" {
  name = "${var.name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.name}-ec2-role"
    Tier = "application"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "secrets" {
  statement {
    sid = "ReadWaaziRuntimeSecrets"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = var.secret_arns
  }
}

resource "aws_iam_policy" "secrets" {
  name   = "${var.name}-secret-read"
  policy = data.aws_iam_policy_document.secrets.json

  tags = {
    Name = "${var.name}-secret-read"
    Tier = "application"
  }
}

resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.secrets.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-ec2-instance-profile"
  role = aws_iam_role.this.name

  tags = {
    Name = "${var.name}-ec2-instance-profile"
    Tier = "application"
  }
}

resource "aws_instance" "this" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = true
  monitoring                  = var.enable_detailed_monitoring

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    application_directory = var.application_directory
  })
  user_data_replace_on_change = false

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = var.http_put_response_hop_limit
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.name}-ec2-root"
      Tier = "application"
    }
  }

  lifecycle {
    ignore_changes = [user_data]
  }

  tags = {
    Name = "${var.name}-ec2"
    Tier = "application"
  }
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-eip"
    Tier = "application"
  }
}

resource "aws_eip_association" "this" {
  allocation_id = aws_eip.this.id
  instance_id   = aws_instance.this.id
}
