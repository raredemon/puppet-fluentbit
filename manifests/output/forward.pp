# @summary Plugin to output logs to a configured elasticsearch instance
#
# @param configfile
#  Path to the output configfile. Naming should be output_*.conf to make sure
#  it's getting included by the main config.
# @param match
#  Tag to route the output.
# @param listen
#  IP address or hostname of the target Elasticsearch instance
# @param port
#  TCP port of the target Elasticsearch instance
# @param time_as_integer
#  Set timestamps in integer format
# @param upstream
#  If Forward will connect to an Upstream instead of a simple host,
#  this property defines the absolute path for the Upstream configuration file
# @param unix_path
#  Specify the path to unix socket to send a Forward message.
#  If set, Upstream is ignored.
# @param tag
#  Overwrite the tag as we transmit.
# @param send_options
#  Always send options (with "size"=count of messages)
# @param require_ack_response
#  Send "chunk"-option and wait for "ack" response from server.
#  Enables at-least-once and receiving server can control rate of traffic.
# @param compress
#  Set to "gzip" to enable gzip compression.
#  Incompatible with Time_as_Integer=True and
#  tags set dynamically using the Rewrite Tag filter.
# @param workers
#  Enables dedicated thread(s) for this output.
#  Default value is set since version 1.8.13. For previous versions is 0.
# @param shared_key
#  A key string known by the remote Fluentd used for authorization.
# @param empty_shared_key
#  Use this option to connect to Fluentd with a zero-length secret.
# @param username
#  Specify the username to present to a Fluentd server that enables user_auth.
# @param password
#  Specify the password corresponding to the username.
# @param self_hostname
#  Default value of the auto-generated certificate common name (CN).
# @param tls
#  Enable or disable TLS support
# @param tls_verify
#  Force certificate validation
# @param tls_debug
#  Set TLS debug verbosity level. It accept the following values:
#  0 (No debug), 1 (Error), 2 (State change), 3 (Informational) and 4 Verbose
# @param tls_ca_file
#  Absolute path to CA certificate file
# @param tls_crt_file
#  Absolute path to Certificate file.
# @param tls_key_file
#  Absolute path to private Key file.
# @param tls_key_passwd
#  Optional password for tls.key_file file.
# @example
#  include fluentbit::output::forward
define fluentbit::output::forward (
  Stdlib::Host $host                      = '127.0.0.1',
  Stdlib::Port $port                      = 24224,
  String $configfile                      = "/etc/td-agent-bit/output_forward_${name}.conf",
  String $match                           = '*',
  Boolean $time_as_integer                = false,
  Integer $tls_debug                      = 1,
  Integer $workers                        = 2,
  Optional[Boolean] $require_ack_response = false,
  Optional[Boolean] $send_options         = false,
  Optional[String] $compress              = undef,
  Optional[String] $empty_shared_key      = undef,
  Optional[String] $password              = undef,
  Optional[String] $self_hostname         = undef,
  Optional[String] $shared_key            = undef,
  Optional[String] $tag                   = undef,
  Optional[String] $tls_ca_file           = undef,
  Optional[String] $tls_crt_file          = undef,
  Optional[String] $tls_key_file          = undef,
  Optional[String] $tls_key_passwd        = undef,
  Optional[String] $unix_path             = undef,
  Optional[String] $upstream              = undef,
  Optional[String] $username              = undef,
  Optional[Enum['On', 'Off']] $tls        = undef,
  Enum['On', 'Off'] $tls_verify           = 'On',
) {
  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/output/forward.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
