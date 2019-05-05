### Overview

Module for creating MongoDB infrastructure.  This code almost made it into my jarombek-com-infrastructure.
However, in the end I decided to go with an ECS approach which utilizes containers instead of VMs.

### Files

| Filename          | Description                                                                                      |
|-------------------|--------------------------------------------------------------------------------------------------|
| `main.tf`         | Main Terraform script for the MongoDB module.  Creates a database instance.                      |
| `var.tf`          | Variables to pass into the main Terraform script.                                                |