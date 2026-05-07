#!/bin/sh
set -e

# Generate cfg.php from environment variables if not bind-mounted
if [ ! -f /var/www/html/cfg.php ]; then
    cat > /var/www/html/cfg.php <<EOF
<?php
return [
    'app' => [
        'env'    => 'production',
        'debug'  => false,
        'url'    => '${APP_URL:-http://localhost}',
        'pepper' => '${APP_PEPPER:-changeme-set-APP_PEPPER-env}',
        'secret_encryption_key' => '${APP_SECRET_KEY:-}',
        'timezone' => 'Europe/Prague',
        'locale_default' => 'cs',
    ],
    'db' => [
        'host'    => '${MYSQL_ADDON_HOST:-127.0.0.1}',
        'port'    => (int)'${MYSQL_ADDON_PORT:-3306}',
        'name'    => '${MYSQL_ADDON_DB:-myinvoice}',
        'user'    => '${MYSQL_ADDON_USER:-root}',
        'pass'    => '${MYSQL_ADDON_PASSWORD:-changeme}',
        'charset' => 'utf8mb4',
        'socket'  => null,
        'dump_tool' => '',
        'backup_skip_routines' => true,
    ],
    'redis' => [
        'enabled' => false,
        'host'    => '127.0.0.1',
        'port'    => 6379,
        'auth'    => null,
        'db'      => 0,
        'prefix'  => 'myinvoice:prod:',
    ],
    'session' => [
        'driver'        => 'db',
        'lifetime_days' => 30,
        'cookie_name'   => 'myinvoice_session',
        'cookie_secure' => false,
        'cookie_samesite' => 'Lax',
    ],
    'smtp' => [
        'host'           => '${SMTP_HOST:-localhost}',
        'port'           => (int)'${SMTP_PORT:-587}',
        'encryption'     => '${SMTP_ENCRYPTION:-tls}',
        'auth_enabled'   => (bool)'${SMTP_AUTH:-false}',
        'auth_type'      => 'PLAIN',
        'user'           => '${SMTP_USER:-}',
        'pass'           => '${SMTP_PASS:-}',
        'oauth'          => ['provider' => null, 'client_id' => '', 'client_secret' => '', 'refresh_token' => ''],
        'from_email'     => '${SMTP_FROM_EMAIL:-noreply@example.com}',
        'from_name'      => '${SMTP_FROM_NAME:-MyInvoice}',
        'reply_to_email' => '',
        'reply_to_name'  => '',
        'cc_supplier_on_send'     => false,
        'cc_supplier_on_reminder' => false,
        'verify_peer'      => true,
        'verify_peer_name' => true,
        'allow_self_signed'=> false,
        'timeout'        => 30,
        'keepalive'      => false,
        'charset'        => 'UTF-8',
        'encoding'       => '8bit',
        'wordwrap'       => 78,
        'dkim'           => ['enabled' => false, 'domain' => '', 'selector' => 'myinvoice', 'passphrase' => '', 'private_key_path' => '', 'public_key_path' => '', 'dns_doc_path' => ''],
        'debug_level'    => 0,
        'debug_log_file' => '',
        'max_retries'    => 3,
        'retry_delay_s'  => 60,
    ],
    'ares' => [
        'api'       => 'https://ares.gov.cz/ekonomicke-subjekty-v-be/rest/ekonomicke-subjekty',
        'cache_ttl' => 86400,
        'timeout'   => 5,
    ],
    'vies' => [
        'rest_api'  => 'https://ec.europa.eu/taxation_customs/vies/rest-api/ms',
        'wsdl'      => 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService.wsdl',
        'cache_ttl' => 10800,
        'timeout'   => 8,
    ],
    'logging' => [
        'level'    => 'info',
        'path'     => __DIR__ . '/log/app.log',
        'max_files'=> 90,
    ],
    'storage' => [
        'invoices_dir' => __DIR__ . '/storage/invoices',
        'uploads_dir'  => __DIR__ . '/storage/uploads',
        'backup_dir'   => __DIR__ . '/storage/backup',
        'sessions_dir' => __DIR__ . '/storage/sessions',
        'cache_dir'    => __DIR__ . '/storage/cache',
    ],
    'qr' => [
        'czk_constant_symbol' => '0308',
    ],
    'pagination' => [
        'invoices_per_page' => 50,
        'clients_per_page'  => 50,
        'projects_per_page' => 50,
    ],
    'varsymbol' => [
        'templates' => [
            'invoice'     => '{YY}{MM}{CCC}',
            'proforma'    => '9{YY}{MM}{CCC}',
            'credit_note' => '7{YY}{MM}{CCC}',
        ],
    ],
    'rate_limits' => [
        'login_per_min_per_ip'      => 10,
        'forgot_per_hour_per_email' => 3,
        'mutation_per_min_per_user' => 60,
        'read_per_min_per_user'     => 300,
        'ares_per_min_per_user'     => 30,
        'setup_per_hour_per_ip'     => 5,
    ],
    'brute_force' => [
        'captcha_after'   => 5,
        'lockout_15m_at'  => 10,
        'lockout_24h_at'  => 30,
        'window_seconds'  => [300, 900, 3600],
    ],
    'captcha' => [
        'provider'    => 'none',
        'site_key'    => '',
        'secret_key'  => '',
        'verify_url'  => 'https://challenges.cloudflare.com/turnstile/v0/siteverify',
        'script_url'  => 'https://challenges.cloudflare.com/turnstile/v0/api.js',
        'timeout'     => 5,
        'fail_open'   => true,
        'action'      => 'login',
    ],
    'approval' => [
        'token_ttl_days'        => 30,
        'reminder_after_days'   => 5,
        'max_reminders'         => 3,
        'cc_supplier_on_approval'          => true,
        'cc_supplier_on_approval_reminder' => true,
    ],
    'ip_allowlist' => [
        'enabled' => false,
        'mode'    => 'block',
        'allow'   => [],
        'apply_to' => 'all',
        'trusted_proxies' => [],
        'header' => 'X-Forwarded-For',
    ],
    'bank_import' => [
        'scan_root'      => '',
        'allowed_exts'   => ['gpc', 'txt'],
        'auto_match'     => true,
        'partial_match_tolerance' => 1.00,
    ],
    'cron' => [
        'cleanup' => [
            'login_attempts_hours' => 24,
            'password_resets_days' => 7,
            'cache_ttl_days'       => 30,
            'pdf_cache_days'       => 90,
        ],
        'backup' => [
            'daily_retention_days'   => 30,
            'monthly_retention_days' => 365,
            'output_dir'             => 'storage/backup',
        ],
    ],
];
EOF
    chown www-data:www-data /var/www/html/cfg.php
fi

# Run DB migrations automatically
php /var/www/html/api/bin/migrate.php

exec "$@"
