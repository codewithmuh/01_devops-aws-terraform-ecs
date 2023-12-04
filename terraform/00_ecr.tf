resource "aws_ecr_repository" "django_ecr_repository" {
  name = var.django_ecr_repository_name
  # Additional repository configuration if needed
}

resource "aws_ecr_repository" "nginx_ecr_repository" {
  name = var.nginx_ecr_repository_name
  # Additional repository configuration if needed
}

