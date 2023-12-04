import boto3
import time

def create_certificate(domain_name):
    # Initialize the ACM client
    acm_client = boto3.client('acm', region_name='us-west-1')  # Replace 'us-west-1' with your AWS region
    
    # Request the certificate
    try:
        response = acm_client.request_certificate(
            DomainName=domain_name,
            ValidationMethod='DNS'
        )
        certificate_arn = response['CertificateArn']
        print("Certificate ARN:", certificate_arn)
        return certificate_arn
    except Exception as e:
        print("An error occurred while requesting the certificate:", e)
        return None

def get_certificate_details(certificate_arn):
    # Initialize the ACM client
    acm_client = boto3.client('acm', region_name='us-west-1')  # Replace 'us-west-1' with your AWS region
    
    try:
        # Describe the certificate
        response = acm_client.describe_certificate(
            CertificateArn=certificate_arn
        )
        certificate_details = response['Certificate']
        
        print("Certificate Details:")
        print("ARN:", certificate_details['CertificateArn'])
        print("Status:", certificate_details['Status'])
        # print("cert whole details:", certificate_details)
        
        # Check if CNAME details are available
        if 'DomainValidationOptions' in certificate_details:
            for domain_validation_option in certificate_details['DomainValidationOptions']:
                print("Validation Domain:", domain_validation_option['DomainName'])
                
                # Print CNAME details if available
                if 'ResourceRecord' in domain_validation_option:
                    cname_record = domain_validation_option['ResourceRecord']
                    print("CNAME Name:", cname_record['Name'])
                    print("CNAME Value:", cname_record['Value'])
                else:
                    print("CNAME details not available yet.")
    except Exception as e:
        print("An error occurred while fetching certificate details:", e)
        
if __name__ == "__main__":
    domain_name = 'dovz.shop'  # Replace 'your_domain_name' with your domain
    
    # Create the certificate
    certificate_arn = create_certificate(domain_name)
    
    if certificate_arn:
        # Wait for a short duration before getting the details (5 seconds delay)
        time.sleep(5)
        
        # Get the details of the created certificate
        get_certificate_details(certificate_arn)