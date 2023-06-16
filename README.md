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