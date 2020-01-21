# for_each-tf
Small demo of using for_each with resources.

Shout out to Dave Chappelle for uncovering this one.

The tfstate file has been included so you can see what happens when you try to delete a resource in a list.
Essentially terraform has to re-index all of the resources which causes alot of unneeded deleting/creating.
When you use a for_each instead of count with a set, terraform chooses a better ID for each resource, so when
you remove something from the middle of a set it knows exactly what part of the state to target.

Here is an example when we run `terraform plan -var 'my_set_of_resources=["resource A", "resource C", "resource D"]'` (removing resource B).
As you can see the resources created with `count` all get shuffled and there is alot of unneeded work.
```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.count[1] must be replaced
-/+ resource "null_resource" "count" {
      ~ id       = "7917027815834816187" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "name" = "resource B" -> "resource C"
        }
    }

  # null_resource.count[2] must be replaced
-/+ resource "null_resource" "count" {
      ~ id       = "1630229190969434012" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "name" = "resource C" -> "resource D"
        }
    }

  # null_resource.count[3] will be destroyed
  - resource "null_resource" "count" {
      - id       = "4994212249103566959" -> null
      - triggers = {
          - "name" = "resource D"
        } -> null
    }

  # null_resource.for_each["resource B"] will be destroyed
  - resource "null_resource" "for_each" {
      - id       = "1163336361708868214" -> null
      - triggers = {
          - "name" = "resource B"
        } -> null
    }

Plan: 2 to add, 0 to change, 4 to destroy.
```
