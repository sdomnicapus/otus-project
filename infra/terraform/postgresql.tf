resource "aws_db_subnet_group" "otus-project" {
  name       = "otus-project"
  subnet_ids = aws_subnet.otus-project-db.*.id


  tags = {
    Name = "otus-project DB subnet group"
  }
}

resource "aws_security_group" "otus-project-db-sg" {
  name        = "otus-project-db-sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.otus-project.id

  ingress {
    from_port   = 0
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}


resource "aws_db_instance" "hubdb" {
  allocated_storage         = 20
  identifier                = "${var.cluster_name}-hubdb"
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "11.5"
  instance_class            = "db.t2.micro"
  name                      = "hubdb"
  username                  = "otus-project"
  password                  = "0620e4453ae9478c99afcb8d83058e13"
  db_subnet_group_name      = aws_db_subnet_group.otus-project.id
  backup_retention_period   = 5
  final_snapshot_identifier = "${var.cluster_name}-hubdb-final-snapshot"
  skip_final_snapshot       = true
  vpc_security_group_ids = [aws_security_group.otus-project-db-sg.id]

  tags = {
    Name = "hubdb"
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}

resource "aws_db_instance" "logdb" {
  allocated_storage         = 20
  identifier                = "${var.cluster_name}-logdb"
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "12.3"
  instance_class            = "db.t2.micro"
  name                      = "logdb"
  username                  = "otus-project"
  password                  = "0620e4453ae9478c99afcb8d83058e13"
  db_subnet_group_name      = aws_db_subnet_group.otus-project.id
  backup_retention_period   = 5
  final_snapshot_identifier = "${var.cluster_name}-logdb-final-snapshot"
  skip_final_snapshot       = true

  tags = {
    Name = "logdb"
  }

    #lifecycle {
  #  prevent_destroy = true
  #}
}