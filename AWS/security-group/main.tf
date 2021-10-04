resource "aws_security_group" "sg_tcp" {
    count       = "${var.tcp_ports == true ? 0 : 1}"
    name        = format("%s-sg-tcp", var.project_name)
    description = format("Security Group for TCP ports of %s", var.project_name)
    vpc_id      = var.vpc-id

    dynamic "ingress" {
        for_each = var.tcp_prots
        content {
            cidr_blocks = ingress.value
            from_port   = ingress.key
            to_port     = ingress.key
            protocol    = "tcp"
        }
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {

        Name          = format("%s-sg-tcp", var.project_name)

        Squad         = var.config_sg["SQUAD"]
        Application   = var.config_sg["APPLICATION"]
        Environment   = var.config_sg["ENV"]
        Terraform     = "True"
    }
}

resource "aws_security_group" "sg_udp" {
    count       = "${var.udp_ports == true ? 0 : 1}"
    name        = format("%s-sg-udp", var.project_name)
    description = format("Security Group for UDP ports of %s", var.project_name)
    vpc_id      = var.vpc-id

    dynamic "ingress" {
        for_each = var.udp_prots
        content {
            cidr_blocks = ingress.value
            from_port   = ingress.key
            to_port     = ingress.key
            protocol    = "udp"
        }
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {

        Name          = format("%s-sg-udp", var.project_name)

        Squad         = var.config_sg["SQUAD"]
        Application   = var.config_sg["APPLICATION"]
        Environment   = var.config_sg["ENV"]
        Terraform     = "True"
    }
}
