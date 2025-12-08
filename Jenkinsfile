pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ENVIRONMENT = 'dev'
        TF_WORKSPACE = 'dev'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }
        
        stage('Setup') {
            steps {
                sh '''
                    echo "Initializing Terraform..."
                    terraform version
                    aws --version
                '''
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh '''
                    cd environments/${ENVIRONMENT}
                    terraform init
                '''
            }
        }
        
        stage('Terraform Plan') {
            steps {
                sh '''
                    cd environments/${ENVIRONMENT}
                    terraform plan \
                        -var-file="terraform.tfvars" \
                        -out=tfplan.out
                '''
            }
        }
        
        stage('Manual Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        message: 'Apply Terraform changes?',
                        ok: 'Deploy Infrastructure'
                    )
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                sh '''
                    cd environments/${ENVIRONMENT}
                    terraform apply -auto-approve tfplan.out
                '''
            }
        }
        
        stage('Infrastructure Validation') {
            steps {
                script {
                    def alb_dns = sh(
                        script: 'cd environments/${ENVIRONMENT} && terraform output -raw alb_dns_name',
                        returnStdout: true
                    ).trim()
                    
                    echo "ALB DNS Name: ${alb_dns}"
                    
                    // Test the deployed application
                    sh """
                        echo "Testing application endpoint..."
                        curl -s -o /dev/null -w "%{http_code}" http://${alb_dns}/health || true
                        sleep 10
                        curl -f http://${alb_dns}/ || echo "Application test failed"
                    """
                }
            }
        }
        
        stage('Generate Report') {
            steps {
                sh '''
                    echo "=== Infrastructure Deployment Report ==="
                    echo "Environment: ${ENVIRONMENT}"
                    echo "Timestamp: $(date)"
                    echo "Terraform Version: $(terraform version)"
                    echo "AWS Region: ${AWS_REGION}"
                    
                    cd environments/${ENVIRONMENT}
                    terraform output
                '''
                
                script {
                    def outputs = sh(
                        script: 'cd environments/${ENVIRONMENT} && terraform output -json',
                        returnStdout: true
                    )
                    
                    writeJSON file: 'deployment-outputs.json', json: outputs
                    archiveArtifacts artifacts: 'deployment-outputs.json'
                }
            }
        }
    }
    
    post {
        always {
            echo "Pipeline completed"
            cleanWs()
        }
        success {
            echo "Infrastructure deployment successful!"
            emailext (
                subject: "✅ Terraform Deployment Successful - ${ENV['ENVIRONMENT']}",
                body: """
                Infrastructure deployment completed successfully!
                
                Environment: ${ENV['ENVIRONMENT']}
                Timestamp: ${new Date()}
                
                Access URLs:
                - Demo Application: http://$(cd environments/${ENV['ENVIRONMENT']} && terraform output -raw alb_dns_name)
                - Jenkins: http://$(cd environments/${ENV['ENVIRONMENT']} && terraform output -raw jenkins_public_ip):8080
                
                Deployment outputs saved to deployment-outputs.json
                """,
                to: 'user@example.com'
            )
        }
        failure {
            echo "Infrastructure deployment failed!"
            emailext (
                subject: "❌ Terraform Deployment Failed - ${ENV['ENVIRONMENT']}",
                body: """
                Infrastructure deployment failed!
                
                Environment: ${ENV['ENVIRONMENT']}
                Timestamp: ${new Date()}
                
                Check Jenkins logs for details.
                """,
                to: 'user@example.com'
            )
        }
    }
}
