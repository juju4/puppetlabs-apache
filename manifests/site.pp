# https://www.digitalocean.com/community/tutorials/getting-started-with-puppet-code-manifests-and-modules
node default {
  class { 'apache': 
    mpm_module => 'prefork',
  }
  include apache::mod::security
  include apache::mod::php

apache::vhost { 'www.example.com':
  docroot     => '/var/www/html',
  access_log_file => 'www_vhost.log',
  error_log_file  => 'www_vhost_error.log',
  directories => [
    {
      'path'         => '/var/www/html',
      'ServerTokens' => 'prod' ,
    },
    {
      'path'     => '(\.swp|\.bak|~|\.svn|\.git|\.ht*)$',
      'provider' => 'filesmatch',
      'deny'     => 'from all'
    },
  ],
  rewrites   => [
    {
      comment      => 'redirect non-SSL traffic to SSL site',
      rewrite_cond => ['%{HTTPS} off'],
      rewrite_rule => ['(.*) https://%{HTTP_HOST}%{REQUEST_URI}'],
    }
  ],
  headers => [
#    {
      'Set X-Robots-Tag "noindex, noarchive, nosnippet"',
#      'Set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; connect-src 'self'; img-src 'self'; style-src 'self' 'unsafe-inline'; object-src 'self'; upgrade-insecure-requests; report-uri /csp/report.php"'
#    }
  ],
}

apache::vhost { 'ssl.example.com':
  port    => '443',
  docroot => '/var/www/html',
  access_log_file => 'ssl_vhost.log',
  error_log_file  => 'ssl_vhost_error.log',
  ssl     => true,
#  ssl_cert             => '/etc/ssl/securedomain.cert',
#  ssl_key              => '/etc/ssl/securedomain.key',
#  ssl_chain            => '/etc/ssl/securedomain.crt',
#  ssl_protocol         => '',
#  ssl_cipher           => '',
  ssl_honorcipherorder => 'On',
  directories => [
    {
      'path'         => '/var/www/html',
      'ServerTokens' => 'prod' ,
    },
    {
      'path'     => '(\.swp|\.bak|~|\.svn|\.git|\.ht*)$',
      'provider' => 'filesmatch',
      'deny'     => 'from all'
    },
  ],
}

#apache::mod::security { 'ssl.example.com':
# https://www.laterpay.net/blog/2016/3/30/modsecurity-and-puppet-spelunking
# audit_log_parts => 'ABZ' 
#
#  activated_rules => [
#    'modsecurity_35_bad_robots.data',
#    'modsecurity_35_scanners.data',
#    'modsecurity_40_generic_attacks.data',
#    'modsecurity_50_outbound.data',
#    'modsecurity_50_outbound_malware.data',
#    'modsecurity_crs_20_protocol_violations.conf',
#    'modsecurity_crs_21_protocol_anomalies.conf',
#    'modsecurity_crs_23_request_limits.conf',
#    'modsecurity_crs_30_http_policy.conf',
#    'modsecurity_crs_35_bad_robots.conf',
#    'modsecurity_crs_40_generic_attacks.conf',
#    'modsecurity_crs_41_sql_injection_attacks.conf',
#    'modsecurity_crs_41_xss_attacks.conf',
#    'modsecurity_crs_42_tight_security.conf',
#    'modsecurity_crs_45_trojans.conf',
#    'modsecurity_crs_47_common_exceptions.conf',
#    'modsecurity_crs_49_inbound_blocking.conf',
#    'modsecurity_crs_50_outbound.conf',
#    'modsecurity_crs_59_outbound_blocking.conf',
#    'modsecurity_crs_60_correlation.conf'
#  ],
#}

}
