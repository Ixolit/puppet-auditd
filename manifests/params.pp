class auditd::params {

  # OS specific variables.
  case $::facts['os']['family'] {
    'Debian': {
      $package_name       = 'auditd'
      $audisp_package     = 'audispd-plugins'
      $manage_audit_files = false
      $rules_file         = '/etc/audit/rules.d/audit.rules'

      if versioncmp($::facts['os']['release']['full'], '11') >= 0 {
        $audisp_dir         = '/etc/audit'
        $has_audisp_config  = false
      } else {
        $audisp_dir         = '/etc/audisp'
        $has_audisp_config  = true
      }

      case $::facts['os']['distro']['release']['major'] {
        '8': {
          $service_restart = '/bin/systemctl restart auditd'
          $service_stop    = '/bin/systemctl stop auditd'
        }
        default: {
          $service_restart = '/etc/init.d/auditd restart'
          $service_stop    = '/etc/init.d/auditd stop'
        }
      }
    }
    'Suse': {
      $package_name       = 'audit'
      $has_audisp_config  = true
      $audisp_dir         = '/etc/audisp'
      if versioncmp($::facts['os']['release']['full'], '12') >= 0 and $::facts['os']['name'] == 'SLES' {
        $audisp_package     = 'audit-audispd-plugins'
        $manage_audit_files = true
        $rules_file         = '/etc/audit/rules.d/puppet.rules'
        $service_restart    = '/bin/systemctl restart auditd'
        $service_stop       = '/bin/systemctl stop auditd'
      }
      else {
        $audisp_package     = 'audispd-plugins'
        $manage_audit_files = false
        $rules_file         = '/etc/audit/audit.rules'
        $service_restart    = '/etc/init.d/auditd restart'
        $service_stop       = '/etc/init.d/auditd stop'
      }
    }
    'RedHat': {
      $package_name       = 'audit'
      $audisp_package     = 'audispd-plugins'
      $manage_audit_files = true

      if versioncmp($::facts['os']['release']['full'], '8') >= 0 {
        $has_audisp_config = false
        $audisp_dir        = '/etc/audit'
      } else {
        $has_audisp_config = true
        $audisp_dir        = '/etc/audisp'
      }

      if $::facts['os']['name'] != 'Amazon' and versioncmp($::facts['os']['release']['full'], '7') >= 0 {
        $rules_file      = '/etc/audit/rules.d/puppet.rules'
        $service_restart = '/usr/libexec/initscripts/legacy-actions/auditd/restart'
        $service_stop    = '/usr/libexec/initscripts/legacy-actions/auditd/stop'
      } else {
        $rules_file      = '/etc/audit/audit.rules'
        $service_restart = '/etc/init.d/auditd restart'
        $service_stop    = '/etc/init.d/auditd stop'
      }
    }
    'Archlinux': {
      $package_name       = 'audit'
      $audisp_package     = 'audit'
      $manage_audit_files = false
      $rules_file         = '/etc/audit/audit.rules'
      $service_restart    = '/usr/bin/kill -s SIGHUP $(cat /var/run/auditd.pid)'
      $service_stop       = '/usr/bin/kill -s SIGTERM $(cat /var/run/auditd.pid)'
      $has_audisp_config  = true
      $audisp_dir         = '/etc/audisp'
    }
    'Gentoo': {
      $package_name       = 'audit'
      $audisp_package     = 'audit'
      $manage_audit_files = false
      $rules_file         = '/etc/audit/audit.rules'
      $service_restart    = '/etc/init.d/auditd restart'
      $service_stop       = '/etc/init.d/auditd stop'
      $has_audisp_config  = true
      $audisp_dir         = '/etc/audisp'
    }
    default: {
      fail("${::facts['os']['family']} is not supported by auditd")
    }
  }

  # Main config file variables
  $log_file                = '/var/log/audit/audit.log'
  $log_format              = 'RAW'
  $log_group               = 'root'
  $write_logs              = undef
  $priority_boost          = '4'
  $flush                   = 'incremental_async'
  $freq                    = '20'
  $num_logs                = '5'
  $disp_qos                = 'lossy'
  $dispatcher              = '/sbin/audispd'
  $name_format             = 'none'
  $admin                   = $::hostname
  $max_log_file            = '6'
  $max_log_file_action     = 'rotate'
  $space_left              = '75'
  $space_left_action       = 'syslog'
  $action_mail_acct        = 'root'
  $admin_space_left        = '50'
  $admin_space_left_action = 'suspend'
  $disk_full_action        = 'suspend'
  $disk_error_action       = 'suspend'
  $tcp_listen_port         = undef
  $tcp_listen_queue        = '5'
  $tcp_max_per_addr        = '1'
  $tcp_client_ports        = undef
  $tcp_client_max_idle     = '0'
  $enable_krb5             = 'no'
  $krb5_principal          = 'auditd'
  $krb5_key_file           = undef

  # Rules Header variables
  $buffer_size      = '8192'
  $continue_loading = false

  # Audisp main config variables
  $audisp_q_depth          = 80
  $audisp_overflow_action  = 'syslog'
  $audisp_priority_boost   = 4
  $audisp_max_restarts     = 10
  $audisp_name_format      = 'none'
  $audisp_name             = undef

  # Give the option of managing the service.
  $manage_service         = true
  $service_ensure         = 'running'
  $service_enable         = true
}
