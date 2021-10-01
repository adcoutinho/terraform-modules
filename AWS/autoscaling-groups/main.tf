locals {
    backing_store_ami_mapping = {
        "hvm:ebs-ssd:amazon2"       = "ami-038f1ca1bd58a5790"
        "hvm:ebs-standard:amazon2"  = "ami-075e0f44b579bb724"
    }    

    subnets = {
        public-us-east-1a   = ""
        public-us-east-1c   = ""
        private-us-east-1a  = ""
        private-us-east-1c  = ""
    }
}

data "aws_security_groups" "this" {
    filter {
        name    = "group-name"
        values  = var.security_groups
    }
}

data "aws_ami" "this" {
    most_recent = true
    filter {
        name    = "image-id"
        values  = [local.backing_store_ami_mapping[var.backing_store]]
    }
}

module "user-data" {
    source      = "../aws-user-data"

    instance_domain_name    = var.instance_domain_name
}

resource "aws_launch_template" "this" {
    name_prefix     = "${var.project}-"

    image_id        = data.aws_ami.this.id

    # gets overriden by the instance_types in ASG
    instance_type   = var.instance_type

    iam_instance_profile {
        name        = var.iam_role
    }

    block_device_mappings {
        device_name     = "/dev/xvda"

        ebs {
            volume_size = 10
            volume_type = "gp2"
        }
    }

    network_interfaces {
        associate_public_ip_address = true
        delete_on_termination       = true
        security_groups     = data.aws_security_groups.this.ids
    }

    user_data   = module.user_data.encoded_user_Date

    key_name    = var.key_name

    lifecycle {
        create_before_destroy   = true
    }
}

resource "aws_autoscaling_group" "this" {
    name        = var.name

    vpc_zone_identifier = [for az in var.availability_zones: local.subnets["${var.subnet_type}-${az}"]]

    min_size            = var.min_size
    max_size            = var.max_size
    desired_capacity    = var.desired_capacity == 0 ? var.min_size : var.desired_capacity

    health_check_type   = "EC2"

    tag {
        key                 = "created_by"
        value               = "autoscaling"
        propagate_at_launch = true
    }

    dynamic "tag" {
        for_each    = var.tags

        content {
            key                 = tag.key
            value               = tag.value
            propagate_at_launch = true
        }
    }

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupPendingInstances",
        "GroupStandbyInstances",
        "GroupTerminatingInstances",
        "GroupTotalInstances",
    ]

    wait_for_capacity_timeout = 0

    termination_policies = [
        "Default",
    ]

    instance_refresh {
        strategy = "Rolling"
        preferences {
            min_healthy_percentage = 100
        }
    }

    launch_template {
        id      = aws_launch_template.this.id
        version = "$Latest"
    }

    lifecycle {
        prevent_destroy     = true
    }
}

