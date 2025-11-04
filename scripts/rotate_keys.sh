#!/usr/bin/env bash
set -euo pipefail

# rotate_keys.sh
# Small helper to generate replacement keys/CSRs and (optionally) self-signed certs
# Usage: ./scripts/rotate_keys.sh [-c common_name] [-t rsa|ec] [-s key_size] [-d days] [-o outdir] [--self-signed] [--dry-run]

COMMON_NAME="esp-device"
KEY_TYPE="rsa"
KEY_SIZE=2048
DAYS=365
OUTDIR="./rotated_keys/$(date +%Y%m%d_%H%M%S)"
SELF_SIGNED=0
DRY_RUN=0

usage(){
  cat <<EOF
Usage: $0 [options]
Options:
  -c CN        Common Name for CSR / certificate (default: ${COMMON_NAME})
  -t TYPE      Key type: rsa or ec (default: ${KEY_TYPE})
  -s SIZE      RSA key size in bits (default: ${KEY_SIZE})
  -d DAYS      Validity days for self-signed cert (default: ${DAYS})
  -o OUTDIR    Output directory (default: ${OUTDIR})
  --self-signed  Also create a self-signed cert (for testing)
  --dry-run      Print actions but don't create files
  -h             Show this help

This script generates a private key and CSR for rotation. It does NOT upload or deploy
the keys to any device or server. Keep private keys secure and do NOT commit them to git.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c) COMMON_NAME="$2"; shift 2;;
    -t) KEY_TYPE="$2"; shift 2;;
    -s) KEY_SIZE="$2"; shift 2;;
    -d) DAYS="$2"; shift 2;;
    -o) OUTDIR="$2"; shift 2;;
    --self-signed) SELF_SIGNED=1; shift 1;;
    --dry-run) DRY_RUN=1; shift 1;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 1;;
  esac
done

echo "Rotate keys helper"
echo "Common Name: $COMMON_NAME"
echo "Key type: $KEY_TYPE"
echo "Key size: $KEY_SIZE"
echo "Self-signed: $SELF_SIGNED"
echo "Dry-run: $DRY_RUN"
echo "Output dir: $OUTDIR"

mkdir -p "$OUTDIR"

TIMESTAMP=$(date +%s)

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "DRY RUN - would create files in $OUTDIR"
  exit 0
fi

if [[ "$KEY_TYPE" == "rsa" ]]; then
  KEY_FILE="$OUTDIR/${COMMON_NAME}_${TIMESTAMP}.key.pem"
  CSR_FILE="$OUTDIR/${COMMON_NAME}_${TIMESTAMP}.csr.pem"
  CERT_FILE="$OUTDIR/${COMMON_NAME}_${TIMESTAMP}.crt.pem"

  echo "Generating RSA private key ($KEY_SIZE bits): $KEY_FILE"
  openssl genpkey -algorithm RSA -out "$KEY_FILE" -pkeyopt rsa_keygen_bits:${KEY_SIZE}

  echo "Generating CSR: $CSR_FILE"
  openssl req -new -key "$KEY_FILE" -out "$CSR_FILE" -subj "/CN=${COMMON_NAME}"

  if [[ "$SELF_SIGNED" -eq 1 ]]; then
    echo "Generating self-signed cert: $CERT_FILE (valid ${DAYS} days)"
    openssl x509 -req -in "$CSR_FILE" -signkey "$KEY_FILE" -days "$DAYS" -out "$CERT_FILE"
  fi

elif [[ "$KEY_TYPE" == "ec" ]]; then
  KEY_FILE="$OUTDIR/${COMMON_NAME}_${TIMESTAMP}.key.pem"
  CSR_FILE="$OUTDIR/${COMMON_NAME}_${TIMESTAMP}.csr.pem"
  CERT_FILE="$OUTDIR/${COMMON_NAME}_${TIMESTAMP}.crt.pem"

  # Use prime256v1 by default
  echo "Generating EC private key (prime256v1): $KEY_FILE"
  openssl ecparam -name prime256v1 -genkey -noout -out "$KEY_FILE"

  echo "Generating CSR: $CSR_FILE"
  openssl req -new -key "$KEY_FILE" -out "$CSR_FILE" -subj "/CN=${COMMON_NAME}"

  if [[ "$SELF_SIGNED" -eq 1 ]]; then
    echo "Generating self-signed cert: $CERT_FILE (valid ${DAYS} days)"
    openssl x509 -req -in "$CSR_FILE" -signkey "$KEY_FILE" -days "$DAYS" -out "$CERT_FILE"
  fi

else
  echo "Unsupported key type: $KEY_TYPE"; exit 2
fi

echo
echo "Files created in: $OUTDIR"
ls -l "$OUTDIR"

cat <<'EOF'

Next steps (manual):

- If you have a CA, submit the generated CSR to your CA and obtain a signed certificate.
  Keep the private key (the .key.pem file) secret.

- Deploy the new certificate to your devices and servers. For ESP devices that store certs
  in flash, follow your own provisioning/OTA process to replace the certificate and key.

- Revoke the old certs with your CA (if applicable). Example for an OpenSSL CA:

  # revoke a cert
  openssl ca -config /path/to/openssl.cnf -revoke /path/to/old_cert.pem

  # regenerate CRL
  openssl ca -config /path/to/openssl.cnf -gencrl -out /path/to/crl.pem

- After deployment, verify devices and servers trust the new certificate and that old certs
  are no longer accepted.

- IMPORTANT: Do NOT commit private keys to source control. Remove any local copies from
  unsecured locations and store keys in a secrets manager or encrypted storage.

EOF

echo "Rotation helper finished."
