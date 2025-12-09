resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id  = aws_vpc.main.id

  tags = {
    Name         = "${var.environment}-igm"
    Environment  = var.environment
  }
}

resource "aws_subnet" "public" {
  count                 = length(var.public_subnet_cidrs)
  vpc_id                = aws_vpc.main.id
  cidr_block            = element(var.public_subnet_cidrs, count.index)
  availability_zone     = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                = "${var.environment}-public-subnet-${count.index + 1}"
    Environment         = var.environment
    Type                = "Public"
  }
}

resource "aws_subnet" "private" {
  count               = length(var.private_subnet_cidrs)
  vpc_id              = aws_vpc.main.id
  cidr_block          = var.private_subnet_cidrs[count.index]
  availability_zone   = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name                = "${var.environment}-public-rt"
    Environment         = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.environment}-var-gateway-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index % length(aws_nat_gateway.main)].id
  }

  tags = {
    Name = "${var.environment}-private-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count           = length(aws_subnet.private)
  subnet_id       = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private[count.index].id
}

data "aws_availability_zones" "available" {
  state = "available"
}
