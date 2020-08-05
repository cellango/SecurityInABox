[
    {
        "name": "headcount",
        "image": "389197809423.dkr.ecr.us-east-2.amazonaws.com/cicd/headcount-api:master",
        "cpu": 10,
        "memory": 256,
        "links": [],
        "secrets": ${secrets},


        "portMappings": [
            {
                "containerPort": ${app_port},
                "hostPort": ${host_port},
                "protocol": "tcp"
            }
        ],
      "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
      "awslogs-group": "${awslogs-group}",
      "awslogs-region": "${awslogs-region}"
      }
      },
        "essential": true,
        "entryPoint": [],
        "command": [],
         "environment" : [


               { "name" : "NODE_ENV", "value" : "production" },
               { "name" : "DB_CONNECTION_PORT", "value" : "5432" },
                { "name" : "DB_CONNECTION_USERNAME", "value" : "headcount_admin" },
               { "name" : "DB_CONNECTION_PASSWORD", "value" : "ZYReBTNKvslcuw" },
               { "name" : "DB_CONNECTION_DATABASE", "value" : "headcount_db" },
               { "name" : "DB_CONNECTION_HOST", "value" : "headcount.cluster-coudwnv1akvz.us-east-2.rds.amazonaws.com" },


               { "name" : "DB_CONNECTION_NAME", "value" : "default" },
               { "name" : "DB_CONNECTION_DROP_SCHEMA", "value" : "false" },
               { "name" : "DB_CONNECTION_SYNCHRONIZE", "value" : "false" },
               { "name" : "DB_CONNECTION_LOGGING", "value" : "true" },
               { "name" : "DB_CONNECTION_CACHE", "value" : "false" },
               { "name" : "STAGE", "value" : "production" },
               { "name" : "AUTH0_DOMAIN", "value" : "https://useheadcount.auth0.com/"},
               { "name" : "AUTH0_AUDIENCE", "value" : "https://headcount.com" },

              { "name" : "AUTH0_DB_CONNECTION", "value" : "Username-Password-Authentication" },

              { "name" : "SENDGRID_SENDER_EMAIL", "value" : "no-reply@em9738.useheadcount.com" },
              { "name" : "CONTRACTOR_INVITE_TOKEN_EXP_MIN", "value" : "1440" },
              { "name" : "VERIFYING_INVITE_URL", "value" : "https://api.useheadcount.com/contractor-invite/confirm" },
              { "name" : "REDIRECT_LOGIN_PAGE", "value" : "https://app.useheadcount.com/api/login-invited" },

              { "name" : "ROUTEFUSION_BASE_URL", "value" : "https://sandbox.api.routefusion.co" },

              { "name" : "PLAID_PRODUCTS", "value" : "transactions"},
              { "name" : "PLAID_COUNTRY_CODES", "value" : "US"},
              { "name" : "PLAID_ENV", "value" : "sandbox"},
              { "name" : "BASIC_AUTH_USERNAME", "value" : "admin"},


              { "name" : "AWS_REGION", "value" : "us-east-2" }





          ],


        "mountPoints": [],
        "volumesFrom": []
    }
]