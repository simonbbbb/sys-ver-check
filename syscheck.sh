#!/bin/bash

if [ "$(lsb_release -rs)" != "20.04" ]; then echo "$(lsb_release -rs)"; fi

vcpu=$(grep -c ^processor /proc/cpuinfo)
avx=$(grep -o avx /proc/cpuinfo | wc -l)
ram=$(free -g | awk '/^Mem:/{print $2}')
disk=$(df -BG / | awk '/\//{print $4}' | sed 's/G//')

echo "vCPUs: $vcpu (Req: 8)  AVX: $([[ $avx -ge 1 ]] && echo "Yes" || echo "No")"
echo "RAM: $ram GB (Req: 16)  Disk: $disk GB (Req: 32)"

[[ $vcpu -ge 8 && $avx -ge 1 && $ram -ge 16 && $disk -ge 32 ]] && echo "VERDICT: PASSED" || echo "VERDICT: FAILED"
