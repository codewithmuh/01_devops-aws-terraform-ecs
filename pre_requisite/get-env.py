import boto3

def create_s3_bucket(bucket_name):
    # Initialize the S3 client
    s3_client = boto3.client('s3', region_name='us-west-1')  # Replace 'us-west-1' with your desired AWS region
    
    # Create S3 bucket
    try:
        response = s3_client.create_bucket(
            Bucket=bucket_name,
            CreateBucketConfiguration={
                'LocationConstraint': 'us-west-1'  # Specify your desired region here
            }
        )
        print("Bucket created:", bucket_name)
        
        # Enable versioning on the bucket
        s3_client.put_bucket_versioning(
            Bucket=bucket_name,
            VersioningConfiguration={'Status': 'Enabled'}
        )
        
        return response['Location']
    except Exception as e:
        print("An error occurred while creating the bucket:", e)
        return None

def upload_env_file_to_s3(bucket_name, file_path):
    # Initialize the S3 client
    s3_client = boto3.client('s3', region_name='us-west-1')  # Replace 'us-west-1' with your desired AWS region
    
    # Upload the file to S3
    try:
        s3_client.upload_file(file_path, bucket_name, file_path)
        print(f"Uploaded {file_path} to {bucket_name}")
    except FileNotFoundError:
        print(f"{file_path} not found.")
    except Exception as e:
        print("An error occurred:", e)

def get_env_file_arn_and_url(bucket_name, file_key):
    # Construct the ARN using bucket name, file key, and region
    arn = f"arn:aws:s3:::{bucket_name}/{file_key}"
    
    # Construct object URL
    object_url = f"https://{bucket_name}.s3.amazonaws.com/{file_key}"
    
    print("Env file ARN:", arn)
    print("Object URL:", object_url)
    
    return arn, object_url

if __name__ == "__main__":
    bucket_name = 'codewithmuh'  # Replace 'your_bucket_name' with your desired bucket name
    file_path = 'production.django-backend.env'  # Name of your env file
    file_key = 'production.django-backend.env'  # Key under which the file will be saved in the bucket
    
    # Create S3 bucket
    bucket_location = create_s3_bucket(bucket_name)
    
    if bucket_location:
        # Upload the env file to the created S3 bucket
        upload_env_file_to_s3(bucket_name, file_path)
        
        # Get the ARN and URL of the uploaded env file
        env_file_arn, env_file_url = get_env_file_arn_and_url(bucket_name, file_key)
