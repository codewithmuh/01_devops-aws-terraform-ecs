resource "aws_ecs_cluster" "production" {
  name = "${var.ecs_cluster_name}-cluster"
}

data "template_file" "app" {
  template = file("templates/django_app.json.tpl")

  vars = {
    docker_image_url_django = var.docker_image_url_django
    docker_image_url_nginx  = var.docker_image_url_nginx
    env_file_arn            = var.env_file_arn
    region                  = var.region
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "django-app"
  depends_on               = [aws_db_instance.production]
  network_mode             = "awsvpc" # Required for Fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn
  task_role_arn            = aws_iam_role.ecs-task-execution-role.arn
  container_definitions    = data.template_file.app.rendered
  volume {
    name = "efs-volume"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.efs.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2049
      authorization_config {
        access_point_id = aws_efs_access_point.app_access_point.id
        iam             = "ENABLED"
      }
    }
  }
}

resource "aws_ecs_service" "production" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = var.app_count
  network_configuration {
    subnets          = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
    security_groups  = [aws_security_group.ecs-fargate.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "nginx"
    container_port   = 80
  }
}



resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_access_point" "app_access_point" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    uid = 1000
    gid = 1000
  }
  root_directory {
    path = "/efs"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = length([aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id])
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id][count.index]
  security_groups = [aws_security_group.efs_sg.id]
}
