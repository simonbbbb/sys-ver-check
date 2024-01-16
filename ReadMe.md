# System Check GitHub Action

This GitHub Action performs a system check on an Ubuntu environment using a Bash script (`syscheck.sh`).

## Usage

### Workflow Configuration

```yaml
name: System Check

on: [push, pull_request]

jobs:
  system_check:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Run syscheck.sh
      run: bash syscheck.sh 
```

```bash
#!/bin/bash

# Check Ubuntu version
if [ "$(lsb_release -rs)" != "20.04" ]; then echo "$(lsb_release -rs)"; fi

# Get system information
vcpu=$(grep -c ^processor /proc/cpuinfo)
avx=$(grep -o avx /proc/cpuinfo | wc -l)
ram=$(free -g | awk '/^Mem:/{print $2}')
disk=$(df -BG / | awk '/\//{print $4}' | sed 's/G//')

# Display system information
echo "vCPUs: $vcpu (Req: 8)  AVX: $([[ $avx -ge 1 ]] && echo "Yes" || echo "No")"
echo "RAM: $ram GB (Req: 16)  Disk: $disk GB (Req: 32)"

# Provide verdict based on requirements
[[ $vcpu -ge 8 && $avx -ge 1 && $ram -ge 16 && $disk -ge 32 ]] && echo "VERDICT: PASSED" || echo "VERDICT: FAILED"
```
### Usage
```bash
chmod +x syscheck.sh
./syscheck.sh
```
