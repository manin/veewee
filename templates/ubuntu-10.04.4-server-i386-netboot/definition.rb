Veewee::Definition.declare({
  :cpu_count => '1',
  :memory_size=> '384',
  :disk_size => '10140',
  :disk_format => 'VDI',
  :hostiocache => 'off',
  :os_type_id => 'Ubuntu',
  :iso_file => "ubuntu-10.04.x-server-i386-netboot.iso",
  :iso_src => "http://archive.ubuntu.com/ubuntu/dists/lucid/main/installer-i386/current/images/netboot/mini.iso",
  :iso_md5 => "7b383bcf55f09b1bb7e6614ed6e67a0e",
  :iso_download_timeout => "1000",
  :boot_wait => "10",
  :boot_cmd_sequence => [
    'linux noapic preseed/url=http://%IP%:%PORT%/preseed.cfg ',
    'debian-installer=en_US auto locale=en_US kbd-chooser/method=us ',
    'hostname=%NAME% ',
    'fb=false debconf/frontend=noninteractive ',
    'console-setup/ask_detect=false console-setup/modelcode=pc105 console-setup/layoutcode=us ',
    'initrd=initrd.gz -- <Enter>'
   ],
  :kickstart_port => "7122",
  :kickstart_timeout => "300",
  :kickstart_file => "preseed.cfg",
  :ssh_login_timeout => "10000",
  :ssh_user => "vagrant",
  :ssh_password => "vagrant",
  :ssh_key => "",
  :ssh_host_port => "7222",
  :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "shutdown -P now",
  :postinstall_files => [
    "base.sh",
    "vagrant.sh",
    "virtualbox.sh",
    #"vmfusion.sh",
    "ruby.sh",
    "puppet.sh",
    "chef.sh",
    "cleanup.sh",
    "zerodisk.sh",
  ],
  :postinstall_timeout => "10000"
})
