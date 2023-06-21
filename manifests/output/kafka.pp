# @summary Plugin to output logs to a configured Kafka instance
#
# @param configfile
#  Path to the output configfile. Naming should be output_*.conf to make sure
#  it's getting included by the main config.
# @param format
#  Specify data format, options available: json, msgpack
# @param match
#  Tag to route the output.
# @param brokers
#  Array of IP addresses or hostnames of the target Kafka instances, e.g: 192.168.1.3:9092, 192.168.1.4:9092.
# @param message_key
#  Optional key to store the message
# @param message_key_field
#  If set, the value of Message_Key_Field in the record will indicate the message key
# @param timestamp_key
#  Set the key to store the record timestamp
# @param timestamp_format
#  Specify timestamp format, should be 'double', 'iso8601' (seconds precision) or
#  'iso8601_ns' (fractional seconds precision)
# @param topics
#  Single entry or list of topics separated by comma (,) that Fluent Bit will use to send messages to Kafka.
# @param topic_key
#  If multiple Topics exists, the value of TopicKey in the record will indicate the topic to use.
# @param dynamic_topic
#  Adds unknown topics (found in Topic_Key) to Topics. So in Topics only a default topic needs to be configured
# @param queue_full_retries
#  Fluent Bit queues data into rdkafka library
# @example
#  include fluentbit::output::kafka
define fluentbit::output::kafka (
  Array $brokers                   = ['127.0.0.1'],
  Integer $queue_full_retries         = 10,
  Optional[String] $message_key       = undef,
  Optional[String] $message_key_field = undef,
  Optional[String] $timestamp_format  = 'double',
  Optional[String] $timestamp_key     = '@timestamp',
  String $configfile                  = "/etc/td-agent-bit/output_kafka_${name}.conf",
  String $match                       = '*',
  String $topic_key                   = 'topic',
  String $topics                      = 'vector',
  Enum ['json', 'msgpack'] $format    = 'json',
  Enum['on', 'off'] $dynamic_topic    = 'on',
) {
  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/output/kafka.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
