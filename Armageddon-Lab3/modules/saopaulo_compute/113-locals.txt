locals {
  # Prefer Tokyo remote state, fall back to manual var only if needed
  tokyo_peer_attachment_id = coalesce(
    try(data.terraform_remote_state.tokyo.outputs.tokyo_to_saopaulo_tgw_attachment_id, null),
    var.tokyo_to_saopaulo_tgw_attachment_id
  )

  tokyo_vpc_cidr = coalesce(
    try(data.terraform_remote_state.tokyo.outputs.tokyo_vpc_cidr, null),
    var.tokyo_vpc_cidr
  )
}
