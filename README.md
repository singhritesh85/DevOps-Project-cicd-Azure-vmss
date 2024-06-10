# DevOps-Project-cicd-Azure-vmss
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/a14ca39f-94d4-4e58-acf6-c20e3f1d5fad)
For the present scenario I am deploying a web application in Azure vmss using Azure DevOps. The infrastructure has been created using terraform script as present in this repository. Initially a Golden Image is created using packer which runs through the shell-script create-infra.sh. This shell script creates an Azure Compute Gallery and Image definition in Azure Compute Gallery using the Azure CLI. Tomcat has been installed in Golden AMI using Ansible. For creation of Golden Image I have used packer. 
<br><br/>
For Deployment of war file which is created during the build stage as shown in the Architecture diagram above, Image versions has been created I have named it as Release Images. These Image versions will be stored in the Azure Compute Gallery and Azure vmss will be updated with these Image versions. Creation of Release Images and updating vmss with these image versions is initiated by shell script, I named it as create-infra.sh. This shell script, Ansible playbook, template.json to create Release Image versions and azure-pipelines.yml which will be used for deployment are present in Azure Repos as shown in the screenshot below.
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/a31c61ba-fe5c-4931-8073-0ac594f6a2b9)
<br><br/>
For storing Artifacts, Azure Artifacts has been used and pom.xml should be updated as shown in the screenshot below.
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/f95bcc7c-ab4d-4664-8f0b-ef94bcf23953)
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/3fce46ed-9a6a-4ed6-9325-8edc62c90e85)
<br><br/>
Service Connection has been created for SonarQube and Maven-Feed as shown in screen-shot attached below.
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/0e105a4e-fd54-468a-bf01-2b3c8ea04695)
<br><br/>
Record Set entry in Azure DNS Zones for Application Gateway has been shown in screen-shot attached blow.
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/97140bff-0996-4a82-8d7a-141f92582159)
<br><br/>
Finally different Release Image versions has been created and deployed to Azure vmss as shown in the screenshots attached below.
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/79943a04-6d1f-4469-83ac-b690173b100f)
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/acb0d166-e95b-46cb-af34-cc8a518403e7)
<br><br/>
Multiple versions of Release Images will be present in Azure Compute Gallery. Screenshot of the same has been attached below.
<br><br/>
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/995a5098-9694-41b3-8ad9-9a86fdda090c)
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/02651681-4689-4600-8f05-04b4a4bc8376)
<br><br/>
After Deployment you can check the current image version from the console also as shown in the screenshot attached bwlow.
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/148977ff-7a5c-4bfb-a96f-a3ff6e6b9b21)
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/3e6f026e-6e76-4c4f-95a6-0d9fdf5ae5fb)
<br><br/>
Finally Application has been accessed as shown in the screenshot attached below.
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/899da9c4-8e79-4096-abd2-16be9cbb97c4)
![image](https://github.com/singhritesh85/DevOps-Project-cicd-Azure-vmss/assets/56765895/62ba85ab-41ec-4378-ab5b-4e636ec652af)

<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
```
Source Code:-  https://github.com/singhritesh85/aws-rds-java-azure-vmss.git
```
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
```
Reference:-   https://ashok198510.hashnode.dev/cloud-native-two-tier-application-deployment-with-eks-tomcat-and-rds-in-aws
              https://github.com/Ashoksana/aws-rds-java.git
```
