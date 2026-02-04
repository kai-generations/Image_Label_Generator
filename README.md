# Image Label Rekognition: Terraform Guide

## What is this project

This project takes an image from an S3 bucket and uses a Python script to tell AWS Rekognition to scan the image and return the image with items such as people and objects identified with boxes and labeled.

## Manual Process

Feel free to use the Image_Label_Generator.md file to go through the manual process. It also contains extra notes and some final thoughts at the end of the document.

## Steps to run using Terraform

The steps below are assuming you are using a Windows computer, have terraform and python already installed, and that your CLI has been configured to use a IAM user account with the AdministratorAccess policy attached.

If not then plesae go configure these resources and then come back to follow these steps.

- **Step 1:** Download the repository
- **Step 2:** Open terminal and cd into the root of the repository you downloaded
- **Step 3:** In the terminal type in the folowing command and hit Enter; This will initalize the working directory and download all the necesaary provider plugins and modules
```powershell
terraform init
```
- **Step 4:** After it is done initializing, run the following command and hit Enter
```powershell
terraform apply
```
- **Step 5:** In the terminal you will see all the things that are planned to be built by terraform and at the bottom it will ask if you want to perform these actions. Type *yes* and hit Enter
- **Step 6:** At this point the S3 bucket will have been created with an auto-generated name and the image will have been uploaded to it
- **Step 7:** In the terminal you will need to set an environment variable so that the python script will be able to use the auto-generated bucket; To do this type this command into the terminal and hit Enter:
  ```powershell
  $env:BUCKET_NAME = terraform output -raw existing_s3_bucket
  ```
- **Step 8:** After setting the variable you can run the python script by typing in this command in the terminal and then hit Enter:
  ```powershell
  py rekognition.py
  ```
- **Step 9:** After running the python script you will see 10 items that are labeled and given a confidence score and a window will open displaying the image with boxes surrounding the objects with their confidence scores
- **Step 10:** After viewing the image and data go back to the terminal and run this command so that everything that was created by the terraform code will be deleted; And just like terraform apply command please type yes at the bottom to confirm the action
  - **Notes: Be sure to confirm in your AWS account that all resources created by terraform have been deleted. My directions should suffice, but please check just in case something doesn't go as planned.**
```powershell
terraform destroy
```
- **Step 11:** With that you have successfuly ran the terraform code and the python script.
