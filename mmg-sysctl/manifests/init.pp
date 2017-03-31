# == Class: sysctl
#
class sysctl {

  # nested class/define
  define conf ( $value ) {

    # $name is provided by define invocation

    # guid of this entry
    $key = $name

    $context = "/files/etc/sysctl.conf"

     augeas { "sysctl_conf/$key":
       context => "$context",
       onlyif  => "get $key != '$value'",
       changes => "set $key '$value'",
       notify  => Exec["sysctl"],
     }

  }

   file { "sysctl_conf":
      name => $operatingsystem ? {
        default => "/etc/sysctl.conf",
      },
   }

   exec { "/sbin/sysctl -p":
      alias => "sysctl",
      refreshonly => true,
      subscribe => File["sysctl_conf"],
   }

}
