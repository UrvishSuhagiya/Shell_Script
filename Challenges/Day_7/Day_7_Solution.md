# EC2 Setup and Deployment Guide

This guide provides step-by-step instructions to set up and deploy a simple web application on AWS EC2 instances using Docker.

## Links to Steps

1. [Step 1: Connect to Your EC2 Instances](#step-1-connect-to-your-ec2-instances)
2. [Step 2: Set Up Passwordless SSH Authentication (Optional)](#step-2-set-up-passwordless-ssh-authentication-optional)
3. [Step 3: Remote Command Execution](#step-3-remote-command-execution)
4. [Step 4: File Transfer Between Servers](#step-4-file-transfer-between-servers)
5. [Step 5: Setting Up Docker on DE2 and DE3](#step-5-setting-up-docker-on-de2-and-de3)
6. [Step 6: Containerizing and Deploying a Web Application](#step-6-containerizing-and-deploying-a-web-application)
7. [Step 7: Transfer Docker Image to DE2 and DE3](#step-7-transfer-docker-image-to-de2-and-de3)
8. [Step 8: Load and Deploy the Web Application on DE2 and DE3](#step-8-load-and-deploy-the-web-application-on-de2-and-de3)
9. [Step 9: Validate Successful Web Application Deployment](#step-9-validate-successful-web-application-deployment)

## Prerequisites

- AWS account with EC2 instances (ex. DE1, DE2, DE3) set up.
- .pem key file for SSH access.
- Basic knowledge of command-line operations.

## Step 1: Connect to Your EC2 Instances

### Connect to DE1

1. Open your terminal.
2. Enter the following command to connect to DE1:

    ```bash
    ssh -i path/to/your_key.pem ec2-user@<DE1_public_ip>
    ```

### Connect to DE2

1. Open a new terminal window (keep the DE1 terminal open).
2. Enter the following command to connect to DE2:

    ```bash
    ssh -i path/to/your_key.pem ec2-user@<DE2_public_ip>
    ```

### Connect to DE3

1. Open another new terminal window (keep the DE1 and DE2 terminals open).
2. Enter the following command to connect to DE3:

    ```bash
    ssh -i path/to/your_key.pem ec2-user@<DE3_public_ip>
    ```

## Step 2: Set Up Passwordless SSH Authentication (Optional)

This step allows you to connect to the servers without entering the key every time.

### On DE1

1. SSH into DE1 if not already connected.
2. Generate SSH key pair:

    ```bash
    ssh-keygen -t rsa -b 2048
    ```

3. Press Enter to accept the default file location and skip entering a passphrase.
4. Copy the public key to DE2 and DE3:

    - For DE2:

        ```bash
        ssh-copy-id -i ~/.ssh/id_rsa.pub ec2-user@<DE2_public_ip>
        ```

    - For DE3:

        ```bash
        ssh-copy-id -i ~/.ssh/id_rsa.pub ec2-user@<DE3_public_ip>
        ```

## Step 3: Remote Command Execution

You can execute commands on DE2 and DE3 from DE1 using SSH.

### On DE1

1. Create a script to execute commands:

    ```bash
    vim remote_execute.sh
    ```

2. Add the following lines to the script:

    ```bash
    #!/bin/bash
    echo "Executing command on DE2"
    ssh -i path/to/your_key.pem ec2-user@<DE2_public_ip> "echo 'Hello from DE2!'"

    echo "Executing command on DE3"
    ssh -i path/to/your_key.pem ec2-user@<DE3_public_ip> "echo 'Hello from DE3!'"
    ```

3. Make the script executable:

    ```bash
    chmod +x remote_execute.sh
    ```

4. Run the script:

    ```bash
    ./remote_execute.sh
    ```

## Step 4: File Transfer Between Servers

You can transfer files from DE1 to DE2 and DE3.

### On DE1

1. Create a file transfer script:

    ```bash
    vim secure_transfer.sh
    ```

2. Add the following lines to the script:

    ```bash
    #!/bin/bash
    echo "This is a test file" > testfile.txt
    echo "Transferring file to DE2"
    scp -i path/to/your_key.pem testfile.txt ec2-user@<DE2_public_ip>:~/
    echo "Transferring file to DE3"
    scp -i path/to/your_key.pem testfile.txt ec2-user@<DE3_public_ip>:~/
    ```

3. Make the script executable:

    ```bash
    chmod +x secure_transfer.sh
    ```

4. Run the script:

    ```bash
    ./secure_transfer.sh
    ```

## Step 5: Setting Up Docker on DE2 and DE3

You will need to install Docker on DE2 and DE3.

### For Amazon Linux

1. SSH into DE2 or DE3:

    ```bash
    ssh -i path/to/your_key.pem ec2-user@<DE2_public_ip>
    ```

2. Install Docker:

    ```bash
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    ```

3. Log out and back in to ensure your user is in the Docker group:

    ```bash
    exit
    ```

4. SSH back into DE2 or DE3 using the same command.

### For Ubuntu

1. SSH into DE2 or DE3:

    ```bash
    ssh -i path/to/your_key.pem ec2-user@<DE2_public_ip>
    ```

2. Update the Package Index:

    ```bash
    sudo apt update
    ```

3. Install Required Packages:

    ```bash
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    ```

4. Add Docker’s Official GPG Key:

    ```bash
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```

5. Set Up the Stable Repository:

    ```bash
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ```

6. Install Docker:

    ```bash
    sudo apt update
    sudo apt install docker-ce -y
    ```

7. Start Docker Service:

    ```bash
    sudo systemctl start docker
    sudo systemctl enable docker
    ```

8. Add Your User to the Docker Group:

    ```bash
    sudo usermod -aG docker $USER
    ```

9. Log Out and Back In.

10. Verify Docker Installation:

    ```bash
    docker --version
    ```

## Step 6: Containerizing and Deploying a Web Application

You will create a simple web application and deploy it using Docker.

### On DE1

1. Create a directory for your web application:

    ```bash
    mkdir my_web_app
    cd my_web_app
    ```

2. Create a simple HTML file:

    ```bash
    echo "<h1>Hello from Docker on DE2 and DE3!</h1>" > index.html
    ```

3. Create a Dockerfile:

    ```bash
    vim Dockerfile
    ```

4. Add the following content to the Dockerfile:

    ```dockerfile
    FROM nginx:alpine
    COPY . /usr/share/nginx/html
    ```

5. Build the Docker image:

    ```bash
    docker build -t my_web_app .
    ```

## Step 7: Transfer Docker Image to DE2 and DE3

1. Save the Docker image to a tar file:

    ```bash
    docker save my_web_app | gzip > my_web_app.tar.gz
    ```

2. Transfer the Docker image to DE2:

    ```bash
    scp -i path/to/your_key.pem my_web_app.tar.gz ec2-user@<DE2_public_ip>:~/
    ```

3. Transfer the Docker image to DE3:

    ```bash
    scp -i path/to/your_key.pem my_web_app.tar.gz ec2-user@<DE3_public_ip>:~/
    ```

## Step 8: Load and Deploy the Web Application on DE2 and DE3

### On DE2

1. SSH into DE2:

    ```bash
    ssh -i path/to/your_key.pem ec2-user@<DE2_public_ip>
    ```

2. Load the Docker image:

    ```bash
    gunzip -c my_web_app.tar.gz | docker load
    ```

3. Run the Docker container:

    ```bash
    docker run -d -p 80:80 my_web_app
    ```

### Repeat the above steps for DE3:

1. SSH into DE3, load the Docker image, and run the container.

## Step 9: Validate Successful Web Application Deployment

Open your web browser and access the public IP addresses of DE2 and DE3. You should see the message "Hello from Docker on DE2 and DE3!" displayed.

Congratulations! You have successfully set up and deployed a web application on AWS EC2 instances using Docker.

# ✨
Thank you, [Train With Shubham](https://www.trainwithshubham.com/), for this [BashBlaze-7-Days-of-Bash-Scripting-Challenge
](https://github.com/LondheShubham153/BashBlaze-7-Days-of-Bash-Scripting-Challenge/tree/main)  challenge and its amazing journey and also Thank You to everyone who followed along! 🙌
