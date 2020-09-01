#!/bin/sh

# For NUC980-LORAG BOARD
./reset_lgw.sh start 64

# Run packet forwarder
./lora_pkt_fwd &

