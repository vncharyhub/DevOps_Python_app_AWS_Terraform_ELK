
# Required configuration for Jenkins, SonarQube, ELK stack

| -------------------------- |
|    Minimum viable setup    |
| -------------------------- |
| Service      | Instance    |
| ------------ | ----------- |
| Jenkins VM   | `t2.micro`  |
| SonarQube VM | `t2.medium` |
| ELK VM       | `t2.medium` |
| -------------------------- |

| --------------------------------------------------------------------------------- |
| Component | Instance    | RAM | Works?          | Notes                           |
| --------- | ----------- | --- | --------------- | ------------------------------- |
| Jenkins   | `t2.micro`  | 1GB | Yes (light)     | OK if you don't run heavy jobs  |
| SonarQube | `t2.medium` | 4GB | Yes             | SonarQube needs ≥2GB RAM        |
| ELK Stack | `t2.medium` | 4GB | Yes             | ElasticSearch alone needs \~2GB |
| --------------------------------------------------------------------------------- |

| ---------------------------------- |
| Open Required Security Group Ports |
| ---------------------------------- |
| Jenkins           :       8080     |
| SonarQube         :       9000     |
| Elasticsearch     :       9200     |
| Kibana            :       5601     |
| ---------------------------------- |

## Execute the following scripts to setup Jenkins, SonarQube, ELK stack
'''
pre-requisites/Install-jenkins.sh
pre-requisites/Install-SonarQube.sh
pre-requisites/Install-ELK-setup.sh
'''