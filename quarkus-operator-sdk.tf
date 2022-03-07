# Create repository
resource "github_repository" "quarkus_operator_sdk" {
  name                   = "quarkus-operator-sdk"
  description            = "Quarkus Extension to create Kubernetes Operators in Java using the Java Operator SDK (https://github.com/java-operator-sdk/java-operator-sdk) project"
  archive_on_destroy     = true
  delete_branch_on_merge = true
  has_issues             = true
  has_projects           = true
  #has_discussions        = true
  vulnerability_alerts = true

  topics = ["kubernetes", "sdk", "operator", "quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }

  # Do not use the template below in new repositories. This is kept for backward compatibility with existing repositories
  template {
    owner      = "quarkiverse"
    repository = "quarkiverse-template"
  }
}

# Create team
resource "github_team" "quarkus_operator_sdk" {
  name                      = "quarkiverse-operator-sdk"
  description               = "Quarkiverse team for the operator-sdk extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_operator_sdk" {
  team_id    = github_team.quarkus_operator_sdk.id
  repository = github_repository.quarkus_operator_sdk.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_operator_sdk" {
  for_each = { for tm in ["metacosm"] : tm => tm }
  team_id  = github_team.quarkus_operator_sdk.id
  username = each.value
  role     = "maintainer"
}
