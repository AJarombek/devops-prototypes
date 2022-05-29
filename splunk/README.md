### Overview

Splunk Enterprise setup using Dockerfiles.

### Commands

**Basic Docker Setup**

```bash
# Start the Splunk container
docker pull splunk/splunk:latest
docker run -d -p 8000:8000 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=splunkadmin" --name splunk splunk/splunk:latest

# Delete the Splunk container
docker container stop splunk
docker container rm splunk
```

### Files

| Filename                      | Description                                                                         |
|-------------------------------|-------------------------------------------------------------------------------------|
| `logs`                        | Directory containing logs to manually upload to Splunk.                             |
| `basic_queries.spl`           | Basic Splunk queries using the pre-existing Splunk indexes.                         |
| `saints_xctf_api_queries.spl` | Basic Splunk queries using a custom `saints_xctf_api` Splunk index.                 |
| `splunk_internals.json`       | A Splunk dashboard displaying memory utilization and prior queries.                 |
