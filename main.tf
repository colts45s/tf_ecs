# main.tf

module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  cluster_name = "ecs-test"
  vpc_id       = "vpc-00beea2ab6f09db53"

  private_subnet_ids = ["subnet-073f6b1149bc6ef5a","subnet-05eb9ad43a44d6d68","subnet-039fbffea5442b5d6"]
}
