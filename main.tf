variable "my_set_of_resources" {
  type = set(string)
  default = ["resource A", "resource B", "resource C", "resource D"]
}


resource "null_resource" "count" {
  count = length(var.my_set_of_resources)
  triggers = {
    name = tolist(var.my_set_of_resources)[count.index]
  }
}

resource "null_resource" "for_each" {
  for_each = var.my_set_of_resources
  triggers = {
    name = each.value
  }
}
