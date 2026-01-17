
#!/usr/bin/env bash

# Root folder (WSL path for D:\New Obsidian\Armageddon-Lab3-4)
ROOT="d:/New Obsidian/Armageddon-Lab3-4/home-llm-smarthome"

echo "Creating MkDocs structure at:"
echo "$ROOT"
echo

# Create base folders
# mkdir -p "$ROOT/docs"

# Architecture
mkdir -p "$ROOT/docs/architecture"

# Hardware
mkdir -p "$ROOT/docs/hardware"

# Network
mkdir -p "$ROOT/docs/network"

# Home Assistant
mkdir -p "$ROOT/docs/home-assistant"

# Cameras
mkdir -p "$ROOT/docs/cameras"

# Education
mkdir -p "$ROOT/docs/education"

# Operations
mkdir -p "$ROOT/docs/operations"

# LLM
mkdir -p "$ROOT/docs/llm"

# Assets
mkdir -p "$ROOT/docs/assets/diagrams"
mkdir -p "$ROOT/docs/assets/images"

# Create markdown files
touch "$ROOT/docs/index.md"

touch "$ROOT/docs/architecture/overview.md"

touch "$ROOT/docs/hardware/assembly.md"
touch "$ROOT/docs/hardware/storage.md"

touch "$ROOT/docs/network/poe-network.md"

touch "$ROOT/docs/home-assistant/control-plane.md"

touch "$ROOT/docs/cameras/security.md"

touch "$ROOT/docs/education/use-cases.md"

touch "$ROOT/docs/operations/growth.md"

touch "$ROOT/docs/llm/server-deep-dive.md"

# mkdocs config
touch "$ROOT/mkdocs.yml"

echo "MkDocs folder structure and markdown files created successfully."
