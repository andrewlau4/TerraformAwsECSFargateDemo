# Terraform AWS Demo for ECS, Capacity Provider, Fargate

This is a Terraform implementation of the ECS, Capacity Provider and Fargate, based on [the youtube video "Deep Dive on Amazon ECS Capacity Providers"](https://www.youtube.com/watch?v=Vb_4wAEcfpQ)

It builds the ECS Cluster infrastructure based on that video:

![Workflow](./readme/ecs_cluster_autoscaling.png)

For Forgate, you can experiment with the capacity provider's base and weight as explained in the video:

![Fargate_Capacity_Provider](./readme/ecs_fargate_capacity_provider.png)

The weight can be changed in the [create_ecs_infrastructure.tf](create_ecs_infrastructure.tf) file:
```
    capacity_provider_strategy = concat(
        [
            {
                capacity_provider_name = "FARGATE"
                base = 0
                weight =  1
            },
            {
                capacity_provider_name = "FARGATE_SPOT"
                base = 0
                weight =  1
            }

        ],
```

# CodePipeline
Moreover, a codepipeline is setup to autmatically build an [example node js app](https://github.com/andrewlau4/AwsECSDemoDockerImage) into a docker image; and then push that image into the ECR registry, and then deploy it as ECS service.

To use the codepipeline, your AWS CodePipeline must have a connection to the source repository. You can fork the  [example node js app](https://github.com/andrewlau4/AwsECSDemoDockerImage). Then follow the [GitHub instruction](https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-create-github.html) to set it up.

Then run this terraform command to setup the CodePipeline:

```
terraform apply -var="enable_code_pipeline=true" -var="codestar_git_source_connection_name=your_source_code_connection" -var="source_repo_url=your_docker_app_repository"
```




