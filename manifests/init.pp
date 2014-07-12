class devusr (
    $username  = "amarks",
    $usergroup = $username,
    $comment   = "Developer",
    $shell     = "/bin/bash",
    $key       = "#No Key"
){

    #Default Path
    $defpath   = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"

    group { 'devusr-grp':
        name   => $usergroup,
        ensure => 'present',
    }

    user { 'devusr':
        name       => $username,
        ensure     => present,
        comment    => $comment,
        home       => "/home/$username",
        shell      => $shell,
        gid        => $username,
        managehome => true,
        require    => Group['devusr-grp']
    }

    file { 'devusr-sshdir':
        name    => "/home/$username/.ssh",
        mode    => 0700,
        owner   => $username,
        group   => $username,
        ensure  => directory,
        require => User['devusr']
    }

    file { 'devusr-srcdir':
        name    => "/home/$username/src",
        mode    => 0700,
        owner   => $username,
        group   => $username,
        ensure  => directory,
        require => User['devusr']
    }

    file { 'devusr-id-rsa':
        name    => "/home/$username/.ssh/id_rsa",
        mode    => 0600,
        owner   => $username,
        group   => $username,
        ensure  => file,
        content => $key,
        require => File['devusr-sshdir']
    }

    exec { 'devusr-password':
        command => "echo 'password' | passwd --stdin $username",
        provider => shell,
        user    => 'root',
        cwd     => "/root/",
        path    => $defpath,
        #unless  => "grep $username /etc/shadow | grep '!!'",
    }
}
