class vault_enterprise_setup {

  include ::firewall

  if $::hostname == 'primary-vault' {
    notify { 'Setting up primary Vault cluster with Raft storage on-premises': }

    class { 'vault':
      manage_repo  => true,
      version      => '1.11.3',
      config_hash  => {
        'storage' => {
          'raft' => {
            'path'      => '/opt/vault/data',
            'node_id'   => 'primary-vault',
          },
        },
        'listener' => {
          'tcp' => {
            'address'      => '0.0.0.0:8200',
            'tls_disable'  => 1,
          },
        },
        'api_addr'     => 'http://primary-vault:8200',
        'cluster_addr' => 'https://primary-vault:8201',
        'ui'           => true,
      },
    }

    file { '/etc/vault.d/vault.service':
      ensure  => 'file',
      source  => 'puppet:///modules/vault_enterprise_setup/vault.service',
      mode    => '0644',
    }

    service { 'vault':
      ensure    => 'running',
      enable    => true,
      require   => Package['vault'],
    }

  } elsif $::hostname == 'dr-vault' {
    notify { 'Setting up DR Vault cluster with Raft storage on GCP': }

    class { 'vault':
      manage_repo  => true,
      version      => '1.11.3',
      config_hash  => {
        'storage' => {
          'raft' => {
            'path'      => '/opt/vault/data',
            'node_id'   => 'dr-vault',
          },
        },
        'listener' => {
          'tcp' => {
            'address'      => '0.0.0.0:8200',
            'tls_disable'  => 1,
          },
        },
        'api_addr'     => 'http://dr-vault:8200',
        'cluster_addr' => 'https://dr-vault:8201',
        'ui'           => true,
      },
    }

    file { '/etc/vault.d/vault.service':
      ensure  => 'file',
      source  => 'puppet:///modules/vault_enterprise_setup/vault.service',
      mode    => '0644',
    }

    service { 'vault':
      ensure    => 'running',
      enable    => true,
      require   => Package['vault'],
    }
  }
}
