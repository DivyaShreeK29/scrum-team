/* groovylint-disable LineLength */
pipeline {
  agent any
  environment {
  }
  stages {
    stage('Build') {
      steps {
        sh("echo ${env.RELEASE_TYPE}")
        sh('sh ./build.sh')
      }
    }
    stage('Test') {
      steps {
        sh('echo test')
      }
    }
    stage('Deploy to S3') {
      steps {
        sh "aws configure set region ${env.AWS_DEFAULT_REGION}"
        sh "aws configure set aws_access_key_id ${env.AWS_ACCESS_KEY_ID}"
        sh "aws configure set aws_secret_access_key ${env.AWS_SECRET_ACCESS_KEY}"
        sh("aws s3 cp build/web s3://${env.AWS_S3BUCKET_NAME}/ --recursive");
        sh("echo Deployment completed successfully.")
     }
    }
  }
}