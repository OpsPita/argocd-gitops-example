
resource "local_file" "hello" {
    content  = "Hello, ${var.name}"
    filename = "./hello.${var.name}"
}
