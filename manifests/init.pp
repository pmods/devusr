class devusr (
    $username  = "amarks",
    $usergroup = $username,
    $comment   = "Developer",
    $shell     = "/bin/bash",
    $key       = "#No Key"
){

    group { 'devusr-grp':
        name   => $usergroup,
        ensure => 'present',
    }

    user { 'devusr':
        name       => $username,
        ensure     => present,
        comment    => $comment,
        home       => "/home/$devusr",
        shell      => $shell,
        gid        => $devusr,
        managehome => true,
        require    => Group['devusr-grp']
    }

    file { 'devusr-sshdir':
        name    => "/home/$devusr/.ssh",
        mode    => 0700,
        owner   => $devusr,
        group   => $devusr,
        ensure  => directory,
        require => User['devusr']
    }

    file { 'devusr-srcdir':
        name    => "/home/$devusr/src",
        mode    => 0700,
        owner   => $devusr,
        group   => $devusr,
        ensure  => directory,
        require => User['devusr']
    }

    file { 'devusr-id-rsa':
        name    => "/home/$devusr/.ssh/id_rsa",
        mode    => 0600,
        owner   => $devusr,
        group   => $devusr,
        ensure  => file,
        content => $key,
        require => File['devusr-sshdir']
    }
}
