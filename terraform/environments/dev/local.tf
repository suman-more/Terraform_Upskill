locals {
  provider                = "azure"
  system                  = "td"
  env                     = "dev"
  context                 = "tni"
  location                = "West Europe"
  region                  = "euw"
  tags = {
    sc_system    = "ai"
    sc_env       = "dev"
    sc_region    = "eu1"
    sc_provider  = "azure"
    sc_createdby = "terraform"
    sc_type      = "internal"
    sc_costowner = "r-and-d"
    environment  = "staging"
  }
#   users = {
#     iwe  = "e31d43b8-f867-424b-8bb3-08e830e5e859"
#   }
genai_dev_user_ids = [
    "89dfb358-f764-4940-aa9f-68d7ab4b5f6e"
  ]
}