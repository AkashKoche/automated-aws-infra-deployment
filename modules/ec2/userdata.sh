#!/bin/bash

apt-get update -y
apt-get upgrade -y

curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

mkdir -p /opt/demo-app
cd /opt/demo-app

cat > package.json << EOF
{
  "name": "demo-app",
  "version": "1.0.0",
  "description": "FAANG+ Interview Demo Application",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

cat > server.js << EOF
const express = require('express');
const app = express();
const PORT = ${app_port};

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>FAANG+ Demo App</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          text-align: center;
          padding: 50px;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
        }
        .container {
          background: rgba(255, 255, 255, 0.1);
          padding: 30px;
          border-radius: 10px;
          backdrop-filter: blur(10px);
          max-width: 800px;
          margin: 0 auto;
        }
        h1 {
          font-size: 2.5em;
          margin-bottom: 20px;
        }
        .info-box {
          background: rgba(255, 255, 255, 0.2);
          padding: 20px;
          border-radius: 8px;
          margin: 20px 0;
          text-align: left;
        }
        .tech-stack {
          display: flex;
          justify-content: center;
          gap: 20px;
          margin: 30px 0;
        }
        .tech-item {
          background: rgba(255, 255, 255, 0.3);
          padding: 15px;
          border-radius: 8px;
          min-width: 120px;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>🚀 Automated AWS Infrastructure Deployment</h1>
        <p>FAANG+ Interview Project Demo</p>

        <div class="info-box">
          <h2>🏗️ Infrastructure Details</h2>
          <p><strong>Environment:</strong> ${environment}</p>
          <p><strong>Instance ID:</strong> \${process.env.HOSTNAME || 'Unknown'}</p>
          <p><strong>Region:</strong> AWS us-east-1</p>
          <p><strong>Deployed via:</strong> Terraform + Jenkins Pipeline</p>
        </div>

        <div class="tech-stack">
          <div class="tech-item">
            <h3>AWS</h3>
            <p>VPC • EC2 • ALB</p>
          </div>
          <div class="tech-item">
            <h3>Terraform</h3>
            <p>IaC • Modules</p>
          </div>
          <div class="tech-item">
            <h3>Jenkins</h3>
            <p>CI/CD • Automation</p>
          </div>
        </div>

        <div class="info-box">
          <h2>📊 Performance Metrics</h2>
          <p>• 80% reduction in manual setup time</p>
          <p>• Auto-scaling enabled</p>
          <p>• Multi-AZ deployment</p>
          <p>• Automated health checks</p>
        </div>

        <p><a href="/health" style="color: #fff; text-decoration: underline;">Check Health Status</a></p>
      </div>
    </body>
    </html>
  `);
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'demo-app',
    environment: '${environment}',
    uptime: process.uptime()
  });
});

app.get('/api/info', (req, res) => {
  res.json({
    project: 'Automated AWS Infrastructure Deployment',
    purpose: 'FAANG+ Interview Demonstration',
    features: [
      'Terraform Infrastructure as Code',
      'Jenkins CI/CD Pipeline',
      'AWS VPC with Public/Private Subnets',
      'Auto Scaling Group',
      'Application Load Balancer',
      'Health Monitoring'
    ],
    technologies: ['AWS', 'Terraform', 'Jenkins', 'Node.js', 'Express']
  });
});

app.listen(PORT, () => {
  console.log(\`Demo app running on port \${PORT}\`);
  console.log(\`Environment: ${environment}\`);
});
EOF

npm install

cat > /etc/systemd/system/demo-app.service << EOF
[Unit]
Description=FAANG+ Demo Application
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/demo-app
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable demo-app
systemctl start demo-app
