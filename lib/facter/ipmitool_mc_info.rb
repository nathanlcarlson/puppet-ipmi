#!/usr/bin/env ruby
# frozen_string_literal: true

Facter.add(:ipmitool_mc_info) do
  # https://puppet.com/docs/puppet/latest/fact_overview.html
  confine kernel: 'Linux'

  retval = {}
  retval['IPMI_Puppet_Service_Recommend'] = 'stopped'

  if Facter::Util::Resolution.which('ipmitool')
    ipmitool_output = Facter::Util::Resolution.exec('ipmitool mc info 2>/dev/null')

    ipmitool_output.each_line do |line|
      info = line.split(':')
      if info.length == 2 && (info[1].strip != '')
        retval[info[0].strip] = info[1].strip
      end
    end
    if retval.fetch('Device Available', 'no') == 'yes'
      retval['IPMI_Puppet_Service_Recommend'] = 'running'
    end
  end

  setcode do
    retval
  end
end
