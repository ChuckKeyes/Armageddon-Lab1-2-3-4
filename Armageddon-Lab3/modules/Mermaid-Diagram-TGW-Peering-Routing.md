flowchart LR
  %% Regions
  subgraph TOKYO[Tokyo (ap-northeast-1)]
    TVPC[Tokyo VPC\n10.10.0.0/16\nvpc-07731da43ab3eb9a1]
    TPrivRT[Tokyo Private RT\nrtb-0029ea9f5ecc56557\nRoute: 10.20.0.0/16 -> Tokyo TGW]
    TTGW[Tokyo TGW\ntgw-04a758504cdbb5c89]
    TTGWRtb[Tokyo TGW RTB\ntgw-rtb-060120fefacd8695e\nStatic: 10.20.0.0/16 -> Peering]
    TAttach[Tokyo VPC Attachment\ntgw-attach-0a84ccece440bd26c]
  end

  subgraph SAOPAULO[São Paulo (sa-east-1)]
    SVPC[São Paulo VPC (Liberdade)\n10.20.0.0/16\nvpc-0adc3b8e1d8b72d7c]
    SPrivRT[São Paulo Private RT\nrtb-02cd87950e5b51a10\nRoute: 10.10.0.0/16 -> São Paulo TGW]
    STGW[São Paulo TGW\ntgw-0ccc88e31b142add9]
    STGWRtb[São Paulo TGW RTB\ntgw-rtb-08c344798f54cbb5a\nStatic: 10.10.0.0/16 -> Peering]
    SAttach[São Paulo VPC Attachment\ntgw-attach-0803cb14fa20177af]
  end

  %% Peering
  Peer[TGW Peering Attachment\nTokyo <-> São Paulo\ntgw-attach-0f74b721d4c4197a4\nState: available]

  %% VPC route table to TGW (conceptual)
  TVPC --> TPrivRT --> TTGW
  SVPC --> SPrivRT --> STGW

  %% VPC attachments
  TTGW --- TAttach --- TVPC
  STGW --- SAttach --- SVPC

  %% TGW route tables
  TTGW --> TTGWRtb
  STGW --> STGWRtb

  %% Peering paths via TGW RTBs
  TTGWRtb -->|10.20.0.0/16| Peer -->|10.10.0.0/16| STGWRtb
