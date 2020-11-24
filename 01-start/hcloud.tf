# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option


resource "hcloud_network" "mynet" {
  name = "my-net"
  ip_range = "10.0.0.0/8"
}
resource "hcloud_network_subnet" "foonet" {
  network_id = hcloud_network.mynet.id
  type = "cloud"
  network_zone = "eu-central"
  ip_range   = "10.0.1.0/24"
}

resource "hcloud_server_network" "srvnetwork" {
  server_id = hcloud_server.myserver.id
  network_id = hcloud_network.mynet.id
  ip = "10.0.1.5"
}

# Create a new SSH key
resource "hcloud_ssh_key" "default" {
  name = "Terraform Example"
  public_key = file("ssh/id_rsa.pub")
}

# Create a server 1, 2 pq redis
resource "hcloud_server" "myserver" {
  name        = "someerver"
  image       = "centos-7"
  server_type = "cx11"
}

# Create a volume
resource "hcloud_volume" "storage" {
  name       = "myaasvolume"
  size       = 50
  server_id  = hcloud_server.myserver.id
  automount  = true
  format     = "ext4"
}
