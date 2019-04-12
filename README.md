# Terraform Code 

Description:

Terraform code that would create EC2 Linux instance with 2 custom encrypted EBS volume.
It should automatically install some web server (free to select) such as Tomcat and also MongoDB (this is must). MongoDB db path should be XFS file system created in RAID10 using those 2 custom encrypted EBS volume. If you can setup Mongo in Docker then it is a bonus.

Terraform code should also have some automatic monitoring check for installed components to ensure they are up and running. The monitoring check should log the results to certain location where one can go and view. There should also be automation that would upload those logs to some s3 bucket once every hour.

Note: For privacy reasons, I have removed my aws keys from file user-data.sh and in order to test this task, please put your keys in this file at line no 55.
