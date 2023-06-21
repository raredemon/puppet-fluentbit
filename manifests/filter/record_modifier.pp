# @summary The Record Modifier Filter plugin allows to append fields or to exclude specific fields.
#
# @param record
#  Append fields. This parameter needs key and value pair.
# @param remove_key
#  If the key is matched, that field is removed.
# @param allowlist_key
#  If the key is not matched, that field is removed.
# @param whitelist_key
#  An alias of Allowlist_key for backwards compatibility.
# @example
#   fluentbit::filter::modify { 'namevar': }
define fluentbit::filter::modify (
  String $configfile      = '/etc/td-agent-bit/filter_modify.conf',
  String $match           = '*',
  Optional $allowlist_key = undef,
  Optional $record        = undef,
  Optional $remove_key    = undef,
  Optional $whitelist_key = undef,

) {
  # create filter_modify.conf
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/modify.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
