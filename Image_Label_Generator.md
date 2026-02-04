# Image Label Generator

## Steps to be Performed

1. Create S3 Bucket
2. Upload images to S3 Bucket
3. Installing configuring the AWS CLI
4. Importing libraries
5. Adding detect_labels function
6. Adding main function
7. Running your python file

## Services that will be used

- Amazon S3: for storing the images in the process of generating labels
- Amazon Rekognition: to analyze images and generate image labels
- AWS CLI: Interacting with AWS services through command line interface

## Create the S3 bucket

- **Step 1:** Go to the S3 console and create a bucket (must be a unique name since it is global)
- **Step 2:** Upload the the image to the bucket

## Install and Configure AWS CLI

- **Step 1:** Open terminal
- **Step 2:** Run the command to install it onto your system
- **Step 3:** Configure AWS CLI using the aws configure command
- **Step 4:** Go to IAM using the console and navigate to Users and create a New User
- **Step 5:** Give the new user the AdministratorAccess policy
- **Step 6:** Navigate to the user that was created and click on Access key under the Access Key option
- **Step 7:** Choose the CLI as the use case, check the confirmation box
- **Step 8:** Copy and store secret key
- **Step 9:** Go back to terminal and enter the access key and secret key

## Import Libraries

- **Step 1:** Run pip install boto3 and pip install matplotlib
  - **Notes: boto3 is for interacting with AWS services  
  matplotlib is for visualization  
  PIL(Python Imaging Library) is for handling image data  
  BytesIO from the io module to work with image data**
- **Step 2:** Create a python file in VS code and use these libraries
```python
import boto3
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from PIL import Image
from io import BytesIO
```

## Define functions

-**Step 1:** Create a function called detect_labels; which will take a photo and bucket name as input parameters
- **Notes: We create a Rekognition client using boto3.  
We use the detect_labels method of the Rekognition client to detect labels in the given photo.  
We print the detected labels along with their confidence levels.  
We load the image from the S3 bucket using boto3 and PIL.  
We use matplotlib to display the image and draw bounding boxes around the detected objects.**
```python
def detect_labels(photo, bucket):
    # Create a Rekognition client
    client = boto3.client('rekognition')

    # Detect labels in the photo
    response = client.detect_labels(
        Image={'S3Object': {'Bucket': bucket, 'Name': photo}},
        MaxLabels=10)

    # Print detected labels
    print('Detected labels for ' + photo)
    print()
    for label in response['Labels']:
        print("Label:", label['Name'])
        print("Confidence:", label['Confidence'])
        print()

    # Load the image from S3
    s3 = boto3.resource('s3')
    obj = s3.Object(bucket, photo)
    img_data = obj.get()['Body'].read()
    img = Image.open(BytesIO(img_data))

    # Display the image with bounding boxes
    plt.imshow(img)
    ax = plt.gca()
    for label in response['Labels']:
        for instance in label.get('Instances', []):
            bbox = instance['BoundingBox']
            left = bbox['Left'] * img.width
            top = bbox['Top'] * img.height
            width = bbox['Width'] * img.width
            height = bbox['Height'] * img.height
            rect = patches.Rectangle((left, top), width, height, linewidth=1, edgecolor='r', facecolor='none')
            ax.add_patch(rect)
            label_text = label['Name'] + ' (' + str(round(label['Confidence'], 2)) + '%)'
            plt.text(left, top - 2, label_text, color='r', fontsize=8, bbox=dict(facecolor='white', alpha=0.7))
    plt.show()

    return len(response['Labels'])
```
- **Step 2:** Now create the main function to test our detect_labels function (make sure to change the bucket and image name in the code)
```python
def main():
    photo = 'image_file_name'
    bucket = 'bucket_name'
    label_count = detect_labels(photo, bucket)
    print("Labels detected:", label_count)

if __name__ == "__main__":
    main()
```

## Run your code

- **Step 1:** Open your terminal and type python rekognition.py to run it

## Conclusion and thoughts

This project went real smoothly. There were no issues with the guide I followed and I got a nice small view at how Amazon Rekognition works with code. I'd like to come back to this and see what else I can do with it, but for now I am happy to know how to create Acess keys and got an intro with the AWS CLI usage.  
  
I need to see if I can make this happen with Terraform; at the least I should be able to create an S3 Bucket.

## What I learned Terraforming this

My first project I turned into Terraform was a huge success for me, and it wasn't that complicated once I figured everything out. I learned a lot more about resource, data, and output blocks from this project. I was really trying to imitate the Hashicorp tutorial in creating it, but once I dug in I found that I didn't need to imitate it that much. I was really shocked that it didn't take that much effort to build an s3 bucket using Terraform as the method and I was just as equally surprised when I learned that I could just upload that image I needed to the bucket using the same resource block.

The real tricky part was getting the bucket name into the python code, since it was auto-generated by terraform. I did a little research and had AI walk me through a few of my options and I found that putting the bucket name in an output block, then defining the output as an environment variable in terminal to then be imported into the python file using the os library was the most effective. I hadn't messed with environment variables much since this project and it wasn't as bad or confusing as I thought they would be. All in all I am super happy with how this turned out and I am looking forward to making more terraform files of my projects.
