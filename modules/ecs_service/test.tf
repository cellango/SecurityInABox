//

//        "image": "alexgaynor/test-http",

//[
//{
//"name": "nginx",
//"image": "nginx:1.13-alpine",
//"essential": true,
//"portMappings": [
//{
//"containerPort": 80,
//"hostPort": 80,
//"protocol": "tcp"
//}
//],
//"logConfiguration": {
//"logDriver": "awslogs",
//"options": {
//"awslogs-group": "hello_world",
//"awslogs-region": "us-east-1"
//}
//},
//"memory": 50,
//"cpu": 100
//}
//]





//[
//  {
//    "name": "hello_world",
//    "image": "hello-world",
//    "cpu": 0,
//    "memory": 128,
//  "portMappings": [
//  {
//  "containerPort": 80
//  }
//  ],
//    "logConfiguration": {
//      "logDriver": "awslogs",
//      "options": {
//        "awslogs-region": "eu-west-1",
//        "awslogs-group": "hello_world",
//        "awslogs-stream-prefix": "complete-ecs"
//      }
//    }
//  }
//]
//
//
//[
//{
//"name": "nginx",
//"image": "nginx:1.13-alpine",
//"essential": true,
//"portMappings": [
//{
//"containerPort": 80
//}
//],
//"logConfiguration": {
//"logDriver": "awslogs",
//"options": {
//"awslogs-group": "app-dev-nginx",
//"awslogs-region": "us-east-1",
//"awslogs-stream-prefix": "complete-ecs"
//}
//},
//"memory": 128,
//"cpu": 100
//}
//]