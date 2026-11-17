#!/usr/bin/env bash
# Print everything needed to reach the private RDS instance through the
# bastion host, using the outputs of a successful `terraform apply`.
#
# Usage:
#   ./scripts/show_connection_info.sh                  # password hidden
#   ./scripts/show_connection_info.sh --show-password  # include password
set -euo pipefail

TF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../terraform" && pwd)"
out() { terraform -chdir="$TF_DIR" output -raw "$1"; }

BASTION_DNS="$(out bastion_host_dns)"
DB_HOST="$(out db_host)"
DB_PORT="$(out db_port)"
DB_USER="$(out db_master_username)"

echo "Bastion host (public DNS) : $BASTION_DNS"
echo "RDS endpoint (private)    : $DB_HOST:$DB_PORT"
echo "DB master user            : $DB_USER"

if [[ "${1:-}" == "--show-password" ]]; then
  echo "DB master password        : $(out db_master_password)"
else
  echo "DB master password        : (hidden, re-run with --show-password)"
fi

cat <<MSG

1) Open an SSH session on the bastion host, e.g. AWS Console -> EC2 ->
   Instances -> <project>-bastion-host -> Connect -> EC2 Instance Connect
   (or: ssh -i <project>-bastion-host-key.pem ec2-user@$BASTION_DNS)

2) From the bastion host, connect to PostgreSQL:
   psql -h $DB_HOST -U $DB_USER -p $DB_PORT -d postgres --password

3) Inside psql:
   \i sql/ratings_table_ddl.sql
   \i sql/copy_data.sql
   SELECT * FROM ratings_training LIMIT 10;
MSG
