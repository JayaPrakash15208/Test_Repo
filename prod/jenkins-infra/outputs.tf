output "jenkins_server_public_ip" {
  description = "Public IP of the Jenkins server"
  value       = aws_instance.jenkins_server.public_ip
}

output "main_server_public_ip" {
  description = "Public IP of the main server"
  value       = aws_instance.main_server.public_ip
}

output "jenkins_url" {
  description = "URL to access the Jenkins UI"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

output "flask_app_url" {
  description = "URL to access the deployed Flask app"
  value       = "http://${aws_instance.main_server.public_ip}:5000"
}
