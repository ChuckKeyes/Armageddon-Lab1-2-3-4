sed -i 's/export TOKYO_RDS_HOST="${TOKYO_RDS_HOST}"/export TOKYO_RDS_HOST="$TOKYO_RDS_HOST"/' startup.sh.tftpl
sed -i 's/export TOKYO_RDS_PORT="${TOKYO_RDS_PORT}"/export TOKYO_RDS_PORT="$TOKYO_RDS_PORT"/' startup.sh.tftpl
sed -i 's/export TOKYO_RDS_USER="${TOKYO_RDS_USER}"/export TOKYO_RDS_USER="$TOKYO_RDS_USER"/' startup.sh.tftpl


sed -i 's/export TOKYO_RDS_HOST="\${TOKYO_RDS_HOST}"/export TOKYO_RDS_HOST="$${TOKYO_RDS_HOST}"/' startup.sh.tftpl
sed -i 's/export TOKYO_RDS_PORT="\${TOKYO_RDS_PORT}"/export TOKYO_RDS_PORT="$${TOKYO_RDS_PORT}"/' startup.sh.tftpl
sed -i 's/export TOKYO_RDS_USER="\${TOKYO_RDS_USER}"/export TOKYO_RDS_USER="$${TOKYO_RDS_USER}"/' startup.sh.tftpl
sed -i 's/export DB_PASS="\${DB_PASS}"/export DB_PASS="$${DB_PASS}"/' startup.sh.tftpl


