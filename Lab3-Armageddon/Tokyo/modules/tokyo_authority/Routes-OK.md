✅ “Routes OK” checklist (must all be true)
1) VPC route tables have the right routes (both directions)

São Paulo private RT must have:

Dest = Tokyo VPC CIDR

Target = São Paulo TGW

Tokyo private RT(s) must have:

Dest = São Paulo VPC CIDR

Target = Tokyo TGW

If either side is missing, you get one-way traffic (classic “it pings one direction only / no response”).

2) TGW peering is active and attachments exist

You need:

Tokyo TGW peering attachment (requester) ✅

São Paulo peering accepter ✅

Status should be available

3) TGW route tables know how to reach each VPC

Even if VPC RTs are correct, TGW still needs routes in its TGW route table(s).

For each TGW route table involved, ensure routes exist for:

Tokyo VPC CIDR → Tokyo VPC attachment

São Paulo VPC CIDR → São Paulo VPC attachment

(and the peering attachment is associated/propagating as intended)