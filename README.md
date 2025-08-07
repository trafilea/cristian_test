# go-template
A template to create API projects in GO
After crating and configuring a project with this template we will have a project ready to deploy as an API
The project will contain
1. Initial code with a /ping GET method with tests and coverage
2. Dockerfile to create registry in AWS
3. Sonarcloud configuration to check tests, coverage and code quality
4. CI/CD pipelines to deploy
5. Terraform configuration to deploy to AWS as an API
6. Datadog configuration

## Instructions
This template doesn't contain all the names of the created project. So this guideline is **very important** to ensure a proper project configuration

### Code configuration
Golang works with modules, so this project is created with module 'github.com/trafilea/go-template' (see go.mod file)
So here is the list with all the changes needed for the project to build
1. Go to *go.mod* file and change 'go-template' for your project-name
Example: ```module github.com/trafilea/go-template``` -> ```module github.com/trafilea/checkout-api```
2. Go to *internal/routes/routes.go* and change all 'go-template' to your project's name
Example: ```github.com/trafilea/go-template/pkg/apperrors``` -> ```github.com/trafilea/checkout-api/pkg/apperrors```
3. Go to *internal/routes/routes_test.go* and change all 'go-template' to your project's name. Same as point 2
4. Go to *cmd/app/main.go* and change all 'go-template' to your project's name. Same as point 2
5. Run command ```go mod tidy```
6. Run command ```go build ./...``` to check all changes are ok

### Dockerfile configuration
In this case we need to change all project name references
1. ```WORKDIR /go-template``` -> ```WORKDIR /checkout-api```
2. ```RUN go build -o /build/go-template.go cmd/app/main.go``` -> ```RUN go build -o /build/checkout-api.go cmd/app/main.go```
3. ```CMD [ "/build/go-template.go" ]``` -> ```CMD [ "/build/checkout-api.go" ]```

### Sonarcloud configuration
In this case we need to change all project name references
1. ```'sonar.projectKey=trafilea_go-template'``` -> the project key assigned when setting up sonar
2. ```sonar.projectName=go-template``` -> ```sonar.projectName=checkout-api```

### CI/CD configuration
There isn't anything to change in case of CI. But there are some things to change for CD

1. In *.github/workflows/continuous-deployment.yaml* edit the following
    1. Change ```APP_NAME: go-template``` -> ```APP_NAME: checkout-api```
    2. Add `branches` instead of `branches-ignore` to CD pipeline (we are removing this because we don't want to execute them when creating this go-template)
        ```yaml
        on:
            push:
                branches:
                    - main
                    - develop
        ```
        
2. In *.github/workflows/continuous-integration.yaml* edit the following
    1. Add `branches` instead of `branches-ignore` to CD pipeline (we are removing them because we don't want to execute them when creating this go-template)
        ```yaml
        on:
            pull_request:
                branches:
                    - main
                    - develop
        ```

3. In *.github/workflows/datadog-monitors.yaml* edit the following
    1. Add `branches` instead of `branches-ignore` to CD pipeline (we are removing them because we don't want to execute them when creating this go-template)
        ```yaml
        on:
            pull_request:
                branches:
                    - main
                paths:
                    - '.datadog/**'
        ```
    2. ```TF_VAR_APPLICATION_NAME: go-template``` -> ```TF_VAR_APPLICATION_NAME: checkout-api```

4. In *.github/workflows/manual-deployment.yaml* edit the following
    1. Change ```APP_NAME: go-template``` -> ```APP_NAME: checkout-api```

### Datadog
1. In *.datadog/datadog.backend.tf* change project names
    1. ```key = "go-template/datadog.tfstate"``` -> ```key = "checkout-api/datadog.tfstate"```

2. **Configure Entity Management (`entity.datadog.yaml`)**
   
   This template includes a Datadog entity configuration file at `.datadog/entity.datadog.yaml` that defines your service and API metadata for better observability and service management. **This file is mandatory and must be properly configured before deploying your service.**

   **Why is this important?**
   - Enables better service discovery and dependency mapping
   - Improves incident management and alerting
   - Provides clear ownership and contact information
   - Integrates with PagerDuty for on-call management
   - Supports better API documentation and lifecycle management

   **Required changes in `.datadog/entity.datadog.yaml`:**
   - Replace all `go-template` references with your actual project name
   - Update `YOUR-TEAM` with your team name (e.g., platform-team, hydra)
   - Update `YOUR-DOMAIN` with your business domain (e.g., orders, inventory, payments)
   - Update all GitHub repository URLs
   - Configure team contacts (Slack channel and email)
   - Update PagerDuty service URL
   - Verify API specification file reference

   **Team Responsibility:**
   - **Each development team is responsible for maintaining their `entity.datadog.yaml` file**
   - Keep contact information up to date
   - Update service descriptions and dependencies as the service evolves
   - Ensure proper lifecycle and tier classifications
   - Coordinate with the platform team for any structural changes

### Other configurations
1. Create project in SonarCloud and create the secret SONAR_TOKEN in the project
2. Ask Infrastructure team to create ECR repository with the project name (example checkout-api)
3. Ask github organization's admin to allow the project to have AWS secrets
