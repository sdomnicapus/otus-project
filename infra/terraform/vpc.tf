
resource "aws_vpc" "otus-project" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "otus-project",
  }
}

resource "aws_subnet" "otus-project" {
  count = length(data.aws_availability_zones.azs.names)

  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  #cidr_block              = "10.0.${count.index}.0/24"
  cidr_block              = element(var.subnet_cidr, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.otus-project.id

  tags = {
    "Name" = "otus-project",
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
  }
}

resource "aws_subnet" "otus-project-db" {
  count = length(data.aws_availability_zones.azs.names)

  availability_zone = data.aws_availability_zones.azs.names[count.index]
  cidr_block        = element(var.subnet_cidr_db, count.index)
  vpc_id            = aws_vpc.otus-project.id

  tags = {
    "Name"                                      = "otus-project-db"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "otus-project" {
  vpc_id = aws_vpc.otus-project.id

  tags = {
    Name = "otus-project"
  }
}

resource "aws_route_table" "otus-project" {
  vpc_id = aws_vpc.otus-project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.otus-project.id
  }
}

resource "aws_route_table_association" "otus-project" {
  count = length(data.aws_availability_zones.azs.names)

  subnet_id      = aws_subnet.otus-project.*.id[count.index]
  route_table_id = aws_route_table.otus-project.id
}
