module "next_app" {
  source = "../../modules/nextjs-stack"

  prefix      = "intern"
  name        = "inmeta-games"
  environment = "dev"
}
