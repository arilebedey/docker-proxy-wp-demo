#!/bin/bash

SECRETS_DIR="./secrets"

mkdir -p "$SECRETS_DIR"

touch "$SECRETS_DIR/db_password.txt"
touch "$SECRETS_DIR/wp_admin_password.txt"
touch "$SECRETS_DIR/wp_user_password.txt"

errors=()

if [ ! -s "$SECRETS_DIR/db_password.txt" ]; then
  errors+=("Please write postgres password at $SECRETS_DIR/db_password.txt")
fi

if [ ! -s "$SECRETS_DIR/wp_admin_password.txt" ]; then
  errors+=("Please write WP admin password at $SECRETS_DIR/wp_admin_password.txt")
fi

if [ ! -s "$SECRETS_DIR/wp_user_password.txt" ]; then
  errors+=("Please write WP user password at $SECRETS_DIR/wp_user_password.txt")
fi


if [ ${#errors[@]} -gt 0 ]; then
  for error in "${errors[@]}"; do
    echo "$error"
  done
  exit 1
fi

echo "✅ Passwords configured"
