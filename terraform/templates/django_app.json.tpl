
[
  {
    "name": "django-app",
    "image": "${docker_image_url_django}",
    "essential": true,
    "cpu": 10,
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 8000,
        "protocol": "tcp"
      }
    ],
    "environment": [
    {
      "name": "S3_ARN_ENV_VARIABLE",
      "value":  "${env_file_arn}"  
    }
    ],
    "mountPoints": [
      {
        "containerPath": "/efs/staticfiles/",
        "sourceVolume": "efs-volume",
        "readOnly": false

      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/django-app",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "django-app-log-stream"
      }
    }
  },
  {
    "name": "nginx",
    "image": "${docker_image_url_nginx}",
    "essential": true,
    "cpu": 10,
    "memory": 128,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "mountPoints": [
      {
        "containerPath": "/efs/staticfiles/",
        "sourceVolume": "efs-volume",
        "readOnly": false

      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/nginx",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "nginx-log-stream"
      }
    }
  }
]



