resource "aws_security_group" "web_sg" {
  name        = "devsecops-web-sg-${var.environment}"
  description = "Security group for web facing load balancers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from everywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-web-sg-${var.environment}"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "devsecops-app-sg-${var.environment}"
  description = "Security group for private application instances"
  vpc_id      = aws_vpc.main.id

  # Notice: No SSH (port 22) allowed. Access via SSM.
  
  ingress {
    description     = "Allow traffic from web SG"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Allow intra-subnet communication (for kubernetes/swarm nodes)
  ingress {
    description = "Allow internal traffic within private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic (for updates/pulling images)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-app-sg-${var.environment}"
  }
}
