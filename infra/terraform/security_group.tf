resource "aws_security_group" "otus-project" {
  name        = "otus-project"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.otus-project.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "otus-project"
  }
}

