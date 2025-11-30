#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export NEEDRESTART_SUSPEND=1

sudo apt update -y
sudo apt upgrade -y


sudo apt install -y curl build-essential libssl-dev mysql-client


curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs


cd /home/ubuntu

cat > /tmp/create-strapi.sh << 'SCRIPT_END'
#!/bin/bash
set -e
cd /home/ubuntu


export STRAPI_DISABLE_UPDATE_NOTIFICATION=true
export STRAPI_TELEMETRY_DISABLED=true
export STRAPI_DISABLE_REMOTE_DATA_TRANSFER=true
export NODE_ENV=development

echo "N" | npx create-strapi-app@latest strapiCMS \
  --quickstart \
  --no-run \
  --skip-cloud

SCRIPT_END

chmod +x /tmp/create-strapi.sh
sudo -u ubuntu /tmp/create-strapi.sh

cd /home/ubuntu/strapiCMS
sudo -u ubuntu npm install mysql2 @strapi/provider-upload-aws-s3

sudo -u ubuntu tee config/database.js > /dev/null << 'EOF'
module.exports = ({ env }) => ({
  connection: {
    client: 'mysql2',
    connection: {
      host: env('DATABASE_HOST'),
      port: env.int('DATABASE_PORT', 3306),
      database: env('DATABASE_NAME'),
      user: env('DATABASE_USERNAME'),
      password: env('DATABASE_PASSWORD'),
    },
    useNullAsDefault: true,
  },
});
EOF


sudo -u ubuntu tee config/plugins.ts > /dev/null << 'EOF'
export default ({ env }) => ({
  upload: {
    config: {
      provider: 'aws-s3',
      providerOptions: {
        s3Options: {
          credentials: {
            accessKeyId: env('AWS_ACCESS_KEY_ID'),
            secretAccessKey: env('AWS_ACCESS_SECRET'),
          },
          region: env('AWS_REGION'),
        },
        params: {
          Bucket: env('AWS_BUCKET'),
        },
      },
    },
  },
});

EOF


sudo -u ubuntu tee .env > /dev/null << EOF
HOST=0.0.0.0
PORT=1337

APP_KEYS=$(openssl rand -base64 32),$(openssl rand -base64 32)
API_TOKEN_SALT=$(openssl rand -base64 32)
ADMIN_JWT_SECRET=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)

DATABASE_CLIENT=mysql
DATABASE_HOST=${db_host}
DATABASE_PORT=${db_port}
DATABASE_NAME=${db_name}
DATABASE_USERNAME=${db_username}
DATABASE_PASSWORD=${db_password}


AWS_REGION=${aws_region}
AWS_BUCKET=${s3_bucket}
AWS_ACCESS_KEY_ID=${aws_access_key_id}
AWS_ACCESS_SECRET=${aws_secret_access_key}
EOF


sudo -u ubuntu npm run build


sudo npm install -g pm2


cd /home/ubuntu/strapiCMS
sudo -u ubuntu pm2 start npm --name "strapi" -- start
sudo -u ubuntu pm2 save

sleep 20
