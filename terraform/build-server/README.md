### Initialize terraform
```bash
terraform init
```

### Set google credentials env var
Download credentials.json from [here](https://console.cloud.google.com/apis/credentials/serviceaccountkey)
Then set the following env var:
```
export GOOGLE_APPLICATION_CREDENTIALS=../credentials.json
``` 
