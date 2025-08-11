import requests

url = "https://api.github.com/repos/vncharyhub/DevOps_Python_app_AWS_Terraform_ELK/issues"
response = requests.get(url)

if response.status_code == 200:
    issues = response.json()
    for issue in issues:
        print(f"Issue #{issue['number']}: {issue['title']}")
else:
    print(f"Failed to fetch issues: {response.status_code}")
